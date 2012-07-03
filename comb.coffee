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

# Many objects are basically treated as boxes
class Box
  constructor: (@x, @y) ->

  boxHit: (other) ->
    Math.abs( other.x - @x ) < (other.width + @width) / 2 and Math.abs( other.y - @y ) < (other.height + @height) / 2

  offscreen: ->
    @x < 0 or @x > canvas.width or @y < 0 or @y > canvas.height

  drawAsBox: ->
    ctx.fillRect( @x - @width / 2, @y - @height / 2, @width, @height )

class Bomb extends Box
  constructor: (@x, @y, @speed, @cooldown, @owner) ->

  width: 4
  height: 4
  speed: 12

  move: ->
    @y += @speed

  explode: ->
    @owner.shrapnals = @owner.shrapnals.concat( (new Shrapnal(@x, @y, ang * 36 * Math.PI / 180, Shrapnal::speed, @owner) for ang in [0..9]) )

  draw: ->
    ctx.fillStyle = @owner.color
    @drawAsBox()

  update: ->
    @cooldown -= 1
    @explode() if @cooldown <= 0
    @move()
    @draw()# This file is part of Tempus.
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

GOOD_COLOR = "#0044FF"
BAD_COLOR = "#FF0000"
SHIP_MAX_HEALTH = 100
SHIP_MAX_SHIELD = 4000# This file is part of Tempus.
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

# Note this is an abstract class, not to be instantiated
class PowerUp extends Box
  constructor: (@x, @y) ->
    @used = 0

  move: ->
    @y += @speed

  draw: ->
    ctx.fillStyle = @color
    @drawAsBox()

  detectUse: ->
    if @boxHit(ship)
      @used = 1
      @use()

    @used = 1 if @offscreen()

  update: ->
    @move()
    @draw()
    @detectUse()
class HealthUp extends PowerUp
  constructor: (@x, @y) ->
    super(@x, @y)

  rand: 0.05
  width: 4
  height: 4
  speed: 5
  color: "#00FF00"

  use: ->
    game.owners.player.health = Math.min( game.owners.player.health + 15, SHIP_MAX_HEALTH )
    game.timers.dispHealth = 255
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

class ShieldUp extends PowerUp
  constructor: (@x, @y) ->
    super(@x, @y)

  rand: 0.1
  width: 4
  height: 4
  speed: 5
  color: "#0088FF"

  use: ->
    game.owners.player.shield = Math.min( game.owners.player.shield + 200, SHIP_MAX_SHIELD )
    game.timers.dispHealth = 255# This file is part of Tempus.
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
    @laserPower = 1

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


class Bomber extends Box
  constructor: (@x, @y) ->
    @angle = 0
    @bombCooldown = 0
    @turnVel = (Math.random() - 0.5) / 30;
    @health = 1

  rand: 0.01
  threshold: 30
  width: 10
  height: 28

  move: ->
    @x += 2 * Math.cos(@angle + Math.PI / 2)
    @y += 2 * Math.sin(@angle + Math.PI / 2)
    @angle += @turnVel
    @goneOnScreen = 0

  draw: ->
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( 0, @height / 2 )
    ctx.lineTo( @width / 2, 0 )
    ctx.lineTo( 0, - @height / 2 )
    ctx.lineTo( - @width / 2, 0 )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  bomb: ->
    @bombCooldown = 40
    game.owners.enemies.bombs.push( new Bomb( @x, @y, 4, 35, game.owners.enemies ) )

  takeDamage: ->
    # TODO: Make collision take into account rotating (bigger box?)
    if @offscreen()
      return @health = 0 if @goneOnScreen
    else
      @goneOnScreen = 1
    if @boxHit(ship)
      ship.damage(24)
      game.owners.player.kills += 1

      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= @width / 2 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + @height / 2
        laser.killedSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if @boxHit(bomb)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnal in game.owners.player.shrapnals
      if @boxHit(shrapnal)
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

