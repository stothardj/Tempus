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

#<< config
#<< healthup
#<< shieldup
#<< laserup
#<< ship
#<< display
#<< globals
#<< bomber
#<< kamikaze
#<< fighter
#<< spinner
#<< laser
#<< bomb
#<< dart

class Game
  constructor: (playerShip) ->
    @owners =
      player:
        lasers: []
        bombs: []
        darts: []
        shrapnels: []
        unit: playerShip
        color: GOOD_COLOR
        score: 0
        kills: 0
        lasersFired: 0
        bombsFired: 0
        dartsFired: 0
        lives: PLAYER_LIVES
      enemies:
        lasers: []
        bombs: []
        darts: []
        shrapnels: []
        units: []
        color: BAD_COLOR

    @timers =
      dispHealth: 0
      dispLives: 0
      colorCycle: 0
      colorCycleDir: 10

    @powerups =
      healthups:
        classType: HealthUp
        instances: []
      laserups:
        classType: LaserUp
        instances: []
      shieldups:
        classType: ShieldUp
        instances: []

    @animations = []
    
    @display = Display.get()
    @crashed = false

  # Stop looping if game crashes
  checkCrashed: ->
    if @crashed
      currentState = gameState.crashed
      clearInterval( timeHandle )
      return
    @crashed = true

  # Color cycle for flashing text
  cycleColorTimers: ->
    @timers.colorCycle += @timers.colorCycleDir
    @timers.colorCycle = Math.min(@timers.colorCycle, 255)
    @timers.colorCycle = Math.max(@timers.colorCycle, 0)
    @timers.colorCycleDir *= -1 if @timers.colorCycle is 0 or @timers.colorCycle is 255

  # Check life lost
  checkLifeLost: ->
    if ship.health <= 0
      @owners.player.lives -= 1
      ship.reset(0, @display.canvas.height)
      @timers.dispLives = 255

  # Check gameover
  checkGameOver: ->
    if @owners.player.lives < 0
      currentState = gameState.gameOver
      clearInterval( timeHandle )
      timeOfGameOver = new Date().getTime()
      @display.drawGameOver()
      return true
    return false

  # Update enemies
  updateEnemies: ->
    enemy.update() for enemy in @owners.enemies.units

  # For ever dead enemy, possibly generate powerup of type t
  genPowerup: (t) ->
    new t( enemy.x, enemy.y ) for enemy in @owners.enemies.units when enemy.health <= 0 and Math.random() < t::rand

  # Put powerups in place of dead enemies
  generatePowerups: ->
    for powerupTypeName, powerupType of @powerups
      powerupType.instances = powerupType.instances.concat( @genPowerup( powerupType.classType ))

  # Remove dead enemies
  removeDeadEnemies: ->
    @generatePowerups()
    @owners.enemies.units = (enemy for enemy in @owners.enemies.units when not enemy.removed)
    [ @owners.enemies.units, dead ] = partition( @owners.enemies.units, (enemy) -> enemy.health > 0 )
    @owners.player.score += dead.reduce ( (accum, x) -> accum + x.scoreValue ), 0
    @animations = @animations.concat( enemy.getAnimation() for enemy in dead )

  removeFinishedAnimations: ->
    @animations = (anim for anim in @animations when not anim.finished() )

  # Generate new enemies
  generateEnemies: ->
    for t in [Fighter, Kamikaze, Bomber, Spinner]
      if @owners.player.kills >= t::threshold and Math.random() < t::rand
        @owners.enemies.units.push( new t( randInt(0, canvas.width), -10 ) )

  # Update lasers, bombs, shrapnel, and darts
  updateFired: ->
    for ownerName, owner of @owners
      laser.update() for laser in owner.lasers
      owner.lasers = (laser for laser in owner.lasers when 0 < laser.y < canvas.height and not laser.hitSomething)
      bomb.update() for bomb in owner.bombs
      owner.bombs = (bomb for bomb in owner.bombs when bomb.cooldown > 0)
      shrapnel.update() for shrapnel in owner.shrapnels
      owner.shrapnels = (shrapnel for shrapnel in owner.shrapnels when shrapnel.cooldown > 0)
      dart.update() for dart in owner.darts
      owner.darts = (dart for dart in owner.darts when not dart.removed)

  # Update powerups
  updatePowerups: ->
    for powerupTypeName, powerupType of @powerups
      powerup.update() for powerup in powerupType.instances
      @powerups[powerupTypeName].instances = (powerup for powerup in powerupType.instances when not powerup.used)

  # Player shoots laser
  shootLaser: ->
    @owners.player.lasersFired += ship.laserPower
    for i in [1..ship.laserPower]
      @owners.player.lasers.push( new Laser( ship.x + i * 4 - ship.laserPower * 2, ship.y, -Laser::speed, @owners.player) )
    if ship.heat > SHIP_CRITICAL_TEMP
      ship.laserCooldown = 7
    else if ship.heat > SHIP_WARNING_TEMP
      ship.laserCooldown = 5
    else
      ship.laserCooldown = 2
    ship.heat += 7

  # Player shoots bomb
  shootBomb: ->
    @owners.player.bombsFired += 1
    @owners.player.bombs.push( new Bomb( ship.x, ship.y, -Bomb::speed, 20, @owners.player) )
    if ship.heat > SHIP_CRITICAL_TEMP
      ship.bombCooldown = 20
    else if ship.heat > SHIP_WARNING_TEMP
      ship.bombCooldown = 10
    else
      ship.bombCooldown = 5
    ship.heat += 10

  # Player shoots dart
  shootDart: (target) ->
    @owners.player.dartsFired += 1
    @owners.player.darts.push( new Dart( ship.x, ship.y, target, @owners.player) )