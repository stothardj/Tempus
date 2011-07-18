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
class HealthUp
  constructor: (@x, @y) ->
    @used = 0

  move: ->
    @y += HEALTHUP_SPEED

  draw: ->
    ctx.fillStyle = "#00FF00"
    drawAsBox(HealthUp)

  detectUse: ->
    if boxHit(ship,healthup)
      @used = 1
      game.owners.player.health = Math.min( game.owners.player.health + 15, 100 )
      game.timers.dispHealth = 255

    @used = 1 if offscreen


  update: ->
    @move()
    @draw()
    @detectUse()