define(GOOD_COLOR,`"#0044FF"')dnl
define(BAD_COLOR,`"#FF0000"')dnl
dnl
define(LASER_SPEED,20)dnl
define(LASER_LENGTH,16)dnl
define(BOMB_SPEED,12)dnl
dnl
define(`offscreen', `(@x < 0 or @x > canvas.width or @y < 0 or @y > canvas.height)')dnl
define(`upcase', `translit(`$*', `a-z', `A-Z')')dnl
define(`genship', `game.owners.enemies.units.push( new $1( randInt(0, canvas.width), -10 ) ) if Math.random() < upcase($1)_RAND and game.owners.player.kills >= upcase($1)_THRESHOLD')dnl
dnl
#'
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

include(`ship.m4')
include(`fighter.m4')
include(`kamikaze.m4')
include(`bomber.m4')
include(`laser.m4')
include(`shrapnal.m4')
include(`bomb.m4')
#'
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

    timers:
      dispHealth: 0
      colorCycle: 0
      colorCycleDir: 10

    crashed: false

dispHealth = ->
  ctx.beginPath()
  ctx.arc(canvas.width / 2, canvas.height / 2, Math.min(canvas.width, canvas.height) / 2 - 20, 0, Math.max(game.owners.player.health, 0) * Math.PI / 50, false)
  ctx.stroke()

pause = ->
  currentState = gameState.paused
  clearInterval( timeHandle )
  dispHealth()
  setTitleFont()
  ctx.fillText( "[Paused]", canvas.width / 2, canvas.height / 2)

unpause = ->
  currentState = gameState.playing
  timeHandle = every 32, gameloop

$(document)
  .keyup( (e) ->
    # console.log event.which
    switch event.which
      when 80 # P key
        switch currentState
          when gameState.paused
            unpause()
          when gameState.playing
            pause()
  )

$("#c")
  .mousemove( (e) ->
    mouse.x = e.pageX - @offsetLeft
    mouse.y = e.pageY - @offsetTop
  )

  .mouseout( (e) ->
    pause() if currentState is gameState.playing
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
      when gameState.paused
        unpause()
      when gameState.title
        currentState = gameState.playing
        initGame()
        timeHandle = every 32, gameloop
      when gameState.gameOver
        currentState = gameState.title
        drawTitleScreen()
  )

  .bind("contextmenu", (e) ->
    false
  );

gameloop = ->

  if game.crashed
    currentState = gameState.crashed
    clearInterval( timeHandle )
    return

  game.crashed = true

  game.timers.colorCycle += game.timers.colorCycleDir
  game.timers.colorCycle = Math.min(game.timers.colorCycle, 255)
  game.timers.colorCycle = Math.max(game.timers.colorCycle, 0)
  game.timers.colorCycleDir *= -1 if game.timers.colorCycle is 0 or game.timers.colorCycle is 255

  if game.owners.player.health <= 0
    currentState = gameState.gameOver
    clearInterval( timeHandle )
    drawGameOver()
    return

  clearScreen()

  enemy.update() for enemy in game.owners.enemies.units
  game.owners.enemies.units = (enemy for enemy in game.owners.enemies.units when enemy.alive())
  genship(Fighter)
  genship(Kamikaze)
  genship(Bomber)

  ship.update()

  for ownerName, owner of game.owners
      laser.update() for laser in owner.lasers

  # Takes into account color, laser length, laser speed, and ship size
  for laser in game.owners.enemies.lasers
    if Math.abs(ship.x - laser.x) <= 12 and Math.abs(ship.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10
      laser.killedSomething = true
      game.owners.player.health -= 8
      game.timers.dispHealth = 255

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
      ship.laserCooldown = 7
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

  ctx.textAlign = "center"
  ctx.textBaseline = "bottom"

  if ship.heat > 80
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",0,0)");
    ctx.font = "bold 20px Lucidia Console"
    ctx.fillText( "[ Heat Critical ]", canvas.width / 2, canvas.height - 30)
  else if ship.heat > 40
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",", game.timers.colorCycle, ",0)");
    ctx.font = "normal 18px Lucidia Console"
    ctx.fillText( "[ Heat Warning ]", canvas.width / 2, canvas.height - 30)
  else
    ctx.fillStyle = "#00FF00"


  # TODO: only show just hit
  if game.timers.dispHealth > 0
    ctx.strokeStyle = "rgb(".concat( game.timers.dispHealth , "," , game.timers.dispHealth , "," , game.timers.dispHealth , ")" )
    dispHealth()
    ctx.strokeStyle = "#FFFFFF"
    game.timers.dispHealth -= 10

  game.crashed = false

# Can change how game begins based on what you start the state as
switch currentState
  when gameState.playing
    initGame()
    timeHandle = every 32, gameloop
  when gameState.title
    drawTitleScreen()

