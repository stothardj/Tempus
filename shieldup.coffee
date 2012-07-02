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
!import "powerup.coffee"

class ShieldUp extends PowerUp
  constructor: (@x, @y) ->
    super(@x, @y)

  rand: 0.1
  width: 4
  height: 4
  speed: 5
  color: "#0088FF"

  use: ->
    game.owners.player.shield = Math.min( game.owners.player.shield + 200, 4000 )
    game.timers.dispHealth = 255