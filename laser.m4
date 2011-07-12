class Laser
  constructor: (@x, @y, @speed, @owner) ->
    @killedSomething = false

  draw: ->
    ctx.fillStyle = @owner.color
    ctx.fillRect( @x - 1, @y - LASER_LENGTH / 2, 2, LASER_LENGTH )

  move: ->
    @y += @speed

  update: ->
    @move()
    @draw()
