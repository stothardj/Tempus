class Bomb
  constructor: (@x, @y, @speed, @owner) ->
    @cooldown = 20

  move: ->
    @y += @speed

  explode: ->
    @owner.shrapnals = @owner.shrapnals.concat( (new Shrapnal(@x, @y, ang * 36 * Math.PI / 180, @speed, @owner) for ang in [0..9]) )

  draw: ->
    ctx.fillStyle = @owner.color
    ctx.fillRect( @x - 2, @y - 2, 4, 4 )

  update: ->
    @cooldown -= 1
    @explode() if @cooldown <= 0
    @move()
    @draw()
