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
# Should it really be a class if it seems I really only ever make one of them?
class Ship
  constructor: (@x, @y) ->
    @laserCooldown = 0
    @bombCooldown = 0
    @heat = 0

  move: ->
    @x = (@x + mouse.x) / 2
    @y = (@y + mouse.y) / 2

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.beginPath()
    ctx.moveTo( @x, @y - eval(SHIP_HEIGHT / 2) )
    ctx.quadraticCurveTo( @x + eval(SHIP_WIDTH / 2), @y, @x + eval(SHIP_WIDTH / 2), @y + eval(SHIP_HEIGHT / 2) )
    ctx.quadraticCurveTo( @x + eval(SHIP_WIDTH / 8), @y + eval(SHIP_HEIGHT / 4), @x, @y + eval(SHIP_HEIGHT / 4) )
    ctx.quadraticCurveTo( @x - eval(SHIP_WIDTH / 8), @y + eval(SHIP_HEIGHT / 4), @x - eval(SHIP_WIDTH / 2), @y + eval(SHIP_HEIGHT / 2) )
    ctx.quadraticCurveTo( @x - eval(SHIP_WIDTH / 2), @y, @x, @y - eval(SHIP_HEIGHT / 2) )
    ctx.closePath()
    ctx.stroke()

  update: ->
    @move()
    @draw()