class Kamikaze extends Box
  constructor: (@x, @y) ->
    @angle = 0
    @shootCooldown = 0
    @moveState = 0
    @health = 1

  rand: 0.02
  threshold: 15
  width: 20
  height: 20

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
    ctx.moveTo( - @width / 2, - @height / 2 )
    ctx.lineTo( @width / 2, - @height / 2 )
    ctx.lineTo( @width / 2, @height / 5 )
    ctx.lineTo( 0, @height / 2 )
    ctx.lineTo( - @width / 2, @height / 5 )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  takeDamage: ->
    return @health = 0 if @y > canvas.height or @moveState and @offscreen()
    if @boxHit(ship)
      game.owners.player.kills += 1
      ship.damage(35)
      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= @width / 2 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + @height / 2
        laser.killedSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if @boxHit(bomb)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnal in game.owners.player.shrapnals
      if @boxHit(shrapnal)
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

class LaserUp extends PowerUp
  constructor: (@x, @y) ->
    super(@x, @y)

  rand: 0.02
  width: 4
  height: 4
  speed: 5
  color: "#FF9900"

  use: ->
    ship.laserPower += 1

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

  speed: 10
  width: 2
  height: 2

  drawAsBox: ->
    ctx.fillRect( @x - @width / 2, @y - @height / 2, @width, @height )

  move: ->
    @x += (@speed * Math.cos(@angle))
    @y += (@speed * Math.sin(@angle))

  draw: ->
    ctx.fillStyle = @owner.color
    @drawAsBox()

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
class Fighter
  constructor: (@x, @y) ->
    @shootCooldown = 0
    @health = 1

  rand: 0.03
  threshold: 0
  width: 20
  height: 20

  boxHit: (other) ->
    Math.abs( other.x - @x ) < (other.width + @width) / 2 and Math.abs( other.y - @y ) < (other.height + @height) / 2

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
    @shootCooldown = 35
    game.owners.enemies.lasers.push( new Laser( @x, @y, Laser::speed, game.owners.enemies ) )

  takeDamage: ->
    return @health = 0 if @y > canvas.height
    if @boxHit(ship)
      ship.damage(24)
      game.owners.player.kills += 1
      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= @width / 2 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + @height / 2
        laser.killedSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if @boxHit(bomb)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnal in game.owners.player.shrapnals
      if @boxHit(shrapnal)
        game.owners.player.kills += 1
        return @health = 0

  update: ->
    @shoot() if @shootCooldown is 0
    @shootCooldown -= 1
    @move()
    @draw()
    @takeDamage()# This file is part of Tempus.
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

  speed: 20
  width: 2
  height: 16

  drawAsBox: ->
    ctx.fillRect( @x - @width / 2, @y - @height / 2, @width, @height )

  draw: ->
    ctx.fillStyle = @owner.color;
    @drawAsBox()

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
class Spinner
  constructor: (@x, @y) ->
    @angle = 0
    @shootCooldown = 0
    @burst = 0
    @health = 1

  rand: 0.005
  threshold: 45
  width: 20
  height: 20

  boxHit: (other) ->
    Math.abs( other.x - @x ) < (other.width + @width) / 2 and Math.abs( other.y - @y ) < (other.height + @height) / 2
  
  draw: ->
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( - @width / 2, - @height / 2 )
    ctx.lineTo( @width / 2, - @height / 2 )
    ctx.lineTo( @width / 2, @height / 2 )
    ctx.lineTo( - @width / 2, @height / 2 )
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
    game.owners.enemies.lasers.push( new Laser( @x, @y, Laser::speed, game.owners.enemies ) )

  takeDamage: ->
    return @health = 0 if @y > canvas.height
    if @boxHit(ship)
      ship.damage(24)
      game.owners.player.kills += 1
      return @health = 0
    for laser in game.owners.player.lasers
      if Math.abs(@x - laser.x) <= @width / 2 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + @height / 2
        laser.killedSomething = true
        game.owners.player.kills += 1
        return @health = 0
    for bomb in game.owners.player.bombs
      if @boxHit(bomb)
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return @health = 0
    for shrapnal in game.owners.player.shrapnals
      if @boxHit(shrapnal)
        game.owners.player.kills += 1
        return @health = 0

  update: ->
    @shoot() if @shootCooldown <= 0
    @shootCooldown -= 1
    @move()
    @draw()
    @takeDamage()
genship = (t) ->
  if game.owners.player.kills >= t::threshold and Math.random() < t::rand
    game.owners.enemies.units.push( new t( randInt(0, canvas.width), -10 ) )

