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

# Globals are evil
# But they are also very convenient, especially when I started writing this.
# Now that this is split across multiple files the least I can do is have
# them in a separate file which is included by all files which use them.

game = undefined
ship = undefined
firstTime = true
musicPlaying = false

mouse =
  x: 250
  y: 200
  leftDown: false
  rightDown: false
  beginLeftHold: undefined

timeHandle = undefined
autoPauseHandle = undefined
timeOfGameOver = undefined

gameState =
  title: "Title"
  gameover: "GameOver"
  playing: "Playing"
  paused: "Paused"
  crashed: "Crashed"

currentState = undefined

beginPauseTime = undefined
