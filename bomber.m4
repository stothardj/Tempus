define(BOMBER_RAND,0.02)dnl
define(BOMBER_THRESHOLD,0)dnl
define(BOMBER_WIDTH,10)dnl
define(BOMBER_HEIGHT,28)dnl
class Bomber
  constructor: (@x, @y) ->
    @angle = 0
    @bombCooldown = 0
    @turnVel = (Math.random() - 0.5) / 30;

  move: ->
    @x += 2 * Math.cos(@angle + Math.PI / 2)
    @y += 2 * Math.sin(@angle + Math.PI / 2)
    @angle += @turnVel
    @goneOnScreen = 0

  draw: ->
    ctx.translate( @x, @y )
    ctx.rotate( @angle )
    ctx.beginPath()
    ctx.moveTo( 0, eval(BOMBER_HEIGHT / 2) )
    ctx.lineTo( eval(BOMBER_WIDTH / 2), 0 )
    ctx.lineTo( 0, -eval(BOMBER_HEIGHT / 2) )
    ctx.lineTo( -eval(BOMBER_WIDTH / 2), 0 )
    ctx.closePath()
    ctx.stroke()
    ctx.rotate( -@angle )
    ctx.translate( -@x, -@y )

  update: ->
    @move()
    @draw()

  alive: ->
    if offscreen
      return false if @goneOnScreen
    else
      @goneOnScreen = 1

    true
