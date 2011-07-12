define(SHIP_WIDTH,40)dnl
define(SHIP_HEIGHT,40)dnl
# Should it really be a class if it seems I really only ever make one of them?
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
    ctx.moveTo( @x, @y - eval(SHIP_HEIGHT / 2) )
    ctx.quadraticCurveTo( @x + eval(SHIP_WIDTH / 2), @y, @x + eval(SHIP_WIDTH / 2), @y + eval(SHIP_HEIGHT / 2) )
    ctx.quadraticCurveTo( @x + eval(SHIP_WIDTH / 8), @y + eval(SHIP_HEIGHT / 4), @x, @y + eval(SHIP_HEIGHT / 4) )
    ctx.quadraticCurveTo( @x - eval(SHIP_WIDTH / 8), @y + eval(SHIP_HEIGHT / 4), @x - eval(SHIP_WIDTH / 2), @y + eval(SHIP_HEIGHT / 2) )
    ctx.quadraticCurveTo( @x - eval(SHIP_WIDTH / 2), @y, @x, @y - eval(SHIP_HEIGHT / 2) )
    ctx.closePath()
    ctx.stroke()

  update: ->
    @move()
    @draw()
