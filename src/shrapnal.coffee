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

class Shrapnal
  constructor: (@x, @y, @angle, @speed, @owner) ->
    @cooldown = 10

  speed: 10
  width: 2
  height: 2

  drawAsBox: ->
    ctx.fillRect( @x - @width / 2, @y - @height / 2, @width, @height )

  move: ->
    @x += (@speed * Math.cos(@angle))
    @y += (@speed * Math.sin(@angle))

  draw: ->
    ctx.fillStyle = @owner.color
    @drawAsBox()

  update: ->
    @cooldown -= 1
    @move()
    @draw()
