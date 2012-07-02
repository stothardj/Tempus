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

  width: 40
  height: 40

  boxHit: (other) ->
    Math.abs( other.x - @x ) < (other.width + @width) / 2 and Math.abs( other.y - @y ) < (other.height + @height) / 2

  move: ->
    @x = (@x + mouse.x) / 2
    @y = (@y + mouse.y) / 2

  drawShield: ->
    ctx.strokeStyle = "rgb(0,".concat( Math.floor(game.timers.colorCycle / 2), ",", game.timers.colorCycle, ")")
    ctx.beginPath()
    ctx.arc(@x, @y, Math.min(@width, @height) , 0, 2 * Math.PI, false)
    ctx.stroke()

  draw: ->
    @drawShield() if game.owners.player.shield > 0
    ctx.strokeStyle = "#FFFFFF"
    ctx.beginPath()
    ctx.moveTo( @x, @y - @height / 2 )
    ctx.quadraticCurveTo( @x + @width / 2, @y, @x + @width / 2, @y + @height / 2 )
    ctx.quadraticCurveTo( @x + @width / 8, @y + @height / 4, @x, @y + @height / 4 )
    ctx.quadraticCurveTo( @x - @width / 8, @y + @height / 4, @x - @width / 2, @y + @height / 2 )
    ctx.quadraticCurveTo( @x - @width / 2, @y, @x, @y - @height / 2 )
    ctx.closePath()
    ctx.stroke()

  damage: (amount) ->
    game.timers.dispHealth = 255
    game.owners.player.shield -= amount * 20
    if game.owners.player.shield < 0
      game.owners.player.health += Math.floor(game.owners.player.shield / 20)
      game.owners.player.shield = 0
  
  takeDamage: ->
    for laser in game.owners.enemies.lasers
      if Math.abs(@x - laser.x) <= @width / 2 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + @height / 2
        laser.killedSomething = true
        @damage(8)
        
    for bomb in game.owners.enemies.bombs
      if @boxHit(bomb)
        bomb.cooldown = 0
        @damage(2)
  
    for shrapnal in game.owners.enemies.shrapnals
      if @boxHit(shrapnal)
        shrapnal.cooldown = 0
        @damage(2)
  

  update: ->
    @move()
    @draw()
    @takeDamage()
    game.owners.player.shield = Math.max( game.owners.player.shield - 1, 0 )
