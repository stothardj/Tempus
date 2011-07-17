(function() {
  var Bomb, Bomber, Fighter, Kamikaze, Laser, Ship, Shrapnal, audio, canvas, clearScreen, ctx, currentState, dispHealth, drawGameOver, drawTitleScreen, every, firstInit, firstTime, game, gameState, gameloop, initGame, mouse, musicPlaying, pause, randInt, setLowerLeftFont, setTitleFont, ship, timeHandle, unpause;
  canvas = document.getElementById("c");
  ctx = canvas.getContext("2d");
  audio = $('<audio></audio>').attr({
    'loop': 'loop'
  }).append($('<source><source>').attr({
    'src': 'media/tonight_full.ogg'
  })).appendTo('body')[0];
  if (!ctx) {
    throw "Loading context failed";
  }
  randInt = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };
  every = function(ms, cb) {
    return setInterval(cb, ms);
  };
  game = void 0;
  ship = void 0;
  firstTime = true;
  musicPlaying = false;
  mouse = {
    x: 250,
    y: 200,
    leftDown: false,
    rightDown: false
  };
  timeHandle = void 0;
  gameState = {
    title: "Title",
    gameover: "GameOver",
    playing: "Playing",
    paused: "Paused",
    crashed: "Crashed"
  };
  currentState = gameState.title;
  Bomb = (function() {
    function Bomb(x, y, speed, cooldown, owner) {
      this.x = x;
      this.y = y;
      this.speed = speed;
      this.cooldown = cooldown;
      this.owner = owner;
    }
    Bomb.prototype.move = function() {
      return this.y += this.speed;
    };
    Bomb.prototype.explode = function() {
      var ang;
      return this.owner.shrapnals = this.owner.shrapnals.concat((function() {
        var _results;
        _results = [];
        for (ang = 0; ang <= 9; ang++) {
          _results.push(new Shrapnal(this.x, this.y, ang * 36 * Math.PI / 180, 10, this.owner));
        }
        return _results;
      }).call(this));
    };
    Bomb.prototype.draw = function() {
      ctx.fillStyle = this.owner.color;
      return ctx.fillRect(this.x - 2, this.y - 2, 4, 4);
    };
    Bomb.prototype.update = function() {
      this.cooldown -= 1;
      if (this.cooldown <= 0) {
        this.explode();
      }
      this.move();
      return this.draw();
    };
    return Bomb;
  })();
  Bomber = (function() {
    function Bomber(x, y) {
      this.x = x;
      this.y = y;
      this.angle = 0;
      this.bombCooldown = 0;
      this.turnVel = (Math.random() - 0.5) / 30;
    }
    Bomber.prototype.move = function() {
      this.x += 2 * Math.cos(this.angle + Math.PI / 2);
      this.y += 2 * Math.sin(this.angle + Math.PI / 2);
      this.angle += this.turnVel;
      return this.goneOnScreen = 0;
    };
    Bomber.prototype.draw = function() {
      ctx.translate(this.x, this.y);
      ctx.rotate(this.angle);
      ctx.beginPath();
      ctx.moveTo(0, 14);
      ctx.lineTo(5, 0);
      ctx.lineTo(0, -14);
      ctx.lineTo(-5, 0);
      ctx.closePath();
      ctx.stroke();
      ctx.rotate(-this.angle);
      return ctx.translate(-this.x, -this.y);
    };
    Bomber.prototype.bomb = function() {
      this.bombCooldown = 40;
      return game.owners.enemies.bombs.push(new Bomb(this.x, this.y, 4, 35, game.owners.enemies));
    };
    Bomber.prototype.update = function() {
      if (this.bombCooldown === 0) {
        this.bomb();
      }
      this.bombCooldown -= 1;
      this.move();
      return this.draw();
    };
    Bomber.prototype.alive = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height) {
        if (this.goneOnScreen) {
          return false;
        }
      } else {
        this.goneOnScreen = 1;
      }
      if (Math.abs(ship.x - this.x) < 25 && Math.abs(ship.y - this.y) < 34) {
        game.owners.player.health -= 24;
        game.owners.player.kills += 1;
        game.timers.dispHealth = 255;
        return false;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= 5 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 14) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return false;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (Math.abs(bomb.x - this.x) < 7 && Math.abs(bomb.y - this.y) < 16) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return false;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (Math.abs(shrapnal.x - this.x) < 6 && Math.abs(shrapnal.y - this.y) < 15) {
          game.owners.player.kills += 1;
          return false;
        }
      }
      return true;
    };
    return Bomber;
  })();
  Fighter = (function() {
    function Fighter(x, y) {
      this.x = x;
      this.y = y;
      this.shootCooldown = 0;
    }
    Fighter.prototype.draw = function() {
      ctx.strokeStyle = "#FFFFFF";
      ctx.beginPath();
      ctx.moveTo(this.x - 10, this.y - 10);
      ctx.lineTo(this.x + 10, this.y - 10);
      ctx.lineTo(this.x, this.y + 10);
      ctx.closePath();
      return ctx.stroke();
    };
    Fighter.prototype.move = function() {
      var mv;
      this.y += 3;
      mv = (ship.x - this.x) / 12;
      return this.x += Math.abs(mv) < 5 ? mv : 5 * mv / Math.abs(mv);
    };
    Fighter.prototype.shoot = function() {
      this.shootCooldown = 35;
      return game.owners.enemies.lasers.push(new Laser(this.x, this.y, 20, game.owners.enemies));
    };
    Fighter.prototype.alive = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.y > canvas.height) {
        return false;
      }
      if (Math.abs(ship.x - this.x) < 30 && Math.abs(ship.y - this.y) < 30) {
        game.owners.player.health -= 24;
        game.owners.player.kills += 1;
        game.timers.dispHealth = 255;
        return false;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= 10 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 10) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return false;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (Math.abs(bomb.x - this.x) < 12 && Math.abs(bomb.y - this.y) < 12) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return false;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (Math.abs(shrapnal.x - this.x) < 11 && Math.abs(shrapnal.y - this.y) < 11) {
          game.owners.player.kills += 1;
          return false;
        }
      }
      return true;
    };
    Fighter.prototype.update = function() {
      if (this.shootCooldown === 0) {
        this.shoot();
      }
      this.shootCooldown -= 1;
      this.move();
      return this.draw();
    };
    return Fighter;
  })();
  Kamikaze = (function() {
    function Kamikaze(x, y) {
      this.x = x;
      this.y = y;
      this.angle = 0;
      this.shootCooldown = 0;
      this.moveState = 0;
    }
    Kamikaze.prototype.move = function() {
      var desired_angle;
      switch (this.moveState) {
        case 0:
          if (Math.abs(this.x - ship.x) < 150 && Math.abs(this.y - ship.y) < 150) {
            return this.moveState = 1;
          } else {
            this.angle = 0;
            return this.y += 1;
          }
          break;
        case 1:
          if (this.y > ship.y) {
            desired_angle = Math.PI - Math.atan((this.x - ship.x) / (this.y - ship.y));
          } else {
            desired_angle = -Math.atan((this.x - ship.x) / (this.y - ship.y));
          }
          if (Math.abs(desired_angle - this.angle) < (Math.PI / 24) || Math.abs(desired_angle - this.angle) > Math.PI * 2 - (Math.PI / 24)) {
            this.angle = desired_angle;
            return this.moveState = 2;
          } else if ((this.angle < desired_angle && this.angle - desired_angle < Math.PI) || (Math.PI * 2 - this.angle) - desired_angle < Math.PI) {
            return this.angle += Math.PI / 24;
          } else {
            return this.angle -= Math.PI / 24;
          }
          break;
        case 2:
          this.x += 30 * Math.cos(this.angle + Math.PI / 2);
          return this.y += 30 * Math.sin(this.angle + Math.PI / 2);
      }
    };
    Kamikaze.prototype.draw = function() {
      ctx.translate(this.x, this.y);
      ctx.rotate(this.angle);
      ctx.beginPath();
      ctx.moveTo(-10, -10);
      ctx.lineTo(10, -10);
      ctx.lineTo(10, 4);
      ctx.lineTo(0, 10);
      ctx.lineTo(-10, 4);
      ctx.closePath();
      ctx.stroke();
      ctx.rotate(-this.angle);
      return ctx.translate(-this.x, -this.y);
    };
    Kamikaze.prototype.alive = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.y > canvas.height || this.moveState && (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height)) {
        return false;
      }
      if (Math.abs(ship.x - this.x) < 30 && Math.abs(ship.y - this.y) < 30) {
        game.owners.player.kills += 1;
        game.owners.player.health -= 35;
        game.timers.dispHealth = 255;
        return false;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= 10 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 10) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return false;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (Math.abs(bomb.x - this.x) < 12 && Math.abs(bomb.y - this.y) < 12) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return false;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (Math.abs(shrapnal.x - this.x) < 11 && Math.abs(shrapnal.y - this.y) < 11) {
          game.owners.player.kills += 1;
          return false;
        }
      }
      return true;
    };
    Kamikaze.prototype.update = function() {
      this.move();
      return this.draw();
    };
    return Kamikaze;
  })();
  Laser = (function() {
    function Laser(x, y, speed, owner) {
      this.x = x;
      this.y = y;
      this.speed = speed;
      this.owner = owner;
      this.killedSomething = false;
    }
    Laser.prototype.draw = function() {
      ctx.fillStyle = this.owner.color;
      return ctx.fillRect(this.x - 1, this.y - 8, 2, 16);
    };
    Laser.prototype.move = function() {
      return this.y += this.speed;
    };
    Laser.prototype.update = function() {
      this.move();
      return this.draw();
    };
    return Laser;
  })();
  Ship = (function() {
    function Ship(x, y) {
      this.x = x;
      this.y = y;
      this.laserCooldown = 0;
      this.bombCooldown = 0;
      this.heat = 0;
    }
    Ship.prototype.move = function() {
      this.x = (this.x + mouse.x) / 2;
      return this.y = (this.y + mouse.y) / 2;
    };
    Ship.prototype.draw = function() {
      ctx.strokeStyle = "#FFFFFF";
      ctx.beginPath();
      ctx.moveTo(this.x, this.y - 20);
      ctx.quadraticCurveTo(this.x + 20, this.y, this.x + 20, this.y + 20);
      ctx.quadraticCurveTo(this.x + 5, this.y + 10, this.x, this.y + 10);
      ctx.quadraticCurveTo(this.x - 5, this.y + 10, this.x - 20, this.y + 20);
      ctx.quadraticCurveTo(this.x - 20, this.y, this.x, this.y - 20);
      ctx.closePath();
      return ctx.stroke();
    };
    Ship.prototype.update = function() {
      this.move();
      return this.draw();
    };
    return Ship;
  })();
  Shrapnal = (function() {
    function Shrapnal(x, y, angle, speed, owner) {
      this.x = x;
      this.y = y;
      this.angle = angle;
      this.speed = speed;
      this.owner = owner;
      this.cooldown = 10;
    }
    Shrapnal.prototype.move = function() {
      this.x += this.speed * Math.cos(this.angle);
      return this.y += this.speed * Math.sin(this.angle);
    };
    Shrapnal.prototype.draw = function() {
      ctx.fillStyle = this.owner.color;
      return ctx.fillRect(this.x - 1, this.y - 1, 2, 2);
    };
    Shrapnal.prototype.update = function() {
      this.cooldown -= 1;
      this.move();
      return this.draw();
    };
    return Shrapnal;
  })();
  setTitleFont = function() {
    ctx.fillStyle = "#FFFFFF";
    ctx.font = "bold 20px Lucidia Console";
    ctx.textAlign = "center";
    return ctx.textBaseline = "middle";
  };
  setLowerLeftFont = function() {
    ctx.fillStyle = "#FFFFFF";
    ctx.font = "normal 18px Lucidia Console";
    ctx.textAlign = "left";
    return ctx.textBaseline = "bottom";
  };
  clearScreen = function() {
    ctx.fillStyle = "#000000";
    return ctx.fillRect(0, 0, canvas.width, canvas.height);
  };
  drawTitleScreen = function() {
    clearScreen();
    setTitleFont();
    ctx.fillText("Tempus [Dev]", canvas.width / 2, canvas.height / 2 - 12);
    ctx.fillText("Click to play", canvas.width / 2, canvas.height / 2 + 12);
    setLowerLeftFont();
    return ctx.fillText("by Jake Stothard", 10, canvas.height - 10);
  };
  drawGameOver = function() {
    clearScreen();
    setTitleFont();
    ctx.fillText("Game Over", canvas.width / 2, canvas.height / 2 - 20);
    ctx.font = "normal 18px Lucidia Console";
    ctx.fillText("Kills - " + game.owners.player.kills, canvas.width / 2, canvas.height / 2);
    ctx.fillText("Lasers Fired - " + game.owners.player.lasers_fired, canvas.width / 2, canvas.height / 2 + 20);
    return ctx.fillText("Bombs Used - " + game.owners.player.bombs_fired, canvas.width / 2, canvas.height / 2 + 40);
  };
  ctx.strokeStyle = "#FFFFFF";
  ctx.lineWidth = 4;
  firstInit = function() {
    if ($("#enableMusic")[0].checked) {
      audio.play();
      musicPlaying = true;
    }
    return firstTime = false;
  };
  initGame = function() {
    if (firstTime) {
      firstInit();
    }
    ship = new Ship(mouse.x, mouse.y);
    return game = {
      owners: {
        player: {
          lasers: [],
          bombs: [],
          shrapnals: [],
          units: ship,
          color: "#0044FF",
          health: 100,
          kills: 0,
          lasers_fired: 0,
          bombs_fired: 0
        },
        enemies: {
          lasers: [],
          bombs: [],
          shrapnals: [],
          units: [],
          color: "#FF0000"
        }
      },
      timers: {
        dispHealth: 0,
        colorCycle: 0,
        colorCycleDir: 10
      },
      crashed: false
    };
  };
  dispHealth = function() {
    ctx.beginPath();
    ctx.arc(canvas.width / 2, canvas.height / 2, Math.min(canvas.width, canvas.height) / 2 - 20, 0, Math.max(game.owners.player.health, 0) * Math.PI / 50, false);
    return ctx.stroke();
  };
  pause = function() {
    currentState = gameState.paused;
    clearInterval(timeHandle);
    dispHealth();
    setTitleFont();
    return ctx.fillText("[Paused]", canvas.width / 2, canvas.height / 2);
  };
  unpause = function() {
    currentState = gameState.playing;
    return timeHandle = every(32, gameloop);
  };
  $(document).keyup(function(e) {
    switch (event.which) {
      case 80:
        switch (currentState) {
          case gameState.paused:
            return unpause();
          case gameState.playing:
            return pause();
        }
    }
  });
  $("#c").mousemove(function(e) {
    mouse.x = e.pageX - this.offsetLeft;
    return mouse.y = e.pageY - this.offsetTop;
  }).mouseout(function(e) {
    if (currentState === gameState.playing) {
      return pause();
    }
  }).mousedown(function(e) {
    switch (e.which) {
      case 1:
        return mouse.leftDown = true;
      case 3:
        return mouse.rightDown = true;
    }
  }).mouseup(function(e) {
    switch (e.which) {
      case 1:
        return mouse.leftDown = false;
      case 3:
        return mouse.rightDown = false;
    }
  }).click(function(e) {
    switch (currentState) {
      case gameState.paused:
        return unpause();
      case gameState.title:
        currentState = gameState.playing;
        initGame();
        return timeHandle = every(32, gameloop);
      case gameState.gameOver:
        currentState = gameState.title;
        return drawTitleScreen();
    }
  }).bind("contextmenu", function(e) {
    return false;
  });
  $("#enableMusic").change(function(e) {
    if (!firstTime) {
      if ($("#enableMusic")[0].checked) {
        audio.play();
        return musicPlaying = true;
      } else {
        audio.pause();
        return musicPlaying = false;
      }
    }
  });
  gameloop = function() {
    var bomb, enemy, laser, owner, ownerName, shrapnal, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _len6, _len7, _m, _n, _o, _ref, _ref10, _ref11, _ref12, _ref13, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
    if (game.crashed) {
      currentState = gameState.crashed;
      clearInterval(timeHandle);
      return;
    }
    game.crashed = true;
    game.timers.colorCycle += game.timers.colorCycleDir;
    game.timers.colorCycle = Math.min(game.timers.colorCycle, 255);
    game.timers.colorCycle = Math.max(game.timers.colorCycle, 0);
    if (game.timers.colorCycle === 0 || game.timers.colorCycle === 255) {
      game.timers.colorCycleDir *= -1;
    }
    if (game.owners.player.health <= 0) {
      currentState = gameState.gameOver;
      clearInterval(timeHandle);
      drawGameOver();
      return;
    }
    clearScreen();
    _ref = game.owners.enemies.units;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      enemy = _ref[_i];
      enemy.update();
    }
    game.owners.enemies.units = (function() {
      var _j, _len2, _ref2, _results;
      _ref2 = game.owners.enemies.units;
      _results = [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        enemy = _ref2[_j];
        if (enemy.alive()) {
          _results.push(enemy);
        }
      }
      return _results;
    })();
    if (Math.random() < 0.03 && game.owners.player.kills >= 0) {
      game.owners.enemies.units.push(new Fighter(randInt(0, canvas.width), -10));
    }
    if (Math.random() < 0.02 && game.owners.player.kills >= 15) {
      game.owners.enemies.units.push(new Kamikaze(randInt(0, canvas.width), -10));
    }
    if (Math.random() < 0.01 && game.owners.player.kills >= 30) {
      game.owners.enemies.units.push(new Bomber(randInt(0, canvas.width), -10));
    }
    ship.update();
    _ref2 = game.owners;
    for (ownerName in _ref2) {
      owner = _ref2[ownerName];
      _ref3 = owner.lasers;
      for (_j = 0, _len2 = _ref3.length; _j < _len2; _j++) {
        laser = _ref3[_j];
        laser.update();
      }
    }
    _ref4 = game.owners.enemies.lasers;
    for (_k = 0, _len3 = _ref4.length; _k < _len3; _k++) {
      laser = _ref4[_k];
      if (Math.abs(ship.x - laser.x) <= 12 && Math.abs(ship.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 10) {
        laser.killedSomething = true;
        game.owners.player.health -= 8;
        game.timers.dispHealth = 255;
      }
    }
    _ref5 = game.owners.enemies.bombs;
    for (_l = 0, _len4 = _ref5.length; _l < _len4; _l++) {
      bomb = _ref5[_l];
      if (Math.abs(ship.x - bomb.x) <= 12 && Math.abs(ship.y - bomb.y + bomb.speed / 2) <= Math.abs(bomb.speed) / 2 + 10) {
        bomb.cooldown = 0;
        game.owners.player.health -= 2;
        game.timers.dispHealth = 255;
      }
    }
    _ref6 = game.owners.enemies.shrapnals;
    for (_m = 0, _len5 = _ref6.length; _m < _len5; _m++) {
      shrapnal = _ref6[_m];
      if (Math.abs(ship.x - shrapnal.x) <= 12 && Math.abs(ship.y - shrapnal.y + shrapnal.speed / 2) <= Math.abs(shrapnal.speed) / 2 + 10) {
        shrapnal.cooldown = 0;
        game.owners.player.health -= 2;
        game.timers.dispHealth = 255;
      }
    }
    _ref7 = game.owners;
    for (ownerName in _ref7) {
      owner = _ref7[ownerName];
      owner.lasers = (function() {
        var _len6, _n, _ref8, _ref9, _results;
        _ref8 = owner.lasers;
        _results = [];
        for (_n = 0, _len6 = _ref8.length; _n < _len6; _n++) {
          laser = _ref8[_n];
          if ((0 < (_ref9 = laser.y) && _ref9 < canvas.height) && !laser.killedSomething) {
            _results.push(laser);
          }
        }
        return _results;
      })();
    }
    _ref8 = game.owners;
    for (ownerName in _ref8) {
      owner = _ref8[ownerName];
      _ref9 = owner.bombs;
      for (_n = 0, _len6 = _ref9.length; _n < _len6; _n++) {
        bomb = _ref9[_n];
        bomb.update();
      }
    }
    _ref10 = game.owners;
    for (ownerName in _ref10) {
      owner = _ref10[ownerName];
      owner.bombs = (function() {
        var _len7, _o, _ref11, _results;
        _ref11 = owner.bombs;
        _results = [];
        for (_o = 0, _len7 = _ref11.length; _o < _len7; _o++) {
          bomb = _ref11[_o];
          if (bomb.cooldown > 0) {
            _results.push(bomb);
          }
        }
        return _results;
      })();
    }
    _ref11 = game.owners;
    for (ownerName in _ref11) {
      owner = _ref11[ownerName];
      _ref12 = owner.shrapnals;
      for (_o = 0, _len7 = _ref12.length; _o < _len7; _o++) {
        shrapnal = _ref12[_o];
        shrapnal.update();
      }
    }
    _ref13 = game.owners;
    for (ownerName in _ref13) {
      owner = _ref13[ownerName];
      owner.shrapnals = (function() {
        var _len8, _p, _ref14, _results;
        _ref14 = owner.shrapnals;
        _results = [];
        for (_p = 0, _len8 = _ref14.length; _p < _len8; _p++) {
          shrapnal = _ref14[_p];
          if (shrapnal.cooldown > 0) {
            _results.push(shrapnal);
          }
        }
        return _results;
      })();
    }
    if (mouse.leftDown && ship.laserCooldown <= 0) {
      game.owners.player.lasers_fired += 1;
      game.owners.player.lasers.push(new Laser(ship.x, ship.y, -20, game.owners.player));
      if (ship.heat > 80) {
        ship.laserCooldown = 7;
      } else if (ship.heat > 40) {
        ship.laserCooldown = 5;
      } else {
        ship.laserCooldown = 2;
      }
      ship.heat += 7;
    }
    if (mouse.rightDown && ship.bombCooldown <= 0) {
      game.owners.player.bombs_fired += 1;
      if (currentState === gameState.playing) {
        game.owners.player.bombs.push(new Bomb(ship.x, ship.y, -12, 20, game.owners.player));
      }
      if (ship.heat > 80) {
        ship.bombCooldown = 20;
      } else if (ship.heat > 40) {
        ship.bombCooldown = 10;
      } else {
        ship.bombCooldown = 5;
      }
      ship.heat += 10;
    }
    if (ship.laserCooldown > 0) {
      ship.laserCooldown -= 1;
    }
    if (ship.bombCooldown > 0) {
      ship.bombCooldown -= 1;
    }
    if (ship.heat > 0) {
      ship.heat -= 1;
    }
    ctx.textAlign = "center";
    ctx.textBaseline = "bottom";
    if (ship.heat > 80) {
      ctx.fillStyle = "rgb(".concat(game.timers.colorCycle, ",0,0)");
      ctx.font = "bold 20px Lucidia Console";
      ctx.fillText("[ Heat Critical ]", canvas.width / 2, canvas.height - 30);
    } else if (ship.heat > 40) {
      ctx.fillStyle = "rgb(".concat(game.timers.colorCycle, ",", game.timers.colorCycle, ",0)");
      ctx.font = "normal 18px Lucidia Console";
      ctx.fillText("[ Heat Warning ]", canvas.width / 2, canvas.height - 30);
    } else {
      ctx.fillStyle = "#00FF00";
    }
    if (game.timers.dispHealth > 0) {
      ctx.strokeStyle = "rgb(".concat(game.timers.dispHealth, ",", game.timers.dispHealth, ",", game.timers.dispHealth, ")");
      dispHealth();
      ctx.strokeStyle = "#FFFFFF";
      game.timers.dispHealth -= 10;
    }
    return game.crashed = false;
  };
  switch (currentState) {
    case gameState.playing:
      initGame();
      timeHandle = every(32, gameloop);
      break;
    case gameState.title:
      drawTitleScreen();
  }
}).call(this);
