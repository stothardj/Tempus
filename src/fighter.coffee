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
#<< fighterdeath

class Fighter extends EnemyShip
  constructor: (@x, @y) ->
    super(@x, @y)
    @shootCooldown = Math.floor(Math.random() * @cooldownTime)
    @health = 1

  rand: 0.03
  threshold: 0
  width: 20
  height: 20
  cooldownTime: 35
  impactDamage: 24

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.beginPath()
    ctx.moveTo( @x - @width / 2, @y - @height / 2 )
    ctx.lineTo( @x + @width / 2, @y - @height / 2 )
    ctx.lineTo( @x, @y + @height / 2 )

    ctx.closePath()
    ctx.stroke()

  move: ->
    @y += 3
    mv = (ship.x - @x) / 12
    @x += if Math.abs(mv) < 5 then mv else 5 * mv/Math.abs(mv)

  shoot: ->
    @shootCooldown = @cooldownTime
    game.owners.enemies.lasers.push( new Laser( @x, @y, Laser::speed, game.owners.enemies ) )

  removeOffScreen: ->
    if @y > canvas.height
      @removed = true
      return true
    return false

  update: ->
    @shoot() if @shootCooldown is 0
    @shootCooldown -= 1
    @move()
    @draw()
    if not @removeOffScreen()
      @takeDamage()

  getAnimation: ->
    new FighterDeath(@x, @y)