canvas = document.getElementById("c")
ctx = canvas.getContext("2d")
audio = $('<audio></audio>')
  .attr({ 'loop' : 'loop'})
  .append($('<source></source>')
  .attr({ 'src' : 'media/tonight_full.ogg'})
  .attr({ 'type': 'audio/ogg' }))
  .append($('<source></source>')
  .attr({ 'src' : 'media/tonight_full.mp3'})
  .attr({ 'type': 'audio/mpeg'}))
  .appendTo('body')[0]

console.log audio

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
  #TODO: Decided on concrete separation of what goes in game.owners.player and what is bound to ship
  firstInit() if firstTime
  ship = new Ship(mouse.x, mouse.y)

  game =
    owners:
      player:
        lasers: []
        bombs: []
        shrapnals: []
        units: ship
        color: GOOD_COLOR
        health: SHIP_MAX_HEALTH
        shield: 0
        kills: 0
        lasersFired: 0
        bombsFired: 0

      enemies:
        lasers: []
        bombs: []
        shrapnals: []
        units: []
        color: BAD_COLOR

    timers:
      dispHealth: 0
      colorCycle: 0
      colorCycleDir: 10

    powerups:
      healthups: []
      laserups: []
      shieldups: []

    crashed: false

dispHealth = ->
  ctx.strokeStyle = "rgb(0,".concat( game.timers.dispHealth , ",0)" )
  ctx.beginPath()
  ctx.arc(canvas.width / 2, canvas.height / 2, Math.min(canvas.width, canvas.height) / 2 - 20, 0, Math.max(game.owners.player.health, 0) * Math.PI * 2 / SHIP_MAX_HEALTH, false)
  ctx.stroke()
  ctx.strokeStyle = "rgb(0,".concat( Math.floor(game.timers.dispHealth / 2) , "," , game.timers.dispHealth , ")" )
  ctx.beginPath()
  ctx.arc(canvas.width / 2, canvas.height / 2, Math.min(canvas.width, canvas.height) / 2 - 40, 0, Math.max(game.owners.player.shield, 0) * Math.PI * 2 / SHIP_MAX_SHIELD, false)
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
    # console.log e
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
  #TODO: make powerup looped over instead of copying code
  game.powerups.healthups = game.powerups.healthups.concat( new HealthUp( enemy.x, enemy.y ) for enemy in game.owners.enemies.units when enemy.health <= 0 and Math.random() < HealthUp::rand )
  game.powerups.shieldups = game.powerups.shieldups.concat( new ShieldUp( enemy.x, enemy.y ) for enemy in game.owners.enemies.units when enemy.health <= 0 and Math.random() < ShieldUp::rand )
  game.powerups.laserups = game.powerups.laserups.concat( new LaserUp( enemy.x, enemy.y ) for enemy in game.owners.enemies.units when enemy.health <= 0 and Math.random() < LaserUp::rand )

  game.owners.enemies.units = (enemy for enemy in game.owners.enemies.units when enemy.health > 0)

  genship(Fighter)
  genship(Kamikaze)
  genship(Bomber)
  genship(Spinner)

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
    game.owners.player.lasersFired += ship.laserPower
    for i in [1..ship.laserPower]
      game.owners.player.lasers.push( new Laser( ship.x + i * 4 - ship.laserPower * 2, ship.y, -Laser::speed, game.owners.player) )
    if ship.heat > 80
      ship.laserCooldown = 7
    else if ship.heat > 40
      ship.laserCooldown = 5
    else
      ship.laserCooldown = 2
    ship.heat += 7

  if mouse.rightDown and ship.bombCooldown <= 0
    game.owners.player.bombsFired += 1
    game.owners.player.bombs.push( new Bomb( ship.x, ship.y, -Bomb::speed, 20, game.owners.player) ) if currentState is gameState.playing
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
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",0,0)")
    ctx.font = "bold 20px Lucidia Console"
    ctx.fillText( "[ Heat Critical ]", canvas.width / 2, canvas.height - 30)
  else if ship.heat > 40
    ctx.fillStyle = "rgb(".concat( game.timers.colorCycle, ",", game.timers.colorCycle, ",0)");
    ctx.font = "normal 18px Lucidia Console"
    ctx.fillText( "[ Heat Warning ]", canvas.width / 2, canvas.height - 30)

  if game.timers.dispHealth > 0
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

