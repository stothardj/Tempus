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
# Constants separated from classes so they can be included in any order
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
# Note that bombs shot by the bomber units do not use BOMB_SPEED
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
# Taken from GNU
# Macro definitions to avoid repeated code
#'
canvas = document.getElementById("c")
ctx = canvas.getContext("2d")
audio = $('<audio></audio>')
  .attr({ 'loop' : 'loop'})
  .append($('<source><source>')
  .attr({ 'src' : 'media/tonight_full.ogg'})
  ).appendTo('body')[0];

if not ctx
  throw "Loading context failed"

# General functions
randInt = (min, max) ->
  Math.floor( Math.random() * (max - min + 1) ) + min

every = (ms, cb) -> setInterval cb, ms

# Here for scope
game = undefined
ship = undefined
firstTime = true
musicPlaying = false

mouse = {
  x: 250
  y: 200
  leftDown: false
  rightDown: false
}

timeHandle = undefined

gameState =
  title: "Title"
  gameover: "GameOver"
  playing: "Playing"
  paused: "Paused"
  crashed: "Crashed"

currentState = gameState.title

# Included after globals are defined so they can refer to them
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
class Bomb
  constructor: (@x, @y, @speed, @cooldown, @owner) ->

  move: ->
    @y += @speed

  explode: ->
    @owner.shrapnals = @owner.shrapnals.concat( (new Shrapnal(@x, @y, ang * 36 * Math.PI / 180, 10, @owner) for ang in [0..9]) )

  draw: ->
    ctx.fillStyle = @owner.color
    ctx.fillRect( @x - 2, @y - 2, 4, 4 )

  update: ->
    @cooldown -= 1
    @explode() if @cooldown <= 0
    @move()
    @draw()
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
    @health = 1

  move: ->
    @x += 2 * Math.cos(@angle + Math.PI / 2)
    @y += 2 * Math.sin(@angle + Math.PI / 2)
    @angle += @turnVel
    @goneOnScreen = 0

  draw: ->
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( 0, 14 )
    ctx.lineTo( 5, 0 )
    ctx.lineTo( 0, -14 )
    ctx.lineTo( -5, 0 )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  bomb: ->
    @bombCooldown = 40
    game.owners.enemies.bombs.push( new Bomb( @x, @y, 4, 35, game.owners.enemies ) )

  takeDamage: ->
    # TODO: Make collision take into account rotating (bigger box?)
    if (@x < 0 or @x > canvas.width or @y < 0 or @y > canvas.height)
      return @health = 0 if @goneOnScreen
    else
      @goneOnScreen = 1
    if (Math.abs( ship.x - @x ) < 25 and Math.abs( ship.y - @y ) < 34)
      game.owners.player.health -= 24
      game.owners.player.kills += 1
      game.timers.dispHealth = 255
      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= 5 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 14
        laser.killedSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if (Math.abs( bomb.x - @x ) < 7 and Math.abs( bomb.y - @y ) < 16)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnal in game.owners.player.shrapnals
      if (Math.abs( shrapnal.x - @x ) < 6 and Math.abs( shrapnal.y - @y ) < 15)
        game.owners.player.kills += 1
        return @health = 0

  update: ->
    @bomb() if @bombCooldown is 0
    @bombCooldown -= 1
    @move()
    @draw()
    @takeDamage()

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
    @health = 1

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.beginPath()
    ctx.moveTo( @x - 10, @y - 10 )
    ctx.lineTo( @x + 10, @y - 10 )
    ctx.lineTo( @x, @y + 10 )

    ctx.closePath()
    ctx.stroke()

  move: ->
    @y += 3
    mv = (ship.x - @x) / 12
    @x += if Math.abs(mv) < 5 then mv else 5 * mv/Math.abs(mv)

  shoot: ->
    @shootCooldown = 35
    game.owners.enemies.lasers.push( new Laser( @x, @y, 20, game.owners.enemies ) )

  takeDamage: ->
    return @health = 0 if @y > canvas.height
    if (Math.abs( ship.x - @x ) < 30 and Math.abs( ship.y - @y ) < 30)
      game.owners.player.health -= 24
      game.owners.player.kills += 1
      game.timers.dispHealth = 255
      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= 10 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 10
        laser.killedSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if (Math.abs( bomb.x - @x ) < 12 and Math.abs( bomb.y - @y ) < 12)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnal in game.owners.player.shrapnals
      if (Math.abs( shrapnal.x - @x ) < 11 and Math.abs( shrapnal.y - @y ) < 11)
        game.owners.player.kills += 1
        return @health = 0

  update: ->
    @shoot() if @shootCooldown is 0
    @shootCooldown -= 1
    @move()
    @draw()
    @takeDamage()
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
class HealthUp
  constructor: (@x, @y) ->
    @used = 0

  move: ->
    @y += 5

  draw: ->
    ctx.fillStyle = "#00FF00"
    ctx.fillRect( @x - 2, @y - 2, 4, 4 )

  detectUse: ->
    if (Math.abs( ship.x - @x ) < 22 and Math.abs( ship.y - @y ) < 22)
      @used = 1
      game.owners.player.health = Math.min( game.owners.player.health + 15, 100 )
      game.timers.dispHealth = 255

    @used = 1 if (@x < 0 or @x > canvas.width or @y < 0 or @y > canvas.height)


  update: ->
    @move()
    @draw()
    @detectUse()
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
class Kamikaze
  constructor: (@x, @y) ->
    @angle = 0
    @shootCooldown = 0
    @moveState = 0
    @health = 1

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
    ctx.moveTo( -10, -10 )
    ctx.lineTo( 10, -10 )
    ctx.lineTo( 10, 4 )
    ctx.lineTo( 0, 10 )
    ctx.lineTo( -10, 4 )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  takeDamage: ->
    return @health = 0 if @y > canvas.height or @moveState and (@x < 0 or @x > canvas.width or @y < 0 or @y > canvas.height)
    if (Math.abs( ship.x - @x ) < 30 and Math.abs( ship.y - @y ) < 30)
      game.owners.player.kills += 1
      game.owners.player.health -= 35
      game.timers.dispHealth = 255
      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= 10 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 10
        laser.killedSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if (Math.abs( bomb.x - @x ) < 12 and Math.abs( bomb.y - @y ) < 12)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnal in game.owners.player.shrapnals
      if (Math.abs( shrapnal.x - @x ) < 11 and Math.abs( shrapnal.y - @y ) < 11)
        game.owners.player.kills += 1
        return @health = 0

  update: ->
    @move()
    @draw()
    @takeDamage()

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
class Laser
  constructor: (@x, @y, @speed, @owner) ->
    @killedSomething = false

  draw: ->
    ctx.fillStyle = @owner.color;
    ctx.fillRect( @x - 1, @y - 8, 2, 16 )

  move: ->
    @y += @speed

  update: ->
    @move()
    @draw()

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
    ctx.moveTo( @x, @y - 20 )
    ctx.quadraticCurveTo( @x + 20, @y, @x + 20, @y + 20 )
    ctx.quadraticCurveTo( @x + 5, @y + 10, @x, @y + 10 )
    ctx.quadraticCurveTo( @x - 5, @y + 10, @x - 20, @y + 20 )
    ctx.quadraticCurveTo( @x - 20, @y, @x, @y - 20 )
    ctx.closePath()
    ctx.stroke()

  takeDamage: ->
    for laser in game.owners.enemies.lasers
      if Math.abs(@x - laser.x) <= 20 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 20
        laser.killedSomething = true
        game.owners.player.health -= 8
        game.timers.dispHealth = 255
    for bomb in game.owners.enemies.bombs
      if (Math.abs( bomb.x - @x ) < 22 and Math.abs( bomb.y - @y ) < 22)
        bomb.cooldown = 0
        game.owners.player.health -= 2
        game.timers.dispHealth = 255
    for shrapnal in game.owners.enemies.shrapnals
      if (Math.abs( shrapnal.x - @x ) < 21 and Math.abs( shrapnal.y - @y ) < 21)
        shrapnal.cooldown = 0
        game.owners.player.health -= 2
        game.timers.dispHealth = 255

  update: ->
    @move()
    @draw()
    @takeDamage()
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
class Shrapnal
  constructor: (@x, @y, @angle, @speed, @owner) ->
    @cooldown = 10

  move: ->
    @x += (@speed * Math.cos(@angle))
    @y += (@speed * Math.sin(@angle))

  draw: ->
    ctx.fillStyle = @owner.color
    ctx.fillRect( @x - 1, @y - 1, 2, 2 )

  update: ->
    @cooldown -= 1
    @move()
    @draw()

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
    ctx.moveTo( - 10, - 10 )
    ctx.lineTo( 10, - 10 )
    ctx.lineTo( 10, 10 )
    ctx.lineTo( - 10, 10 )
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
    game.owners.enemies.lasers.push( new Laser( @x, @y, 20, game.owners.enemies ) )

  takeDamage: ->
    return @health = 0 if @y > canvas.height
    if (Math.abs( ship.x - @x ) < 30 and Math.abs( ship.y - @y ) < 30)
      game.owners.player.health -= 24
      game.owners.player.kills += 1
      game.timers.dispHealth = 255
      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= 10 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 10
        laser.killedSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if (Math.abs( bomb.x - @x ) < 12 and Math.abs( bomb.y - @y ) < 12)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnal in game.owners.player.shrapnals
      if (Math.abs( shrapnal.x - @x ) < 11 and Math.abs( shrapnal.y - @y ) < 11)
        game.owners.player.kills += 1
        return @health = 0

  update: ->
    @shoot() if @shootCooldown <= 0
    @shootCooldown -= 1
    @move()
    @draw()
    @takeDamage()
