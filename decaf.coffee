canvas = document.getElementById("c")
ctx = canvas.getContext("2d")

if not ctx
  throw "Loading context failed"

#Color determines what color does not kill you
GOOD_COLOR = "#0044FF"
BAD_COLOR = "#FF0000"

LASER_SPEED = 30
LASER_LENGTH = 16
BOMB_SPEED = 12
ENEMY_RAND = 0.05

lasers = []
enemies = []
bombs = []
shrapnals = []
mouseX = 250
mouseY = 200
crashed = false
paused = false
timeHandle = undefined

class Ship
  constructor: (@x, @y) ->

  move: ->
    ship.x = (ship.x + mouseX) / 2
    ship.y = (ship.y + mouseY) / 2

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.beginPath()
    ctx.moveTo( @x, @y - 20 )
    ctx.quadraticCurveTo( @x + 20, @y, @x + 20, @y + 20 )
    ctx.quadraticCurveTo( @x + 5, @y + 10, @x, @y + 10)
    ctx.quadraticCurveTo( @x - 5, @y + 10, @x - 20, @y + 20 )
    ctx.quadraticCurveTo( @x - 20, @y, @x, @y - 20 )
    ctx.closePath()
    ctx.stroke()

  update: ->
    @move()
    @draw()

class Enemy
  constructor: (@x, @y) ->
    @shootCooldown = 0

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.beginPath()
    ctx.moveTo( @x - 10, @y - 10 )
    ctx.lineTo( @x + 10, @y - 10 )
    ctx.lineTo( @x, @y + 10 )
    # ctx.lineTo( @x - 10, @y - 10 ) Default behavior when closing path anyway
    ctx.closePath()
    ctx.stroke()

  move: ->
    @y += 3
    mv = (ship.x - @x) / 12
    @x += if Math.abs(mv) < 5 then mv else 5 * mv/Math.abs(mv)

  shoot: ->
    @shootCooldown = 35
    lasers.push( new Laser( @x, @y, LASER_SPEED, BAD_COLOR ) )

  alive: ->
    return false if @y > canvas.height
    for laser in lasers
      #Takes into account color, laser length, laser speed, and ship size
      if laser.color is GOOD_COLOR and Math.abs(@x - laser.x) <= 7 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10
        laser.killedSomething = true
        return false
    true

  update: ->
    @shoot() if @shootCooldown is 0
    @shootCooldown -= 1
    @move()
    @draw()

class Laser
  constructor: (@x, @y, @speed, @color) ->
    @killedSomething = false

  draw: ->
    ctx.fillStyle = @color
    ctx.fillRect( @x - 1, @y - LASER_LENGTH / 2, 2, LASER_LENGTH )

  move: ->
    @y += @speed

  update: ->
    @move()
    @draw()

class Shrapnal
  constructor: (@x, @y, @angle, @speed, @color) ->
    @cooldown = 10

  move: ->
    @x += (@speed * Math.cos(@angle))
    @y += (@speed * Math.sin(@angle))

  draw: ->
    ctx.fillStyle = @color
    ctx.fillRect( @x - 1, @y - 1, 2, 2 )

  update: ->
    @cooldown -= 1
    @move()
    @draw()

class Bomb
  constructor: (@x, @y, @speed, @color) ->
    @cooldown = 20

  move: ->
    @y += @speed

  explode: ->
    shrapnals = shrapnals.concat( (new Shrapnal(@x, @y, ang * 36 * Math.PI / 180, @speed, @color) for ang in [0..9]) )

  draw: ->
    ctx.fillStyle = @color
    ctx.fillRect( @x - 2, @y - 2, 4, 4 )

  update: ->
    @cooldown -= 1
    @explode() if @cooldown <= 0
    @move()
    @draw()

randInt = (min, max) ->
  Math.floor( Math.random() * (max - min + 1) ) + min

ctx.fillStyle = "#000000"
ctx.strokeStyle = "#FFFFFF"

ctx.fillRect( 0, 0, canvas.width, canvas.height )

ctx.lineWidth = 4

ship = new Ship(mouseX, mouseY)

$(document)
  .keyup( (e) ->
    console.log event.which
    switch event.which
      when 80 # P key
        if paused then timeHandle = every 32, gameloop else clearInterval( timeHandle )
        paused = not paused
  )

$("#c")
  .mousemove( (e) ->
    mouseX = e.pageX - @offsetLeft
    mouseY = e.pageY - @offsetTop
  )

  .click( (e) ->
    lasers.push( new Laser( ship.x, ship.y, -LASER_SPEED, GOOD_COLOR) )
  )

  .bind("contextmenu", (e) ->
    bombs.push( new Bomb( ship.x, ship.y, -BOMB_SPEED, GOOD_COLOR) )
    false
  );

every = (ms, cb) -> setInterval cb, ms

gameloop = ->
  return clearInterval( timeHandle ) if crashed

  crashed = true

  ctx.fillStyle = "#000000"
  ctx.fillRect( 0, 0, canvas.width, canvas.height )

  laser.update() for laser in lasers
  lasers = (laser for laser in lasers when 0 < laser.y < canvas.height and not laser.killedSomething)

  enemy.update() for enemy in enemies
  enemies = (enemy for enemy in enemies when enemy.alive())
  enemies.push( new Enemy( randInt(0, canvas.width), -10 ) ) if Math.random() < ENEMY_RAND

  bomb.update() for bomb in bombs
  bombs = (bomb for bomb in bombs when bomb.cooldown isnt 0)
  shrapnal.update() for shrapnal in shrapnals
  shrapnals = (shrapnal for shrapnal in shrapnals when shrapnal.cooldown > 0)

  ship.update()

  crashed = false

timeHandle = every 32, gameloop