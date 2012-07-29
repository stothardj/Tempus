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

# Many objects are basically treated as boxes
class Box
  constructor: (@x, @y) ->

  boxHit: (other) ->
    Math.abs( other.x - @x ) < (other.width + @width) / 2 and Math.abs( other.y - @y ) < (other.height + @height) / 2

  offscreen: ->
    @x < 0 or @x > canvas.width or @y < 0 or @y > canvas.height

  drawAsBox: ->
    ctx.fillRect( @x - @width / 2, @y - @height / 2, @width, @height )