#'

setTitleFont = ->
  ctx.fillStyle = "#FFFFFF"
  ctx.font = "bold 20px Lucidia Console"
  ctx.textAlign = "center"
  ctx.textBaseline = "middle"

setLowerLeftFont = ->
  ctx.fillStyle = "#FFFFFF"
  ctx.font = "normal 18px Lucidia Console"
  ctx.textAlign = "left"
  ctx.textBaseline = "bottom"

clearScreen = ->
  ctx.fillStyle = "#000000"
  ctx.fillRect( 0, 0, canvas.width, canvas.height)

drawTitleScreen = ->
  clearScreen()
  setTitleFont()
  ctx.fillText( "Tempus [Dev]", canvas.width / 2, canvas.height / 2 - 12 )
  ctx.fillText( "Click to play", canvas.width / 2, canvas.height / 2 + 12)
  setLowerLeftFont()
  ctx.fillText( "by Jake Stothard", 10, canvas.height - 10)

drawGameOver = ->
  clearScreen()
  setTitleFont()
  ctx.fillText( "Game Over", canvas.width / 2, canvas.height / 2 - 20 )
  ctx.font = "normal 18px Lucidia Console"
  ctx.fillText( "Kills - " + game.owners.player.kills, canvas.width / 2, canvas.height / 2)
  ctx.fillText( "Lasers Fired - " + game.owners.player.lasersFired, canvas.width / 2, canvas.height / 2 + 20 )
  ctx.fillText( "Bombs Used - " + game.owners.player.bombsFired, canvas.width / 2, canvas.height / 2 + 40 )

