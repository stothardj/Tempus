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
    @shootCooldown = 0
    @burst = 0
    @health = 1

  draw: ->
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( - eval(SPINNER_WIDTH / 2), - eval(SPINNER_HEIGHT / 2) )
    ctx.lineTo( eval(SPINNER_WIDTH / 2), - eval(SPINNER_HEIGHT / 2) )
    ctx.lineTo( eval(SPINNER_WIDTH / 2), eval(SPINNER_HEIGHT / 2) )
    ctx.lineTo( - eval(SPINNER_WIDTH / 2), eval(SPINNER_HEIGHT / 2) )
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
      @shootCooldown = 55
      @burst = 0
    game.owners.enemies.lasers.push( new Laser( @x, @y, LASER_SPEED, game.owners.enemies ) )

  takeDamage: ->
    return @health = 0 if @y > canvas.height
    if boxHit(ship,fighter)
      game.owners.player.health -= 24
      game.owners.player.kills += 1
      game.timers.dispHealth = 255
      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= eval(SPINNER_WIDTH / 2) and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_HEIGHT) / 2 + eval(SPINNER_HEIGHT / 2)
        laser.killedSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if boxHit(bomb,fighter)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnal in game.owners.player.shrapnals
      if boxHit(shrapnal,fighter)
        game.owners.player.kills += 1
        return @health = 0

  update: ->
    @shoot() if @shootCooldown <= 0
    @shootCooldown -= 1
    @move()
    @draw()
    @takeDamage()