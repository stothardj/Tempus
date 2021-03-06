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

#<< box
#<< shrapnel

class Bomb extends Box
  constructor: (@x, @y, @speed, @cooldown, @owner) ->

  width: 4
  height: 4
  speed: 12

  move: ->
    @y += @speed

  explode: ->
    @owner.shrapnels = @owner.shrapnels.concat( (new Shrapnel(@x, @y, ang * 36 * Math.PI / 180, Shrapnel::speed, @owner) for ang in [0..9]) )

  draw: ->
    ctx.fillStyle = @owner.color
    @drawAsBox()

  update: ->
    @cooldown -= 1
    @explode() if @cooldown <= 0
    @move()