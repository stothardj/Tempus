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
class Spinner
  constructor: (@x, @y) ->
    @angle = 0
    @shootCooldown = Math.floor(Math.random() * @cooldownTime)
    @burst = 0
    @health = 1

  rand: 0.005
  threshold: 45
  width: 20
  height: 20
  cooldownTime: 55

  boxHit: (other) ->
    Math.abs( other.x - @x ) < (other.width + @width) / 2 and Math.abs( other.y - @y ) < (other.height + @height) / 2
  
  draw: ->
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( - @width / 2, - @height / 2 )
    ctx.lineTo( @width / 2, - @height / 2 )
    ctx.lineTo( @width / 2, @height / 2 )
    ctx.lineTo( - @width / 2, @height / 2 )
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

  takeDamage: ->
    return @health = 0 if @y > canvas.height
    if @boxHit(ship)
      ship.damage(24)
      game.owners.player.kills += 1
      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= @width / 2 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + @height / 2
        laser.killedSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if @boxHit(bomb)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnal in game.owners.player.shrapnals
      if @boxHit(shrapnal)
        game.owners.player.kills += 1
        return @health = 0

  update: ->
    @shoot() if @shootCooldown <= 0
    @shootCooldown -= 1
    @move()
    @draw()
    @takeDamage()