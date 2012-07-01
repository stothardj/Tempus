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
!import "box.coffee"

class HealthUp extends Box
  constructor: (@x, @y) ->
    @used = 0

  rand: 0.2
  width: 4
  height: 4
  speed: 5
 
  move: ->
    @y += @speed

  draw: ->
    ctx.fillStyle = "#00FF00"
    @drawAsBox()

  detectUse: ->
    if @boxHit(ship)
      console.log "Used"
      @used = 1
      game.owners.player.health = Math.min( game.owners.player.health + 15, 100 )
      game.timers.dispHealth = 255

    @used = 1 if @offscreen()
    if @offscreen()
      console.log "Offscreen"
      console.log @x
      console.log @y
      console.log canvas.width
      console.log canvas.height

  update: ->
    @move()
    @draw()
    @detectUse()