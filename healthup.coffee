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

  rand: 0.2
  width: 4
  height: 4
  speed: 5

  drawAsBox: ->
    ctx.fillRect( @x - @width / 2, @y - @height / 2, @width, @height )

  boxHit: (other) ->
    Math.abs( other.x - @x ) < (other.width + @width) / 2 and Math.abs( other.y - @y ) < (other.height + @height) / 2
 
  move: ->
    @y += @speed

  draw: ->
    ctx.fillStyle = "#00FF00"
    @drawAsBox()

  offscreen: ->
    @x < 0 or @x > canvas.width or @y < 0 or @y > canvas.height

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