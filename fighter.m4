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
class Fighter
  constructor: (@x, @y) ->
    @shootCooldown = 0

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.beginPath()
    ctx.moveTo( @x - eval(FIGHTER_WIDTH / 2), @y - eval(FIGHTER_HEIGHT / 2) )
    ctx.lineTo( @x + eval(FIGHTER_WIDTH / 2), @y - eval(FIGHTER_HEIGHT / 2) )
    ctx.lineTo( @x, @y + eval(FIGHTER_HEIGHT / 2) )

    ctx.closePath()
    ctx.stroke()

  move: ->
    @y += 3
    mv = (ship.x - @x) / 12
    @x += if Math.abs(mv) < 5 then mv else 5 * mv/Math.abs(mv)

  shoot: ->
    @shootCooldown = 35
    game.owners.enemies.lasers.push( new Laser( @x, @y, LASER_SPEED, game.owners.enemies ) )

  alive: ->
    return false if @y > canvas.height
    if boxHit(ship,fighter)
      game.owners.player.health -= 24
      game.owners.player.kills += 1
      game.timers.dispHealth = 255
      return false
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= eval(FIGHTER_WIDTH / 2) and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_HEIGHT) / 2 + eval(FIGHTER_HEIGHT / 2)
        laser.killedSomething = true
        game.owners.player.kills += 1
        return false
    for bomb in game.owners.player.bombs
      if boxHit(bomb,fighter)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return false
    for shrapnal in game.owners.player.shrapnals
      if boxHit(shrapnal,fighter)
        game.owners.player.kills += 1
        return false
    true

  update: ->
    @shoot() if @shootCooldown is 0
    @shootCooldown -= 1
    @move()
    @draw()