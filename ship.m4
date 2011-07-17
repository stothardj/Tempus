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

# Made a class even though there should be only one. Consistent so
# even macros can be used across this and enemies
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

  takeDamage: ->
    # Takes into account owner, laser length, laser speed, and ship size
    for laser in game.owners.enemies.lasers
      if Math.abs(@x - laser.x) <= eval(SHIP_WIDTH / 2) and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_HEIGHT) / 2 + eval(SHIP_HEIGHT / 2)
        laser.killedSomething = true
        game.owners.player.health -= 8
        game.timers.dispHealth = 255
    # Takes into account owner, bomb speed, and ship size
    for bomb in game.owners.enemies.bombs
      # if Math.abs(@x - bomb.x) <= 12 and Math.abs(@y - bomb.y + bomb.speed / 2) <= Math.abs(bomb.speed) / 2 + 10
      if boxHit(bomb,ship)
        bomb.cooldown = 0
        game.owners.player.health -= 2
        game.timers.dispHealth = 255
    # Takes into account owner, shrapnal speed, and ship size
    for shrapnal in game.owners.enemies.shrapnals
      # if Math.abs(@x - shrapnal.x) <= 12 and Math.abs(@y - shrapnal.y + shrapnal.speed / 2) <= Math.abs(shrapnal.speed) / 2 + 10
      if boxHit(shrapnal,ship)
        shrapnal.cooldown = 0
        game.owners.player.health -= 2
        game.timers.dispHealth = 255

  update: ->
    @move()
    @draw()
