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
#<< spinnerdeath

class Spinner extends EnemyShip
  constructor: (@x, @y) ->
    super(@x, @y)
    @angle = 0
    @shootCooldown = Math.floor(Math.random() * @cooldownTime)
    @burst = 0
    @health = 1
    @halfWidth = @width >> 1
    @halfHeight = @height >> 1

  rand: 0.005
  threshold: 45
  width: 20
  height: 20
  cooldownTime: 55
  impactDamage: 24

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( - @halfWidth, - @halfHeight )
    ctx.lineTo( @halfWidth , - @halfHeight )
    ctx.lineTo( @halfWidth , @halfHeight )
    ctx.lineTo( - @halfWidth, @halfHeight )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  move: ->
    @angle += 0.1
    @y += 2

  shoot: ->
    if @burst < 5
      @burst += 1
    else
      @shootCooldown = @cooldownTime
      @burst = 0
    game.owners.enemies.lasers.push( new Laser( @x, @y, Laser::speed, game.owners.enemies ) )

  removeOffScreen: ->
    if @y > canvas.height
      @removed = true
      return true
    return false

  update: ->
    @shoot() if @shootCooldown <= 0
    @shootCooldown -= 1
    @move()
    # @draw()
    if not @removeOffScreen()
      @takeDamage()

  getAnimation: ->
    new SpinnerDeath(@x, @y, @angle)