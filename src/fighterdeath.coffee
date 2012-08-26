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
  constructor: (@x, @y) ->
    super 5
    @halfWidth = @width >> 1
    @halfHeight = @height >> 1

  width: 20
  height: 20

  drawFrame: ->
    ctx.strokeStyle = "rgba(255,0,0,".concat( 1 - @frame / @framecount, ")" )
    ctx.beginPath()

    expand = @frame * 2
    ctx.moveTo( @x - @halfWidth - expand, @y - @halfHeight - expand )
    ctx.lineTo( @x + @halfWidth + expand, @y - @halfHeight - expand )
    ctx.lineTo( @x, @y + @halfHeight + expand )

    ctx.closePath()
    ctx.stroke()
