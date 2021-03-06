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
#<< shrapnel
#<< fighter
#<< laser
#<< spinner
#<< globals
#<< game
#<< utility

console.log "Game init"
display = Display.get()
# TODO: Get to the point where it's reasonable to remove these globals
ctx = display.ctx
canvas = display.canvas

audio = document.getElementById("audio");
throw "Loading context failed" unless ctx?

firstInit = ->
  ctx.lineWidth = LINE_WIDTH
  if $("#enableMusic")[0].checked
    audio.play()
    musicPlaying = true
  firstTime = false

initGame = ->
  firstInit() if firstTime
  ship = new Ship(mouse.x, mouse.y)
  game = new Game()

startTimer = ->
  timeHandle = every 26, gameloop

pause = ->
  beginPauseTime = new Date().getTime()
  currentState = gameState.paused
  clearInterval( timeHandle )
  display.drawHealth()
  display.drawLives()
  display.setTitleFont()
  ctx.fillText( "[Paused]", canvas.width >> 1, canvas.height >> 1)

unpause = ->
  currentState = gameState.playing
  mouse.beginLeftHold += (new Date().getTime() - beginPauseTime)
  startTimer()

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
    if currentState is gameState.playing
      autoPauseHandle = setTimeout(pause, 1000)
  )

  .mouseenter( (e) ->
    if autoPauseHandle?
      clearTimeout( autoPauseHandle )
      autoPauseHandle = undefined
  )

  .mousedown( (e) ->
    switch (e.which)
      when 1
        mouse.leftDown = true
        mouse.beginLeftHold = new Date().getTime()
      when 3
        mouse.rightDown = true
  )

  .mouseup( (e) ->
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
        startTimer()
      when gameState.gameOver
        # Force half-second wait on game over screen so frantic shooting
        # does not cause you to miss seeing your score
        if new Date().getTime() - timeOfGameOver > 500
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

# TODO: Once this is sufficiently OO move this into Game object
gameloop = ->

  game.checkCrashed()

  game.cycleColorTimers()

  game.checkLifeLost()

  return if game.checkGameOver()

  display.clearScreen()

  game.updateEnemies()

  game.removeDeadEnemies()

  game.removeFinishedAnimations()

  game.generateEnemies()

  ship.update()

  game.updateFired()

  game.updatePowerups()

  # Shoot lasers
  if mouse.leftDown
    if new Date().getTime() - mouse.beginLeftHold < 1000
      game.shootLaser() if ship.laserCooldown <= 0
    else
      ship.lockOn = true
  else
    if ship.lockOn
      # Just released darts
      for enemy in game.owners.enemies.units
        game.shootDart(enemy) if enemy.locked
    ship.lockOn = false

  # Shoot bombs
  if mouse.rightDown and ship.bombCooldown <= 0
    game.shootBomb()

  # Drawing by color for performance
  # Draw ships
  ctx.strokeStyle = ENEMY_SHIP_COLOR
  enemy.draw() for enemy in game.owners.enemies.units
  ctx.strokeStyle = SHIP_COLOR
  ship.draw()

  # Draw fired
  for ownerName, owner of game.owners
    ctx.strokeStyle = owner.color
    ctx.fillStyle = owner.color
    laser.draw() for laser in owner.lasers
    bomb.draw() for bomb in owner.bombs
    shrapnel.draw() for shrapnel in owner.shrapnels
    dart.draw() for dart in owner.darts

  # Draw targets on lockedOn enemies
  ctx.strokeStyle = TARGET_COLOR
  for enemy in game.owners.enemies.units
    if enemy.locked
      display.drawTarget(enemy.x, enemy.y)

  # Draw animations
  for anim in game.animations
    anim.drawFrame()
    anim.nextFrame()

  # Draw HUD
  ctx.textAlign = "center"
  ctx.textBaseline = "bottom"

  if ship.heat > SHIP_CRITICAL_TEMP
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",0,0)")
    ctx.font = "bold 20px Helvetica"
    ctx.fillText( "[ Heat Critical ]", canvas.width / 2, canvas.height - 30)
  else if ship.heat > SHIP_WARNING_TEMP
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",", game.timers.colorCycle, ",0)");
    ctx.font = "normal 18px Helvetica"
    ctx.fillText( "[ Heat Warning ]", canvas.width / 2, canvas.height - 30)

  if game.timers.dispHealth > 0
    display.drawHealth()
    game.timers.dispHealth -= 10

  if game.timers.dispLives > 0
    display.drawLives()
    game.timers.dispLives -= 1

  # Made it to the end, so did not crash this loop
  game.crashed = false

if AUTOPLAY
  currentState = gameState.playing
  initGame()
  startTimer()
else
  currentState = gameState.title
  display.drawTitleScreen()