ctx.strokeStyle = "#FFFFFF"
ctx.lineWidth = 4

firstInit = ->
  if $("#enableMusic")[0].checked
    audio.play()
    musicPlaying = true
  firstTime = false

initGame = ->
  firstInit() if firstTime
  ship = new Ship(mouse.x, mouse.y)

  game =
    owners:
      player:
        lasers: []
        bombs: []
        shrapnals: []
        units: ship
        color: "#0044FF"
        health: 100
        kills: 0
        lasersFired: 0
        bombsFired: 0

      enemies:
        lasers: []
        bombs: []
        shrapnals: []
        units: []
        color: "#FF0000"

    timers:
      dispHealth: 0
      colorCycle: 0
      colorCycleDir: 10

    powerups:
      healthups: []

    crashed: false

dispHealth = ->
  ctx.beginPath()
  ctx.arc(canvas.width / 2, canvas.height / 2, Math.min(canvas.width, canvas.height) / 2 - 20, 0, Math.max(game.owners.player.health, 0) * Math.PI / 50, false)
  ctx.stroke()

pause = ->
  currentState = gameState.paused
  clearInterval( timeHandle )
  dispHealth()
  setTitleFont()
  ctx.fillText( "[Paused]", canvas.width / 2, canvas.height / 2)

unpause = ->
  currentState = gameState.playing
  timeHandle = every 32, gameloop

$(document)
  .keyup( (e) ->
    # console.log event.which
    console.log e
    switch e.which
      when 80 # P key
        switch currentState
          when gameState.paused
            unpause()
          when gameState.playing
            pause()
  )

$("#c")
  .mousemove( (e) ->
    mouse.x = e.pageX - @offsetLeft
    mouse.y = e.pageY - @offsetTop
  )

  .mouseout( (e) ->
    pause() if currentState is gameState.playing
  )

  .mousedown( (e) ->
    # console.log e.which
    switch (e.which)
      when 1
        mouse.leftDown = true
      when 3
        mouse.rightDown = true
  )

  .mouseup( (e) ->
    # console.log e.which
    switch (e.which)
      when 1
        mouse.leftDown = false
      when 3
        mouse.rightDown = false
  )

  .click( (e) ->
    switch currentState
      when gameState.paused
        unpause()
      when gameState.title
        currentState = gameState.playing
        initGame()
        timeHandle = every 32, gameloop
      when gameState.gameOver
        currentState = gameState.title
        drawTitleScreen()
  )

  .bind("contextmenu", (e) ->
    false
  );

