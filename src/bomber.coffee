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
#<< bomberdeath

class Bomber extends EnemyShip
  constructor: (@x, @y) ->
    @angle = 0
    @bombCooldown = Math.floor(Math.random() * @cooldownTime)
    @turnVel = (Math.random() - 0.5) / 30;
    @health = 1
    @goneOnScreen = false

  rand: 0.01
  threshold: 30
  width: 10
  height: 28
  cooldownTime:40
  impactDamage: 24

  move: ->
    @x += 2 * Math.cos(@angle + Math.PI / 2)
    @y += 2 * Math.sin(@angle + Math.PI / 2)
    @angle += @turnVel

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( 0, @height / 2 )
    ctx.lineTo( @width / 2, 0 )
    ctx.lineTo( 0, - @height / 2 )
    ctx.lineTo( - @width / 2, 0 )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  bomb: ->
    @bombCooldown = @cooldownTime
    game.owners.enemies.bombs.push( new Bomb( @x, @y, 4, 35, game.owners.enemies ) )

  removeOffScreen: ->
    if @offscreen()
      if @goneOnScreen
        @health = 0
        return true
    else
      @goneOnScreen = true
    return false

  update: ->
    @bomb() if @bombCooldown is 0
    @bombCooldown -= 1
    @move()
    @draw()
    if not @removeOffScreen()
      @takeDamage()

  getAnimation: ->
    new BomberDeath(@x, @y, @angle)
