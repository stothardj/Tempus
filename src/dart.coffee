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

#<< shrapnel

# Homing darts - there is no escape

class Dart
  constructor: (@x, @y, @target, @owner) ->
    @removed = false
    @launchCountDown = 10
    @explodeCountDown = 30

  width: 10
  height: 10
  
  draw: ->
    ctx.beginPath()
    ctx.moveTo(@x, @y - 5)
    ctx.lineTo(@x + 5, @y)
    ctx.lineTo(@x, @y + 5)
    ctx.lineTo(@x - 5, @y)
    ctx.closePath()
    ctx.stroke()

  explode: ->
    @owner.shrapnels = @owner.shrapnels.concat( (new Shrapnel(@x, @y, ang * 36 * Math.PI / 180, Shrapnel::speed, @owner) for ang in [0..9]) )

  move: ->
    if @launchCountDown > 0 or not @target?
      @y -= 20
      @launchCountDown -= 1
    else
      @x = (@x * 0.8 + @target.x * 0.2) | 0
      @y = (@y * 0.8 + @target.y * 0.2) | 0

  update: ->
    @move()
    @explodeCountDown -= 1
    if @explodeCountDown < 0
      @explode()
      @removed = true