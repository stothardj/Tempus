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
