canvas = document.getElementById("c")
ctx = canvas.getContext("2d")

if not ctx
  throw "Loading context failed"

#General functions
randInt = (min, max) ->
  Math.floor( Math.random() * (max - min + 1) ) + min

every = (ms, cb) -> setInterval cb, ms

# Color determines what color does not kill you
# Also used to determine player accurracy
# AKA: bad things happen if GOOD_COLOR === BAD_COLOR
# Could attach separate team marker, but not worth it
GOOD_COLOR = "#0044FF"
BAD_COLOR = "#FF0000"

LASER_SPEED = 20
LASER_LENGTH = 16
BOMB_SPEED = 12
ENEMY_RAND = 0.05

#Here for scope
game = {}
mouseX = 250
mouseY = 200
timeHandle = undefined

initGame = ->
  game =
    lasers: []
    enemies: []
    bombs: []
    shrapnals: []
    crashed: false
    #TODO: Make separator (or contained) player object?
    health: 100

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

  move: ->
    @x = (@x + mouseX) / 2
    @y = (@y + mouseY) / 2

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

class Enemy
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
    game.lasers.push( new Laser( @x, @y, LASER_SPEED, BAD_COLOR ) )

  alive: ->
    return false if @y > canvas.height
    if Math.abs( ship.x - @x ) < 35 and Math.abs( ship.y - @y ) < 35
      game.health -= 24
      return false
    for laser in game.lasers
      #Takes into account color, laser length, laser speed, and ship size
      if laser.color isnt BAD_COLOR and Math.abs(@x - laser.x) <= 12 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10
        laser.killedSomething = true
        return false
    for bomb in game.bombs
      #Takes into account color, bomb size, bomb speed, and ship size
      if bomb.color isnt BAD_COLOR and Math.abs(@x - bomb.x) <= 12 and Math.abs(@y - bomb.y + bomb.speed / 2) <= Math.abs(bomb.speed) / 2 + 12
        bomb.cooldown = 0
        return false
    for shrap in game.shrapnals
      #Takes into account color, shrap size, and ship size
      if shrap.color isnt BAD_COLOR and Math.abs(@x - shrap.x) <= 11 and Math.abs(@y - shrap.y) <= 11
        return false
    true

  update: ->
    @shoot() if @shootCooldown is 0
    @shootCooldown -= 1
    @move()
    @draw()

#Do not yet generate these, a work in progress
class Kamikaze
  constructor: (@x, @y) ->
    @angle = 0
    @shootCooldown = 0

  move: ->
    if Math.abs(@x - ship.x) < 150 and Math.abs(@y - ship.y) < 150
      if @y > ship.y
        @angle = Math.PI - Math.atan( (@x - ship.x) / (@y - ship.y) )
      else
        @angle = - Math.atan( (@x - ship.x) / (@y - ship.y) )
      @x += (ship.x - @x) / 4
      @y += (ship.y - @y) / 4
    else
      @angle = 0
      @y += 1

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

  update: ->
    @move()
    @draw()

class Laser
  constructor: (@x, @y, @speed, @color) ->
    @killedSomething = false

  draw: ->
    ctx.fillStyle = @color
    ctx.fillRect( @x - 1, @y - LASER_LENGTH / 2, 2, LASER_LENGTH )

  move: ->
    @y += @speed

  update: ->
    @move()
    @draw()

class Shrapnal
  constructor: (@x, @y, @angle, @speed, @color) ->
    @cooldown = 10

  move: ->
    @x += (@speed * Math.cos(@angle))
    @y += (@speed * Math.sin(@angle))

  draw: ->
    ctx.fillStyle = @color
    ctx.fillRect( @x - 1, @y - 1, 2, 2 )

  update: ->
    @cooldown -= 1
    @move()
    @draw()

class Bomb
  constructor: (@x, @y, @speed, @color) ->
    @cooldown = 20

  move: ->
    @y += @speed

  explode: ->
    game.shrapnals = game.shrapnals.concat( (new Shrapnal(@x, @y, ang * 36 * Math.PI / 180, @speed, @color) for ang in [0..9]) )

  draw: ->
    ctx.fillStyle = @color
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
  ctx.fillText( "Game Over", canvas.width / 2, canvas.height / 2 )

ctx.fillStyle = "#000000"
ctx.strokeStyle = "#FFFFFF"
ctx.fillRect( 0, 0, canvas.width, canvas.height )
ctx.lineWidth = 4

ship = new Ship(mouseX, mouseY)

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
    mouseX = e.pageX - @offsetLeft
    mouseY = e.pageY - @offsetTop
  )

  .click( (e) ->
    switch currentState
      when gameState.playing
        game.lasers.push( new Laser( ship.x, ship.y, -LASER_SPEED, GOOD_COLOR) )
      when gameState.title
        currentState = gameState.playing
        initGame()
        timeHandle = every 32, gameloop
      when gameState.gameOver
        currentState = gameState.title
        drawTitleScreen()
  )

  .bind("contextmenu", (e) ->
    game.bombs.push( new Bomb( ship.x, ship.y, -BOMB_SPEED, GOOD_COLOR) ) if currentState is gameState.playing
    false
  );

gameloop = ->
  # console.log( "In game loop with state", currentState )

  if game.crashed
    currentState = gameState.crashed
    clearInterval( timeHandle )
    return

  game.crashed = true

  if game.health <= 0
    currentState = gameState.gameOver
    clearInterval( timeHandle )
    drawGameOver()
    return

  clearScreen()

  enemy.update() for enemy in game.enemies
  game.enemies = (enemy for enemy in game.enemies when enemy.alive())
  game.enemies.push( new Enemy( randInt(0, canvas.width), -10 ) ) if Math.random() < ENEMY_RAND

  ship.update()

  laser.update() for laser in game.lasers
  for laser in game.lasers
    #Takes into account color, laser length, laser speed, and ship size
    if laser.color isnt GOOD_COLOR and Math.abs(ship.x - laser.x) <= 12 and Math.abs(ship.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10
      laser.killedSomething = true
      game.health -= 8
  game.lasers = (laser for laser in game.lasers when 0 < laser.y < canvas.height and not laser.killedSomething)
  bomb.update() for bomb in game.bombs
  game.bombs = (bomb for bomb in game.bombs when bomb.cooldown > 0)
  shrapnal.update() for shrapnal in game.shrapnals
  game.shrapnals = (shrapnal for shrapnal in game.shrapnals when shrapnal.cooldown > 0)

  setLowerLeftFont()
  ctx.fillText("Health: " + game.health, 10, canvas.height - 10);

  game.crashed = false

#Can change how game begins based on what you start the state as
switch currentState
  when gameState.playing
    initGame()
    timeHandle = every 32, gameloop
  when gameState.title
    drawTitleScreen()

