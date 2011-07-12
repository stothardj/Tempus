define(FIGHTER_RAND,0.04)dnl
define(FIGHTER_THRESHOLD,0)dnl
define(FIGHTER_WIDTH,20)dnl
define(FIGHTER_HEIGHT,20)dnl
class Fighter
  constructor: (@x, @y) ->
    @shootCooldown = 0

  draw: ->
    ctx.strokeStyle = "#FFFFFF"
    ctx.beginPath()
    ctx.moveTo( @x - eval(FIGHTER_WIDTH / 2), @y - eval(FIGHTER_HEIGHT / 2) )
    ctx.lineTo( @x + eval(FIGHTER_WIDTH / 2), @y - eval(FIGHTER_HEIGHT / 2) )
    ctx.lineTo( @x, @y + eval(FIGHTER_HEIGHT / 2) )

    ctx.closePath()
    ctx.stroke()

  move: ->
    @y += 3
    mv = (ship.x - @x) / 12
    @x += if Math.abs(mv) < 5 then mv else 5 * mv/Math.abs(mv)

  shoot: ->
    @shootCooldown = 35
    game.owners.enemies.lasers.push( new Laser( @x, @y, LASER_SPEED, game.owners.enemies ) )

  alive: ->
    return false if @y > canvas.height
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

  update: ->
    @shoot() if @shootCooldown is 0
    @shootCooldown -= 1
    @move()
    @draw()
