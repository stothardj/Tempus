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
define(KAMIKAZE_RAND,0.02)dnl
define(KAMIKAZE_THRESHOLD,15)dnl
define(KAMIKAZE_WIDTH,20)dnl
define(KAMIKAZE_HEIGHT,20)dnl
class Kamikaze
  constructor: (@x, @y) ->
    @angle = 0
    @shootCooldown = 0
    @moveState = 0

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
        if Math.abs(desired_angle - @angle) < (Math.PI / 24) or Math.abs(desired_angle - @angle) > Math.PI * 2 - (Math.PI / 24)
          @angle = desired_angle
          @moveState = 2
        else if (@angle < desired_angle and @angle - desired_angle < Math.PI) or (Math.PI * 2 - @angle) - desired_angle < Math.PI
          @angle += Math.PI / 24
        else
          @angle -= Math.PI / 24
      when 2 # Charge
        @x += 30 * Math.cos(@angle + Math.PI / 2)
        @y += 30 * Math.sin(@angle + Math.PI / 2)

  draw: ->
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( -eval(KAMIKAZE_WIDTH / 2), -eval(KAMIKAZE_HEIGHT / 2) )
    ctx.lineTo( eval(KAMIKAZE_WIDTH / 2), -eval(KAMIKAZE_HEIGHT / 2) )
    ctx.lineTo( eval(KAMIKAZE_WIDTH / 2), eval(KAMIKAZE_HEIGHT / 5) )
    ctx.lineTo( 0, eval(KAMIKAZE_HEIGHT / 2) )
    ctx.lineTo( -eval(KAMIKAZE_WIDTH / 2), eval(KAMIKAZE_HEIGHT / 5) )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  alive: ->
    return false if @y > canvas.height or @moveState and offscreen
    if Math.abs( ship.x - @x ) < 35 and Math.abs( ship.y - @y ) < 35
      game.owners.player.kills += 1
      game.owners.player.health -= 35
      game.timers.dispHealth = 255
      return false
    for laser in game.owners.player.lasers
      # Takes into account color, laser length, laser speed, and ship size
      if Math.abs(@x - laser.x) <= 12 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10
        laser.killedSomething = true
        game.owners.player.kills += 1
        return false
    for bomb in game.owners.player.bombs
      # Takes into account color, bomb size, bomb speed, and ship size
      if Math.abs(@x - bomb.x) <= 12 and Math.abs(@y - bomb.y + bomb.speed / 2) <= Math.abs(bomb.speed) / 2 + 12
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return false
    for shrap in game.owners.player.shrapnals
      # Takes into account color, shrap size, and ship size
      if Math.abs(@x - shrap.x) <= 11 and Math.abs(@y - shrap.y) <= 11
        game.owners.player.kills += 1
        return false
    true

  update: ->
    @move()
    @draw()
