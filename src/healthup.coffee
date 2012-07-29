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
#<< powerup

class HealthUp extends PowerUp
  constructor: (@x, @y) ->
    super(@x, @y)

  rand: 0.05
  width: 4
  height: 4
  speed: 5
  color: "#00FF00"

  use: ->
    game.owners.player.health = Math.min( game.owners.player.health + 15, SHIP_MAX_HEALTH )
    game.timers.dispHealth = 255
