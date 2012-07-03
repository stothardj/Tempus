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

!import "bomb.coffee"
!import "config.coffee"
!import "healthup.coffee"
!import "shieldup.coffee"
!import "ship.coffee"
!import "bomber.coffee"
!import "kamikaze.coffee"
!import "laserup.coffee"
!import "shrapnal.coffee"
!import "fighter.coffee"
!import "laser.coffee"
!import "spinner.coffee"

genship = (t) ->
  if game.owners.player.kills >= t::threshold and Math.random() < t::rand
    game.owners.enemies.units.push( new t( randInt(0, canvas.width), -10 ) )

canvas = document.getElementById("c")
ctx = canvas.getContext("2d")
audio = $('<audio></audio>')
  .attr({ 'loop' : 'loop'})
  .append($('<source></source>')
  .attr({ 'src' : 'media/tonight_full.ogg'})
  .attr({ 'type': 'audio/ogg' }))
  .append($('<source></source>')
  .attr({ 'src' : 'media/tonight_full.mp3'})
  .attr({ 'type': 'audio/mpeg'}))
  .appendTo('body')[0]

console.log audio

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
  ctx.fillText( "Lasers Fired - " + game.owners.player.lasersFired, canvas.width / 2, canvas.height / 2 + 20 )
  ctx.fillText( "Bombs Used - " + game.owners.player.bombsFired, canvas.width / 2, canvas.height / 2 + 40 )

ctx.strokeStyle = "#FFFFFF"
ctx.lineWidth = 4

firstInit = ->
  if $("#enableMusic")[0].checked
    audio.play()
    musicPlaying = true
  firstTime = false

initGame = ->
  #TODO: Decided on concrete separation of what goes in game.owners.player and what is bound to ship
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
        health: SHIP_MAX_HEALTH
        shield: 0
        kills: 0
        lasersFired: 0
        bombsFired: 0

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

    powerups:
      healthups: []
      laserups: []
      shieldups: []

    crashed: false

dispHealth = ->
  ctx.strokeStyle = "rgb(0,".concat( game.timers.dispHealth , ",0)" )
  ctx.beginPath()
  ctx.arc(canvas.width / 2, canvas.height / 2, Math.min(canvas.width, canvas.height) / 2 - 20, 0, Math.max(game.owners.player.health, 0) * Math.PI * 2 / SHIP_MAX_HEALTH, false)
  ctx.stroke()
  ctx.strokeStyle = "rgb(0,".concat( Math.floor(game.timers.dispHealth / 2) , "," , game.timers.dispHealth , ")" )
  ctx.beginPath()
  ctx.arc(canvas.width / 2, canvas.height / 2, Math.min(canvas.width, canvas.height) / 2 - 40, 0, Math.max(game.owners.player.shield, 0) * Math.PI * 2 / SHIP_MAX_SHIELD, false)
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
    # console.log e
    switch e.which
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
  #TODO: make powerup looped over instead of copying code
  game.powerups.healthups = game.powerups.healthups.concat( new HealthUp( enemy.x, enemy.y ) for enemy in game.owners.enemies.units when enemy.health <= 0 and Math.random() < HealthUp::rand )
  game.powerups.shieldups = game.powerups.shieldups.concat( new ShieldUp( enemy.x, enemy.y ) for enemy in game.owners.enemies.units when enemy.health <= 0 and Math.random() < ShieldUp::rand )
  game.powerups.laserups = game.powerups.laserups.concat( new LaserUp( enemy.x, enemy.y ) for enemy in game.owners.enemies.units when enemy.health <= 0 and Math.random() < LaserUp::rand )

  game.owners.enemies.units = (enemy for enemy in game.owners.enemies.units when enemy.health > 0)

  genship(Fighter)
  genship(Kamikaze)
  genship(Bomber)
  genship(Spinner)

  ship.update()

  for ownerName, owner of game.owners
    laser.update() for laser in owner.lasers
    owner.lasers = (laser for laser in owner.lasers when 0 < laser.y < canvas.height and not laser.killedSomething)
    bomb.update() for bomb in owner.bombs
    owner.bombs = (bomb for bomb in owner.bombs when bomb.cooldown > 0)
    shrapnal.update() for shrapnal in owner.shrapnals
    owner.shrapnals = (shrapnal for shrapnal in owner.shrapnals when shrapnal.cooldown > 0)

  for powerupTypeName, powerupType of game.powerups
    powerup.update() for powerup in powerupType
    game.powerups[powerupTypeName] = (powerup for powerup in powerupType when not powerup.used)

  if mouse.leftDown and ship.laserCooldown <= 0
    game.owners.player.lasersFired += ship.laserPower
    for i in [1..ship.laserPower]
      game.owners.player.lasers.push( new Laser( ship.x + i * 4 - ship.laserPower * 2, ship.y, -Laser::speed, game.owners.player) )
    if ship.heat > 80
      ship.laserCooldown = 7
    else if ship.heat > 40
      ship.laserCooldown = 5
    else
      ship.laserCooldown = 2
    ship.heat += 7

  if mouse.rightDown and ship.bombCooldown <= 0
    game.owners.player.bombsFired += 1
    game.owners.player.bombs.push( new Bomb( ship.x, ship.y, -Bomb::speed, 20, game.owners.player) ) if currentState is gameState.playing
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
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",0,0)")
    ctx.font = "bold 20px Lucidia Console"
    ctx.fillText( "[ Heat Critical ]", canvas.width / 2, canvas.height - 30)
  else if ship.heat > 40
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",", game.timers.colorCycle, ",0)");
    ctx.font = "normal 18px Lucidia Console"
    ctx.fillText( "[ Heat Warning ]", canvas.width / 2, canvas.height - 30)

  if game.timers.dispHealth > 0
    dispHealth()
    ctx.strokeStyle = "#FFFFFF"
    game.timers.dispHealth -= 10

  game.crashed = false

# Can change how game begins based on what you start the state as
# Allows for auto-play like behavior if you want it
switch currentState
  when gameState.playing
    initGame()
    timeHandle = every 32, gameloop
  when gameState.title
    drawTitleScreen()

