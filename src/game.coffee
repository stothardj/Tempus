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

class Game
  constructor: ->
    @owners =
      player:
        lasers: []
        bombs: []
        shrapnals: []
        units: ship
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

    @crashed = false
