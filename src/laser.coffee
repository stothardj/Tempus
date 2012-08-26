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

class Laser
  constructor: (@x, @y, @speed, @owner) ->
    @killedSomething = false
    @halfHeight = @height >> 1

  speed: 20
  height: 16

  draw: ->
    ctx.strokeStyle = @owner.color;
    ctx.beginPath()
    ctx.moveTo( @x, @y - @halfHeight)
    ctx.lineTo( @x, @y + @halfHeight)
    ctx.closePath()
    ctx.stroke()

  move: ->
    @y += @speed

  update: ->
    @move()
    # @draw()
