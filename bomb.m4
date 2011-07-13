class Bomb
  constructor: (@x, @y, @speed, @cooldown, @owner) ->

  move: ->
    @y += @speed

  explode: ->
    @owner.shrapnals = @owner.shrapnals.concat( (new Shrapnal(@x, @y, ang * 36 * Math.PI / 180, SHRAPNAL_SPEED, @owner) for ang in [0..9]) )

  draw: ->
    ctx.fillStyle = @owner.color
    ctx.fillRect( @x - 2, @y - 2, 4, 4 )

  update: ->
    console.log( "Begin cooldown ".concat( @cooldown ) )
    @cooldown -= 1
    @explode() if @cooldown <= 0
    console.log( "End cooldown ".concat( @cooldown ) )
    @move()
    @draw()
