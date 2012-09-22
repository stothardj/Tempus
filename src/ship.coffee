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

# Made a class even though there should be only one.

#<< box
#<< config
#<< globals

# Returns true iff x is between a and b
between = (x, a, b) ->
  return (a < x < b) || (a > x > b)

class Ship extends Box
  constructor: (@x, @y) ->
    @reset(@x, @y)
    @halfWidth = @width >> 1
    @eighthWidth = @width >> 3
    @halfHeight = @height >> 1
    @fourthHeight = @height >> 2

  # This function resets everything which needs to be reset when you die.
  # I don't just use the constructor for this because there are currently
  # multiple references to the ship created and it would require making sure
  # they are all updated to point to the new ship. This is the cleanest solution
  # I could come up with
  reset: (@x, @y) ->
    @laserCooldown = 0
    @bombCooldown = 0
    @heat = 0
    @laserPower = 1
    @health = SHIP_MAX_HEALTH
    @shield = 0
    @lockOn = false

  width: 40
  height: 40

  move: ->
    @x = (@x + mouse.x) >> 1
    @y = (@y + mouse.y) >> 1

  drawShield: ->
    ctx.strokeStyle = "rgb(0,".concat( game.timers.colorCycle >> 1, ",", game.timers.colorCycle, ")")
    ctx.beginPath()
    ctx.arc(@x, @y, Math.min(@width, @height) , 0, 2 * Math.PI, false)
    ctx.stroke()

  drawSight: ->
    ctx.strokeStyle = "#FF0000"
    ctx.lineWidth = SIGHT_WIDTH
    ctx.beginPath()
    ctx.moveTo( @x, @y - @halfHeight )
    ctx.lineTo( @x, 0 )
    ctx.closePath()
    ctx.stroke()
    ctx.lineWidth = LINE_WIDTH

  draw: ->
    ctx.beginPath()
    ctx.moveTo( @x, @y - @halfHeight )
    ctx.quadraticCurveTo( @x + @halfWidth, @y, @x + @halfWidth, @y + @halfHeight )
    ctx.quadraticCurveTo( @x + @eighthWidth, @y + @fourthHeight, @x, @y + @fourthHeight )
    ctx.quadraticCurveTo( @x - @eighthWidth, @y + @fourthHeight, @x - @halfWidth, @y + @halfHeight )
    ctx.quadraticCurveTo( @x - @halfWidth, @y, @x, @y - @halfHeight )
    ctx.closePath()
    ctx.stroke()
    @drawShield() if @shield > 0
    @drawSight() if @lockOn

  damage: (amount) ->
    game.timers.dispHealth = 255
    @shield -= amount * 20
    if @shield < 0
      @health += Math.floor(@shield / 20)
      @shield = 0
  
  takeDamage: ->
    for laser in game.owners.enemies.lasers
      if Math.abs(@x - laser.x) <= @width / 2 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + @height / 2
        laser.hitSomething = true
        @damage(8)
        
    for bomb in game.owners.enemies.bombs
      if @boxHit(bomb)
        bomb.cooldown = 0
        @damage(2)
  
    for shrapnel in game.owners.enemies.shrapnels
      if @boxHit(shrapnel)
        shrapnel.cooldown = 0
        @damage(2)

  cooldown: ->
    @laserCooldown -= 1 if @laserCooldown > 0
    @bombCooldown -= 1 if @bombCooldown > 0
    @heat -= 1 if @heat > 0

  # Not perfect, lenient
  lockOnEnemies: (prevX, prevY) ->
    for enemy in game.owners.enemies.units
      if between(enemy.x, prevX, @x) && (enemy.y < prevY || enemy.y < @y)
        enemy.locked = true
    
  
  update: ->
    prevX = @x
    prevY = @y
    @move()
    @lockOnEnemies(prevX, prevY) if @lockOn
    @takeDamage()
    @shield = Math.max( @shield - 1, 0 )
    @cooldown()