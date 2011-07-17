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
class Bomber
  constructor: (@x, @y) ->
    @angle = 0
    @bombCooldown = 0
    @turnVel = (Math.random() - 0.5) / 30;

  move: ->
    @x += 2 * Math.cos(@angle + Math.PI / 2)
    @y += 2 * Math.sin(@angle + Math.PI / 2)
    @angle += @turnVel
    @goneOnScreen = 0

  draw: ->
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( 0, eval(BOMBER_HEIGHT / 2) )
    ctx.lineTo( eval(BOMBER_WIDTH / 2), 0 )
    ctx.lineTo( 0, -eval(BOMBER_HEIGHT / 2) )
    ctx.lineTo( -eval(BOMBER_WIDTH / 2), 0 )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  bomb: ->
    @bombCooldown = 40
    game.owners.enemies.bombs.push( new Bomb( @x, @y, 4, 35, game.owners.enemies ) )

  update: ->
    @bomb() if @bombCooldown is 0
    @bombCooldown -= 1
    @move()
    @draw()

  alive: ->
    if offscreen
      return false if @goneOnScreen
    else
      @goneOnScreen = 1
    if boxHit(ship,bomber)
      game.owners.player.health -= 24
      game.owners.player.kills += 1
      game.timers.dispHealth = 255
      return false
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= eval(BOMBER_WIDTH / 2) and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_HEIGHT) / 2 + eval(BOMBER_HEIGHT / 2)
        laser.killedSomething = true
        game.owners.player.kills += 1
        return false
    for bomb in game.owners.player.bombs
      if boxHit(bomb,bomber)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return false
    for shrapnal in game.owners.player.shrapnals
      if boxHit(shrapnal,bomber)
        game.owners.player.kills += 1
        return false

    true