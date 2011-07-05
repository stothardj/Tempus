define(GOOD_COLOR,`"#0044FF"')
define(BAD_COLOR,`"#FF0000"')

define(LASER_SPEED,20)
define(LASER_LENGTH,16)
define(BOMB_SPEED,12)
define(FIGHTER_RAND,0.05)
define(KAMIKAZE_RAND,0.02)
define(KAMIKAZE_THRESHOLD,15)

canvas = document.getElementById("c")
ctx = canvas.getContext("2d")

if not ctx
  throw "Loading context failed"

# General functions
randInt = (min, max) ->
  Math.floor( Math.random() * (max - min + 1) ) + min

every = (ms, cb) -> setInterval cb, ms

# Here for scope
game = undefined
ship = undefined

mouse = {
  x: 250
  y: 200
  leftDown: false
  rightDown: false
}

timeHandle = undefined


gameState =
  title: "Title"
  gameover: "GameOver"
  playing: "Playing"
  paused: "Paused"
  crashed: "Crashed"

currentState = gameState.title

# Should it really be a class if it seems I really only ever make one of them?
class Ship
  constructor: (@x, @y) ->
    @laserCooldown = 0
    @bombCooldown = 0
    @heat = 0

  move: ->
    @x = (@x + mouse.x) / 2
    @y = (@y + mouse.y) / 2

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.beginPath()
    ctx.moveTo( @x, @y - 20 )
    ctx.quadraticCurveTo( @x + 20, @y, @x + 20, @y + 20 )
    ctx.quadraticCurveTo( @x + 5, @y + 10, @x, @y + 10)
    ctx.quadraticCurveTo( @x - 5, @y + 10, @x - 20, @y + 20 )
    ctx.quadraticCurveTo( @x - 20, @y, @x, @y - 20 )
    ctx.closePath()
    ctx.stroke()

  update: ->
    @move()
    @draw()

class Fighter
  constructor: (@x, @y) ->
    @shootCooldown = 0

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.beginPath()
    ctx.moveTo( @x - 10, @y - 10 )
    ctx.lineTo( @x + 10, @y - 10 )
    ctx.lineTo( @x, @y + 10 )
    # ctx.lineTo( @x - 10, @y - 10 ) Default behavior when closing path anyway
    ctx.closePath()
    ctx.stroke()

  move: ->
    @y += 3
    mv = (ship.x - @x) / 12
    @x += if Math.abs(mv) < 5 then mv else 5 * mv/Math.abs(mv)

  shoot: ->
    @shootCooldown = 35
    game.owners.enemies.lasers.push( new Laser( @x, @y, LASER_SPEED, game.owners.enemies ) )

  alive: ->
    return false if @y > canvas.height
    if Math.abs( ship.x - @x ) < 35 and Math.abs( ship.y - @y ) < 35
      game.owners.player.health -= 24
      game.owners.player.kills += 1
      return false
    for laser in game.owners.player.lasers
      # Takes into account color, laser length, laser speed, and ship size
      if Math.abs(@x - laser.x) <= 12 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10
        laser.killedSomething = true
        game.owners.player.kills += 1
        return false
    for bomb in game.owners.player.bombs
      # Takes into account color, bomb size, bomb speed, and ship size
      if Math.abs(@x - bomb.x) <= 12 and Math.abs(@y - bomb.y + bomb.speed / 2) <= Math.abs(bomb.speed) / 2 + 12
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return false
    for shrap in game.owners.player.shrapnals
      # Takes into account color, shrap size, and ship size
      if Math.abs(@x - shrap.x) <= 11 and Math.abs(@y - shrap.y) <= 11
        game.owners.player.kills += 1
        return false
    true

  update: ->
    @shoot() if @shootCooldown is 0
    @shootCooldown -= 1
    @move()
    @draw()

# Do not yet generate these, a work in progress. Switch to new structure when uncomment
class Kamikaze
  constructor: (@x, @y) ->
    @angle = 0
    @shootCooldown = 0
    @moveState = 0

  move: ->
    switch @moveState
      when 0 # Wandering down
        if Math.abs(@x - ship.x) < 150 and Math.abs(@y - ship.y) < 150
          @moveState = 1
        else
          @angle = 0
          @y += 1
      when 1 # Detected ship, turn to face
        if @y > ship.y
          desired_angle = Math.PI - Math.atan( (@x - ship.x) / (@y - ship.y) )
        else
          desired_angle = - Math.atan( (@x - ship.x) / (@y - ship.y) )
        if Math.abs(desired_angle - @angle) < (Math.PI / 24) or Math.abs(desired_angle - @angle) > Math.PI * 2 - (Math.PI / 24)
          @angle = desired_angle
          @moveState = 2
        else if (@angle < desired_angle and @angle - desired_angle < Math.PI) or (Math.PI * 2 - @angle) - desired_angle < Math.PI
          @angle += Math.PI / 24
        else
          @angle -= Math.PI / 24
      when 2 # Charge
        @x += 30 * Math.cos(@angle + Math.PI / 2)
        @y += 30 * Math.sin(@angle + Math.PI / 2)

  draw: ->
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( -10, -10 )
    ctx.lineTo( 10, -10 )
    ctx.lineTo( 10, 4 )
    ctx.lineTo( 0, 10 )
    ctx.lineTo( -10, 4 )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  alive: ->
    return false if @y > canvas.height or @moveState and (@x < 0 or @x > canvas.width or @y < 0)
    if Math.abs( ship.x - @x ) < 35 and Math.abs( ship.y - @y ) < 35
      game.owners.player.kills += 1
      game.owners.player.health -= 35
      return false
    for laser in game.owners.player.lasers
      # Takes into account color, laser length, laser speed, and ship size
      if Math.abs(@x - laser.x) <= 12 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10
        laser.killedSomething = true
        game.owners.player.kills += 1
        return false
    for bomb in game.owners.player.bombs
      # Takes into account color, bomb size, bomb speed, and ship size
      if Math.abs(@x - bomb.x) <= 12 and Math.abs(@y - bomb.y + bomb.speed / 2) <= Math.abs(bomb.speed) / 2 + 12
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return false
    for shrap in game.owners.player.shrapnals
      # Takes into account color, shrap size, and ship size
      if Math.abs(@x - shrap.x) <= 11 and Math.abs(@y - shrap.y) <= 11
        game.owners.player.kills += 1
        return false
    true

  update: ->
    @move()
    @draw()

class Laser
  constructor: (@x, @y, @speed, @owner) ->
    @killedSomething = false

  draw: ->
    ctx.fillStyle = @owner.color
    ctx.fillRect( @x - 1, @y - LASER_LENGTH / 2, 2, LASER_LENGTH )

  move: ->
    @y += @speed

  update: ->
    @move()
    @draw()

class Shrapnal
  constructor: (@x, @y, @angle, @speed, @owner) ->
    @cooldown = 10

  move: ->
    @x += (@speed * Math.cos(@angle))
    @y += (@speed * Math.sin(@angle))

  draw: ->
    ctx.fillStyle = @owner.color
    ctx.fillRect( @x - 1, @y - 1, 2, 2 )

  update: ->
    @cooldown -= 1
    @move()
    @draw()

class Bomb
  constructor: (@x, @y, @speed, @owner) ->
    @cooldown = 20

  move: ->
    @y += @speed

  explode: ->
    @owner.shrapnals = @owner.shrapnals.concat( (new Shrapnal(@x, @y, ang * 36 * Math.PI / 180, @speed, @owner) for ang in [0..9]) )

  draw: ->
    ctx.fillStyle = @owner.color
    ctx.fillRect( @x - 2, @y - 2, 4, 4 )

  update: ->
    @cooldown -= 1
    @explode() if @cooldown <= 0
    @move()
    @draw()

setTitleFont = ->
  ctx.fillStyle = "#FFFFFF"
  ctx.font = "bold 20px Lucidia Console"
  ctx.textAlign = "center"
  ctx.textBaseline = "middle"

setLowerLeftFont = ->
  ctx.fillStyle = "#FFFFFF"
  ctx.font = "normal 18px Lucidia Console"
  ctx.textAlign = "left"
  ctx.textBaseline = "bottom"

clearScreen = ->
  ctx.fillStyle = "#000000"
  ctx.fillRect( 0, 0, canvas.width, canvas.height)

drawTitleScreen = ->
  clearScreen()
  setTitleFont()
  ctx.fillText( "Tempus [Dev]", canvas.width / 2, canvas.height / 2 - 12 )
  ctx.fillText( "Click to play", canvas.width / 2, canvas.height / 2 + 12)
  setLowerLeftFont()
  ctx.fillText( "by Jake Stothard", 10, canvas.height - 10)

drawGameOver = ->
  clearScreen()
  setTitleFont()
  ctx.fillText( "Game Over", canvas.width / 2, canvas.height / 2 - 20 )
  ctx.font = "normal 18px Lucidia Console"
  ctx.fillText( "Kills - " + game.owners.player.kills, canvas.width / 2, canvas.height / 2)
  ctx.fillText( "Lasers Fired - " + game.owners.player.lasers_fired, canvas.width / 2, canvas.height / 2 + 20 )
  ctx.fillText( "Bombs Used - " + game.owners.player.bombs_fired, canvas.width / 2, canvas.height / 2 + 40 )

ctx.strokeStyle = "#FFFFFF"
ctx.lineWidth = 4

initGame = ->
  ship = new Ship(mouse.x, mouse.y)

  game =
    owners:
      player:
        lasers: []
        bombs: []
        shrapnals: []
        units: ship
        color: GOOD_COLOR
        health: 100
        kills: 0
        lasers_fired: 0
        bombs_fired: 0

      enemies:
        lasers: []
        bombs: []
        shrapnals: []
        units: []
        color: BAD_COLOR

    crashed: false

$(document)
  .keyup( (e) ->
    # console.log event.which
    switch event.which
      when 80 # P key
        switch currentState
          when gameState.paused
            currentState = gameState.playing
            timeHandle = every 32, gameloop
          when gameState.playing
            currentState = gameState.paused
            clearInterval( timeHandle )
            setTitleFont()
            ctx.fillText( "[Paused]", canvas.width / 2, canvas.height / 2)
  )

$("#c")
  .mousemove( (e) ->
    mouse.x = e.pageX - @offsetLeft
    mouse.y = e.pageY - @offsetTop
  )

  .mousedown( (e) ->
    console.log e.which
    switch (e.which)
      when 1
        mouse.leftDown = true
      when 3
        mouse.rightDown = true
  )

  .mouseup( (e) ->
    console.log e.which
    switch (e.which)
      when 1
        mouse.leftDown = false
      when 3
        mouse.rightDown = false
  )

  .click( (e) ->
    switch currentState
      # when gameState.playing
      #   game.owners.player.lasers.push( new Laser( ship.x, ship.y, -LASER_SPEED, game.owners.player) )
      when gameState.title
        currentState = gameState.playing
        initGame()
        timeHandle = every 32, gameloop
      when gameState.gameOver
        currentState = gameState.title
        drawTitleScreen()
  )

  .bind("contextmenu", (e) ->
    # game.owners.player.bombs.push( new Bomb( ship.x, ship.y, -BOMB_SPEED, game.owners.player) ) if currentState is gameState.playing
    false
  );

gameloop = ->

  if game.crashed
    currentState = gameState.crashed
    clearInterval( timeHandle )
    return

  game.crashed = true

  if game.owners.player.health <= 0
    currentState = gameState.gameOver
    clearInterval( timeHandle )
    drawGameOver()
    return

  clearScreen()

  enemy.update() for enemy in game.owners.enemies.units
  game.owners.enemies.units = (enemy for enemy in game.owners.enemies.units when enemy.alive())
  game.owners.enemies.units.push( new Fighter( randInt(0, canvas.width), -10 ) ) if Math.random() < FIGHTER_RAND
  game.owners.enemies.units.push( new Kamikaze( randInt(0, canvas.width), -10 ) ) if Math.random() < KAMIKAZE_RAND and game.owners.player.kills > KAMIKAZE_THRESHOLD

  ship.update()

  for ownerName, owner of game.owners
      laser.update() for laser in owner.lasers

  # Takes into account color, laser length, laser speed, and ship size
  for laser in game.owners.enemies.lasers
    if Math.abs(ship.x - laser.x) <= 12 and Math.abs(ship.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10
      laser.killedSomething = true
      game.owners.player.health -= 8

  for ownerName, owner of game.owners
    owner.lasers = (laser for laser in owner.lasers when 0 < laser.y < canvas.height and not laser.killedSomething)

  for ownerName, owner of game.owners
    bomb.update() for bomb in owner.bombs

  for ownerName, owner of game.owners
    owner.bombs = (bomb for bomb in owner.bombs when bomb.cooldown > 0)

  for ownerName, owner of game.owners
    shrapnal.update() for shrapnal in owner.shrapnals

  for ownerName, owner of game.owners
    owner.shrapnals = (shrapnal for shrapnal in owner.shrapnals when shrapnal.cooldown > 0)

  if mouse.leftDown and ship.laserCooldown <= 0
    game.owners.player.lasers_fired += 1
    game.owners.player.lasers.push( new Laser( ship.x, ship.y, -LASER_SPEED, game.owners.player) )
    if ship.heat > 80
      ship.laserCooldown = 10
    else if ship.heat > 40
      ship.laserCooldown = 5
    else
      ship.laserCooldown = 2
    ship.heat += 7

  if mouse.rightDown and ship.bombCooldown <= 0
    game.owners.player.bombs_fired += 1
    game.owners.player.bombs.push( new Bomb( ship.x, ship.y, -BOMB_SPEED, game.owners.player) ) if currentState is gameState.playing
    if ship.heat > 80
      ship.bombCooldown = 20
    else if ship.heat > 40
      ship.bombCooldown = 10
    else
      ship.bombCooldown = 5
    ship.heat += 10

  ship.laserCooldown -= 1 if ship.laserCooldown > 0
  ship.bombCooldown -= 1 if ship.bombCooldown > 0
  ship.heat -= 1 if ship.heat > 0

  setLowerLeftFont()
  ctx.fillText("Health: " + game.owners.player.health, 10, canvas.height - 10);

  ctx.textAlign = "right"
  if ship.heat > 80
    ctx.fillStyle = "#FF0000"
  else if ship.heat > 40
    ctx.fillStyle = "#FFFF00"
  else
    ctx.fillStyle = "#00FF00"
  ctx.fillText("Heat: " + ship.heat, canvas.width - 10, canvas.height - 10)

  game.crashed = false

# Can change how game begins based on what you start the state as
switch currentState
  when gameState.playing
    initGame()
    timeHandle = every 32, gameloop
  when gameState.title
    drawTitleScreen()

