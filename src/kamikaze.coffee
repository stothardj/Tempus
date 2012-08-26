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

#<< enemyship
#<< kamikazedeath

class Kamikaze extends EnemyShip
  constructor: (@x, @y) ->
    super(@x, @y)
    @angle = 0
    @moveState = 0
    @health = 1
    @halfWidth = @width >> 1
    @halfHeight = @height >> 1
    @fifthHeight = (@height / 5) | 0

  rand: 0.02
  threshold: 15
  width: 20
  height: 20
  impactDamage: 35
  turnSpeed: Math.PI / 24

  move: ->
    switch @moveState
      when 0 # Wandering down
        if Math.abs(@x - ship.x) < 150 and Math.abs(@y - ship.y) < 150
          @moveState = 1
        else
          @angle = 0
          @y += 1
      when 1 # Detected ship, turn to face
        if @y > ship.y
          desired_angle = Math.PI - Math.atan( (@x - ship.x) / (@y - ship.y) )
        else
          desired_angle = - Math.atan( (@x - ship.x) / (@y - ship.y) )
        if Math.abs(desired_angle - @angle) < @turnSpeed or Math.abs(desired_angle - @angle) > Math.PI * 2 - @turnSpeed
          @angle = desired_angle
          @moveState = 2
        else if (@angle < desired_angle and @angle - desired_angle < Math.PI) or (Math.PI * 2 - @angle) - desired_angle < Math.PI
          @angle += @turnSpeed
        else
          @angle -= @turnSpeed
      when 2 # Charge
        @x += 30 * Math.cos(@angle + halfPi)
        @y += 30 * Math.sin(@angle + halfPi)

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( - @halfWidth, - @halfHeight )
    ctx.lineTo( @halfWidth, - @halfHeight )
    ctx.lineTo( @halfWidth, @fifthHeight )
    ctx.lineTo( 0, @halfHeight )
    ctx.lineTo( - @halfWidth, @fifthHeight )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  removeOffScreen: ->
    if @y > canvas.height or @moveState > 0 and @offscreen()
      @removed = true
      return true
    return false

  update: ->
    @move()
    # @draw()
    if not @removeOffScreen()
      @takeDamage()

  getAnimation: ->
    new KamikazeDeath(@x, @y, @angle)