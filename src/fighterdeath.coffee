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

#<< anima

class FighterDeath extends Anima
  constructor: (x, y) ->
    super 5
    @x = x
    @y = y

  width: 20
  height: 20

  drawFrame: ->
    ctx.strokeStyle = "rgba(255,0,0,".concat( 1 - @frame / @framecount, ")" )
    ctx.beginPath()
    # ctx.moveTo( @x - @width / 2, @y - @height / 2 )
    # ctx.lineTo( @x + @width / 2, @y - @height / 2 )
    # ctx.lineTo( @x, @y + @height / 2 )

    ctx.moveTo( @x - @width / 2 - @frame, @y - @height / 2 - @frame )
    ctx.lineTo( @x + @width / 2 + @frame, @y - @height / 2 - @frame )
    ctx.lineTo( @x, @y + @height / 2 + @frame )

    ctx.closePath()
    ctx.stroke()
