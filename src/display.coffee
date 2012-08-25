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
# Copyright 2011, 2012 Jake Stothard

# Do not instantiate this singleton directly
# Use Display.get instead
class DisplaySingleton
  constructor: ->
    @canvas = document.getElementById("c")
    @ctx = @canvas.getContext("2d")

  setTitleFont: ->
    @ctx.fillStyle = "#FFFFFF"
    @ctx.font = "bold 20px Lucidia Console"
    @ctx.textAlign = "center"
    @ctx.textBaseline = "middle"

  setLowerLeftFont: ->
    @ctx.fillStyle = "#FFFFFF"
    @ctx.font = "normal 18px Lucidia Console"
    @ctx.textAlign = "left"
    @ctx.textBaseline = "bottom"

  clearScreen: ->
    @ctx.fillStyle = "#000000"
    @ctx.fillRect( 0, 0, @canvas.width, @canvas.height)

  drawTitleScreen: ->
    @clearScreen()
    @setTitleFont()
    @ctx.fillText( "Tempus [Dev]", @canvas.width / 2, @canvas.height / 2 - 12 )
    @ctx.fillText( "Click to play", @canvas.width / 2, @canvas.height / 2 + 12)
    @setLowerLeftFont()
    @ctx.fillText( "by Jake Stothard", 10, @canvas.height - 10)

  drawGameOver: ->
    @clearScreen()
    @setTitleFont()
    @ctx.fillText( "Game Over", @canvas.width / 2, @canvas.height / 2 - 20 )
    @ctx.font = "normal 18px Lucidia Console"
    @ctx.fillText( "Kills - " + game.owners.player.kills, @canvas.width / 2, @canvas.height / 2)
    @ctx.fillText( "Lasers Fired - " + game.owners.player.lasersFired, @canvas.width / 2, @canvas.height / 2 + 20 )
    @ctx.fillText( "Bombs Used - " + game.owners.player.bombsFired, @canvas.width / 2, @canvas.height / 2 + 40 )

  drawHealth: ->
    if currentState is gameState.paused
      @ctx.strokeStyle = "#00FF00"
    else
      @ctx.strokeStyle = "rgba(0,255,0,".concat( game.timers.dispHealth / 255.0 , ")" )
    @ctx.beginPath()
    @ctx.arc(@canvas.width / 2, @canvas.height / 2, Math.min(@canvas.width, @canvas.height) / 2 - 20, 0, Math.max(ship.health, 0) * Math.PI * 2 / SHIP_MAX_HEALTH, false)
    @ctx.stroke()
    if currentState is gameState.paused
      @ctx.strokeStyle = "rgb(0,127,255)"
    else
      @ctx.strokeStyle = "rgba(0,127,255,".concat( game.timers.dispHealth / 255.0 , ")" )
    @ctx.beginPath()
    @ctx.arc(@canvas.width / 2, @canvas.height / 2, Math.min(@canvas.width, @canvas.height) / 2 - 40, 0, Math.max(ship.shield, 0) * Math.PI * 2 / SHIP_MAX_SHIELD, false)
    @ctx.stroke()

  drawLives: ->
    if game.owners.player.lives < 1
      return
    if currentState is gameState.paused
      @ctx.fillStyle = "#FFFFFF"
    else
      @ctx.fillStyle = "rgba(255,255,255,".concat( game.timers.dispLives / 255.0 , ")" )
    for life in [1..game.owners.player.lives]
      @ctx.beginPath()
      @ctx.arc(11 * life, @canvas.height - 11, 5, 0, Math.PI * 2, false)
      @ctx.closePath()
      @ctx.fill()

class Display
  _instance = undefined
  @get: ->
    _instance ?= new DisplaySingleton()

