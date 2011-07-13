define(BOMBER_RAND,0.01)dnl
define(BOMBER_THRESHOLD,30)dnl
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

  bomb: ->
    @bombCooldown = 40
    game.owners.enemies.bombs.push( new Bomb( @x, @y, 4, 35, game.owners.enemies ) )

  update: ->
    @bomb() if @bombCooldown is 0
    @bombCooldown -= 1
    @move()
    @draw()

  alive: ->
    if offscreen
      return false if @goneOnScreen
    else
      @goneOnScreen = 1
    if Math.abs( ship.x - @x ) < 35 and Math.abs( ship.y - @y ) < 35
      game.owners.player.health -= 24
      game.owners.player.kills += 1
      game.timers.dispHealth = 255
      return false
    for laser in game.owners.player.lasers
      # Takes into account color, laser length, laser speed, and ship size
      if Math.abs(@x - laser.x) <= 12 and Math.abs(@y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10
        laser.killedSomething = true
        game.owners.player.kills += 1
        return false
    for bomb in game.owners.player.bombs
      # Takes into account color, bomb size, bomb speed, and ship size
      if Math.abs(@x - bomb.x) <= 12 and Math.abs(@y - bomb.y + bomb.speed / 2) <= Math.abs(bomb.speed) / 2 + 12
        bomb.cooldown = 0
        game.owners.player.kills += 1
        return false
    for shrap in game.owners.player.shrapnals
      # Takes into account color, shrap size, and ship size
      if Math.abs(@x - shrap.x) <= 11 and Math.abs(@y - shrap.y) <= 11
        game.owners.player.kills += 1
        return false

    true
