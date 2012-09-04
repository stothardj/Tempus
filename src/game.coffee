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

class Game
  constructor: (playerShip) ->
    @owners =
      player:
        lasers: []
        bombs: []
        shrapnals: []
        unit: playerShip
        color: GOOD_COLOR
        kills: 0
        lasersFired: 0
        bombsFired: 0
        lives: PLAYER_LIVES
      enemies:
        lasers: []
        bombs: []
        shrapnals: []
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
      @display.drawGameOver()
      return true
    return false
