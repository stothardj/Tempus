# This file is part of Tempus.
#
# Tempus is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Tempus is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Tempus.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright 2011 Jake Stothard
define(GOOD_COLOR,`"#0044FF"')dnl
define(BAD_COLOR,`"#FF0000"')dnl
# Constants separated from classes so they can be included in any order
include(`bomb_h.m4')dnl
include(`bomber_h.m4')dnl
include(`fighter_h.m4')dnl
include(`kamikaze_h.m4')dnl
include(`laser_h.m4')dnl
include(`ship_h.m4')dnl
include(`shrapnal_h.m4')dnl
# Taken from GNU
define(`upcase', `translit(`$*', `a-z', `A-Z')')dnl
# Macro definitions to avoid repeated code
define(`offscreen', `(@x < 0 or @x > canvas.width or @y < 0 or @y > canvas.height)')dnl
define(`drawAsBox', `ctx.fillStyle = @owner.color;ctx.fillRect( @x - eval(upcase($1)_WIDTH / 2), @y - eval(upcase($1)_HEIGHT / 2), upcase($1)_WIDTH, upcase($1)_HEIGHT )')dnl
define(`boxHit', `(Math.abs( $1.x - @x ) < eval((upcase($1)_WIDTH + upcase($2)_WIDTH) / 2) and Math.abs( $1.y - @y ) < eval((upcase($1)_HEIGHT + upcase($2)_HEIGHT) / 2))')dnl
define(`genship', `game.owners.enemies.units.push( new $1( randInt(0, canvas.width), -10 ) ) if Math.random() < upcase($1)_RAND and game.owners.player.kills >= upcase($1)_THRESHOLD')dnl
#'
canvas = document.getElementById("c")
ctx = canvas.getContext("2d")
audio = $('<audio></audio>')
  .attr({ 'loop' : 'loop'})
  .append($('<source><source>')
  .attr({ 'src' : 'media/tonight_full.ogg'})
  ).appendTo('body')[0];

if not ctx
  throw "Loading context failed"

# General functions
randInt = (min, max) ->
  Math.floor( Math.random() * (max - min + 1) ) + min

every = (ms, cb) -> setInterval cb, ms

# Here for scope
game = undefined
ship = undefined
firstTime = true
musicPlaying = false

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

# Included after globals are defined so they can refer to them
include(`bomb.m4')
include(`bomber.m4')
include(`fighter.m4')
include(`kamikaze.m4')
include(`laser.m4')
include(`ship.m4')
include(`shrapnal.m4')
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

firstInit = ->
  if $("#enableMusic")[0].checked
    audio.play()
    musicPlaying = true
  firstTime = false

initGame = ->
  firstInit() if firstTime
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
    # console.log e.which
    switch (e.which)
      when 1
        mouse.leftDown = true
      when 3
        mouse.rightDown = true
  )

  .mouseup( (e) ->
    # console.log e.which
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

$("#enableMusic")
  .change( (e) ->
    if not firstTime
      if $("#enableMusic")[0].checked
        audio.play()
        musicPlaying = true
      else
        audio.pause()
        musicPlaying = false
  )


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

  # Takes into account owner, laser length, laser speed, and ship size
  for laser in game.owners.enemies.lasers
    if Math.abs(ship.x - laser.x) <= 12 and Math.abs(ship.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_HEIGHT) / 2 + 10
      laser.killedSomething = true
      game.owners.player.health -= 8
      game.timers.dispHealth = 255

  # Takes into account owner, bomb speed, and ship size
  for bomb in game.owners.enemies.bombs
    if Math.abs(ship.x - bomb.x) <= 12 and Math.abs(ship.y - bomb.y + bomb.speed / 2) <= Math.abs(bomb.speed) / 2 + 10
      bomb.cooldown = 0
      game.owners.player.health -= 2
      game.timers.dispHealth = 255

  # Takes into account owner, shrapnal speed, and ship size
  for shrapnal in game.owners.enemies.shrapnals
    if Math.abs(ship.x - shrapnal.x) <= 12 and Math.abs(ship.y - shrapnal.y + shrapnal.speed / 2) <= Math.abs(shrapnal.speed) / 2 + 10
      shrapnal.cooldown = 0
      game.owners.player.health -= 2
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
    game.owners.player.bombs.push( new Bomb( ship.x, ship.y, -BOMB_SPEED, 20, game.owners.player) ) if currentState is gameState.playing
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