$("#enableMusic")
  .change( (e) ->
    if not firstTime
      if $("#enableMusic")[0].checked
        audio.play()
        musicPlaying = true
      else
        audio.pause()
        musicPlaying = false
  )


gameloop = ->

  if game.crashed
    currentState = gameState.crashed
    clearInterval( timeHandle )
    return

  game.crashed = true

  game.timers.colorCycle += game.timers.colorCycleDir
  game.timers.colorCycle = Math.min(game.timers.colorCycle, 255)
  game.timers.colorCycle = Math.max(game.timers.colorCycle, 0)
  game.timers.colorCycleDir *= -1 if game.timers.colorCycle is 0 or game.timers.colorCycle is 255

  if game.owners.player.health <= 0
    currentState = gameState.gameOver
    clearInterval( timeHandle )
    drawGameOver()
    return

  clearScreen()

  enemy.update() for enemy in game.owners.enemies.units
  game.powerups.healthups = game.powerups.healthups.concat( new HealthUp( enemy.x, enemy.y ) for enemy in game.owners.enemies.units when enemy.health <= 0 and Math.random() < 0.2 )
  game.owners.enemies.units = (enemy for enemy in game.owners.enemies.units when enemy.health > 0)

  game.owners.enemies.units.push( new Fighter( randInt(0, canvas.width), -10 ) ) if Math.random() < 0.03 and game.owners.player.kills >= 0
  game.owners.enemies.units.push( new Kamikaze( randInt(0, canvas.width), -10 ) ) if Math.random() < 0.02 and game.owners.player.kills >= 15
  game.owners.enemies.units.push( new Bomber( randInt(0, canvas.width), -10 ) ) if Math.random() < 0.01 and game.owners.player.kills >= 30
  game.owners.enemies.units.push( new Spinner( randInt(0, canvas.width), -10 ) ) if Math.random() < 0.005 and game.owners.player.kills >= 45

  ship.update()

  for ownerName, owner of game.owners
    laser.update() for laser in owner.lasers
    owner.lasers = (laser for laser in owner.lasers when 0 < laser.y < canvas.height and not laser.killedSomething)
    bomb.update() for bomb in owner.bombs
    owner.bombs = (bomb for bomb in owner.bombs when bomb.cooldown > 0)
    shrapnal.update() for shrapnal in owner.shrapnals
    owner.shrapnals = (shrapnal for shrapnal in owner.shrapnals when shrapnal.cooldown > 0)

  for powerupTypeName, powerupType of game.powerups
    powerup.update() for powerup in powerupType
    game.powerups[powerupTypeName] = (powerup for powerup in powerupType when not powerup.used)

  if mouse.leftDown and ship.laserCooldown <= 0
    game.owners.player.lasersFired += 1
    game.owners.player.lasers.push( new Laser( ship.x, ship.y, -20, game.owners.player) )
    if ship.heat > 80
      ship.laserCooldown = 7
    else if ship.heat > 40
      ship.laserCooldown = 5
    else
      ship.laserCooldown = 2
    ship.heat += 7

  if mouse.rightDown and ship.bombCooldown <= 0
    game.owners.player.bombsFired += 1
    game.owners.player.bombs.push( new Bomb( ship.x, ship.y, -12, 20, game.owners.player) ) if currentState is gameState.playing
    if ship.heat > 80
      ship.bombCooldown = 20
    else if ship.heat > 40
      ship.bombCooldown = 10
    else
      ship.bombCooldown = 5
    ship.heat += 10

  ship.laserCooldown -= 1 if ship.laserCooldown > 0
  ship.bombCooldown -= 1 if ship.bombCooldown > 0
  ship.heat -= 1 if ship.heat > 0

  ctx.textAlign = "center"
  ctx.textBaseline = "bottom"

  if ship.heat > 80
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",0,0)");
    ctx.font = "bold 20px Lucidia Console"
    ctx.fillText( "[ Heat Critical ]", canvas.width / 2, canvas.height - 30)
  else if ship.heat > 40
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",", game.timers.colorCycle, ",0)");
    ctx.font = "normal 18px Lucidia Console"
    ctx.fillText( "[ Heat Warning ]", canvas.width / 2, canvas.height - 30)

  if game.timers.dispHealth > 0
    ctx.strokeStyle = "rgb(".concat( game.timers.dispHealth , "," , game.timers.dispHealth , "," , game.timers.dispHealth , ")" )
    dispHealth()
    ctx.strokeStyle = "#FFFFFF"
    game.timers.dispHealth -= 10

  game.crashed = false

# Can change how game begins based on what you start the state as
# Allows for auto-play like behavior if you want it
switch currentState
  when gameState.playing
    initGame()
    timeHandle = every 32, gameloop
  when gameState.title
    drawTitleScreen()

