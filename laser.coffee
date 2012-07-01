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
class Laser
  constructor: (@x, @y, @speed, @owner) ->
    @killedSomething = false

  speed: 20
  width: 2
  height: 16

  drawAsBox: ->
    ctx.fillRect( @x - @width / 2, @y - @height / 2, @width, @height )

  draw: ->
    ctx.fillStyle = @owner.color;
    @drawAsBox()

  move: ->
    @y += @speed

  update: ->
    @move()
    @draw()