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

#<< box
#<< anima
#<< laser

class EnemyShip extends Box
  constructor: (@x, @y) ->
    @removed = false
    @locked = false
    @scoreValue = 0

  getAnimation: ->
    new Anima(0)

  # TODO: deal with having more than 1 health
  takeDamage: ->
    if @boxHit(ship)
      ship.damage(@impactDamage)
      game.owners.player.kills += 1
      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= @width / 2 + Laser::width / 2 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + @height / 2
        laser.hitSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if @boxHit(bomb)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnel in game.owners.player.shrapnels
      if @boxHit(shrapnel)
        game.owners.player.kills += 1
        return @health = 0
    for dart in game.owners.player.darts
      if @boxHit(dart)
        game.owners.player.kills += 1
        dart.target.locked = false
        dart.removed = true
        return @health = 0


  update: ->
  draw: ->
