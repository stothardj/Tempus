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
# Copyright 2011, 2012 Jake Stothard

#<< bomb
#<< config
#<< display
#<< healthup
#<< shieldup
#<< ship
#<< bomber
#<< kamikaze
#<< laserup
#<< shrapnal
#<< fighter
#<< laser
#<< spinner
#<< game
#<< utility

console.log "Game init"
display = Display.get()
# TODO: Get to the point where it's reasonable to remove these globals
ctx = display.ctx
canvas = display.canvas

audio = $('<audio></audio>')
  .attr({ 'loop' : 'loop'})
  .append($('<source></source>')
  .attr({ 'src' : 'media/tonight_full.ogg'})
  .attr({ 'type': 'audio/ogg' }))
  .append($('<source></source>')
  .attr({ 'src' : 'media/tonight_full.mp3'})
  .attr({ 'type': 'audio/mpeg'}))
  .appendTo('body')[0]

throw "Loading context failed" unless ctx?

# Here for scope
game = undefined
ship = undefined
firstTime = true
musicPlaying = false

mouse =
  x: 250
  y: 200
  leftDown: false
  rightDown: false

timeHandle = undefined

gameState =
  title: "Title"
  gameover: "GameOver"
  playing: "Playing"
  paused: "Paused"
  crashed: "Crashed"

currentState = gameState.title

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
  game = new Game()

pause = ->
  currentState = gameState.paused
  clearInterval( timeHandle )
  display.drawHealth()
  display.drawLives()
  display.setTitleFont()
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
        display.drawTitleScreen()
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

genpowerup = (t) ->
  new t( enemy.x, enemy.y ) for enemy in game.owners.enemies.units when enemy.health <= 0 and Math.random() < t::rand

# TODO: Once this is sufficiently OO move this into Game object
gameloop = ->

  # Stop looping if game crashes
  if game.crashed
    currentState = gameState.crashed
    clearInterval( timeHandle )
    return
  game.crashed = true

  # Color cycle for flashing text
  game.timers.colorCycle += game.timers.colorCycleDir
  game.timers.colorCycle = Math.min(game.timers.colorCycle, 255)
  game.timers.colorCycle = Math.max(game.timers.colorCycle, 0)
  game.timers.colorCycleDir *= -1 if game.timers.colorCycle is 0 or game.timers.colorCycle is 255

  # Check life lost
  if ship.health <= 0
    game.owners.player.lives -= 1
    ship = new Ship(0, canvas.height)
    game.timers.dispLives = 255

  # Check gameover
  if game.owners.player.lives < 0
    currentState = gameState.gameOver
    clearInterval( timeHandle )
    display.drawGameOver()
    return

  display.clearScreen()

  # Update enemy
  enemy.update() for enemy in game.owners.enemies.units
  enemy.draw() for enemy in game.owners.enemies.units

  # Put powerups in place of dead enemies
  #TODO: make powerup looped over instead of copying code
  game.powerups.healthups = game.powerups.healthups.concat( genpowerup(HealthUp) )
  game.powerups.shieldups = game.powerups.shieldups.concat( genpowerup(ShieldUp) )
  game.powerups.laserups = game.powerups.laserups.concat( genpowerup(LaserUp) )

  # Remove dead enemies
  game.owners.enemies.units = (enemy for enemy in game.owners.enemies.units when not enemy.removed)
  [ game.owners.enemies.units, dead ] = partition( game.owners.enemies.units, (enemy) -> enemy.health > 0 )
  game.animations = game.animations.concat( enemy.getAnimation() for enemy in dead )
  game.animations = (anim for anim in game.animations when not anim.finished() )

  # Generate new enemies
  for t in [Fighter, Kamikaze, Bomber, Spinner]
    if game.owners.player.kills >= t::threshold and Math.random() < t::rand
      game.owners.enemies.units.push( new t( randInt(0, canvas.width), -10 ) )

  # Update ship
  ship.update()
  ship.draw()

  # Update lasers, etc.
  for ownerName, owner of game.owners
    laser.update() for laser in owner.lasers
    laser.draw() for laser in owner.lasers
    owner.lasers = (laser for laser in owner.lasers when 0 < laser.y < canvas.height and not laser.killedSomething)
    bomb.update() for bomb in owner.bombs
    owner.bombs = (bomb for bomb in owner.bombs when bomb.cooldown > 0)
    shrapnal.update() for shrapnal in owner.shrapnals
    owner.shrapnals = (shrapnal for shrapnal in owner.shrapnals when shrapnal.cooldown > 0)

  # Update powerups
  for powerupTypeName, powerupType of game.powerups
    powerup.update() for powerup in powerupType
    game.powerups[powerupTypeName] = (powerup for powerup in powerupType when not powerup.used)

  # Shoot lasers
  if mouse.leftDown and ship.laserCooldown <= 0
    game.owners.player.lasersFired += ship.laserPower
    for i in [1..ship.laserPower]
      game.owners.player.lasers.push( new Laser( ship.x + i * 4 - ship.laserPower * 2, ship.y, -Laser::speed, game.owners.player) )
    if ship.heat > SHIP_CRITICAL_TEMP
      ship.laserCooldown = 7
    else if ship.heat > SHIP_WARNING_TEMP
      ship.laserCooldown = 5
    else
      ship.laserCooldown = 2
    ship.heat += 7

  # Shoot bombs
  if mouse.rightDown and ship.bombCooldown <= 0
    game.owners.player.bombsFired += 1
    game.owners.player.bombs.push( new Bomb( ship.x, ship.y, -Bomb::speed, 20, game.owners.player) ) if currentState is gameState.playing
    if ship.heat > SHIP_CRITICAL_TEMP
      ship.bombCooldown = 20
    else if ship.heat > SHIP_WARNING_TEMP
      ship.bombCooldown = 10
    else
      ship.bombCooldown = 5
    ship.heat += 10

  # Cooldown
  ship.laserCooldown -= 1 if ship.laserCooldown > 0
  ship.bombCooldown -= 1 if ship.bombCooldown > 0
  ship.heat -= 1 if ship.heat > 0

  # Draw animations
  for anim in game.animations
    anim.drawFrame()
    anim.nextFrame()

  # Draw HUD
  ctx.textAlign = "center"
  ctx.textBaseline = "bottom"

  if ship.heat > SHIP_CRITICAL_TEMP
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",0,0)")
    ctx.font = "bold 20px Lucidia Console"
    ctx.fillText( "[ Heat Critical ]", canvas.width / 2, canvas.height - 30)
  else if ship.heat > SHIP_WARNING_TEMP
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",", game.timers.colorCycle, ",0)");
    ctx.font = "normal 18px Lucidia Console"
    ctx.fillText( "[ Heat Warning ]", canvas.width / 2, canvas.height - 30)

  if game.timers.dispHealth > 0
    display.drawHealth()
    game.timers.dispHealth -= 10

  if game.timers.dispLives > 0
    display.drawLives()
    game.timers.dispLives -= 1

  # Made it to the end, so did not crash this loop
  game.crashed = false

# Can change how game begins based on what you start the state as
# Allows for auto-play like behavior if you want it
switch currentState
  when gameState.playing
    initGame()
    timeHandle = every 32, gameloop
  when gameState.title
    display.drawTitleScreen()

