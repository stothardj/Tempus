(function() {
  var BAD_COLOR, BOMB_SPEED, Bomb, ENEMY_RAND, Enemy, GOOD_COLOR, Kamikaze, LASER_LENGTH, LASER_SPEED, Laser, Ship, Shrapnal, canvas, clearScreen, ctx, currentState, drawGameOver, drawTitleScreen, every, game, gameState, gameloop, initGame, mouseX, mouseY, randInt, setLowerLeftFont, setTitleFont, ship, timeHandle;
  canvas = document.getElementById("c");
  ctx = canvas.getContext("2d");
  if (!ctx) {
    throw "Loading context failed";
  }
  randInt = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };
  every = function(ms, cb) {
    return setInterval(cb, ms);
  };
  GOOD_COLOR = "#0044FF";
  BAD_COLOR = "#FF0000";
  LASER_SPEED = 20;
  LASER_LENGTH = 16;
  BOMB_SPEED = 12;
  ENEMY_RAND = 0.05;
  game = {};
  mouseX = 250;
  mouseY = 200;
  timeHandle = void 0;
  initGame = function() {
    return game = {
      lasers: [],
      enemies: [],
      bombs: [],
      shrapnals: [],
      crashed: false,
      health: 100
    };
  };
  gameState = {
    title: "Title",
    gameover: "GameOver",
    playing: "Playing",
    paused: "Paused",
    crashed: "Crashed"
  };
  currentState = gameState.title;
  Ship = (function() {
    function Ship(x, y) {
      this.x = x;
      this.y = y;
    }
    Ship.prototype.move = function() {
      this.x = (this.x + mouseX) / 2;
      return this.y = (this.y + mouseY) / 2;
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
  Enemy = (function() {
    function Enemy(x, y) {
      this.x = x;
      this.y = y;
      this.shootCooldown = 0;
    }
    Enemy.prototype.draw = function() {
      ctx.strokeStyle = "#FFFFFF";
      ctx.beginPath();
      ctx.moveTo(this.x - 10, this.y - 10);
      ctx.lineTo(this.x + 10, this.y - 10);
      ctx.lineTo(this.x, this.y + 10);
      ctx.closePath();
      return ctx.stroke();
    };
    Enemy.prototype.move = function() {
      var mv;
      this.y += 3;
      mv = (ship.x - this.x) / 12;
      return this.x += Math.abs(mv) < 5 ? mv : 5 * mv / Math.abs(mv);
    };
    Enemy.prototype.shoot = function() {
      this.shootCooldown = 35;
      return game.lasers.push(new Laser(this.x, this.y, LASER_SPEED, BAD_COLOR));
    };
    Enemy.prototype.alive = function() {
      var bomb, laser, shrap, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.y > canvas.height) {
        return false;
      }
      if (Math.abs(ship.x - this.x) < 35 && Math.abs(ship.y - this.y) < 35) {
        game.health -= 24;
        return false;
      }
      _ref = game.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (laser.color !== BAD_COLOR && Math.abs(this.x - laser.x) <= 12 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10) {
          laser.killedSomething = true;
          return false;
        }
      }
      _ref2 = game.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (bomb.color !== BAD_COLOR && Math.abs(this.x - bomb.x) <= 12 && Math.abs(this.y - bomb.y + bomb.speed / 2) <= Math.abs(bomb.speed) / 2 + 12) {
          bomb.cooldown = 0;
          return false;
        }
      }
      _ref3 = game.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrap = _ref3[_k];
        if (shrap.color !== BAD_COLOR && Math.abs(this.x - shrap.x) <= 11 && Math.abs(this.y - shrap.y) <= 11) {
          return false;
        }
      }
      return true;
    };
    Enemy.prototype.update = function() {
      if (this.shootCooldown === 0) {
        this.shoot();
      }
      this.shootCooldown -= 1;
      this.move();
      return this.draw();
    };
    return Enemy;
  })();
  Kamikaze = (function() {
    function Kamikaze(x, y) {
      this.x = x;
      this.y = y;
      this.angle = 0;
      this.shootCooldown = 0;
    }
    Kamikaze.prototype.move = function() {
      if (Math.abs(this.x - ship.x) < 150 && Math.abs(this.y - ship.y) < 150) {
        if (this.y > ship.y) {
          this.angle = Math.PI - Math.atan((this.x - ship.x) / (this.y - ship.y));
        } else {
          this.angle = -Math.atan((this.x - ship.x) / (this.y - ship.y));
        }
        this.x += (ship.x - this.x) / 4;
        return this.y += (ship.y - this.y) / 4;
      } else {
        this.angle = 0;
        return this.y += 1;
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
    Kamikaze.prototype.update = function() {
      this.move();
      return this.draw();
    };
    return Kamikaze;
  })();
  Laser = (function() {
    function Laser(x, y, speed, color) {
      this.x = x;
      this.y = y;
      this.speed = speed;
      this.color = color;
      this.killedSomething = false;
    }
    Laser.prototype.draw = function() {
      ctx.fillStyle = this.color;
      return ctx.fillRect(this.x - 1, this.y - LASER_LENGTH / 2, 2, LASER_LENGTH);
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
  Shrapnal = (function() {
    function Shrapnal(x, y, angle, speed, color) {
      this.x = x;
      this.y = y;
      this.angle = angle;
      this.speed = speed;
      this.color = color;
      this.cooldown = 10;
    }
    Shrapnal.prototype.move = function() {
      this.x += this.speed * Math.cos(this.angle);
      return this.y += this.speed * Math.sin(this.angle);
    };
    Shrapnal.prototype.draw = function() {
      ctx.fillStyle = this.color;
      return ctx.fillRect(this.x - 1, this.y - 1, 2, 2);
    };
    Shrapnal.prototype.update = function() {
      this.cooldown -= 1;
      this.move();
      return this.draw();
    };
    return Shrapnal;
  })();
  Bomb = (function() {
    function Bomb(x, y, speed, color) {
      this.x = x;
      this.y = y;
      this.speed = speed;
      this.color = color;
      this.cooldown = 20;
    }
    Bomb.prototype.move = function() {
      return this.y += this.speed;
    };
    Bomb.prototype.explode = function() {
      var ang;
      return game.shrapnals = game.shrapnals.concat((function() {
        var _results;
        _results = [];
        for (ang = 0; ang <= 9; ang++) {
          _results.push(new Shrapnal(this.x, this.y, ang * 36 * Math.PI / 180, this.speed, this.color));
        }
        return _results;
      }).call(this));
    };
    Bomb.prototype.draw = function() {
      ctx.fillStyle = this.color;
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
    return ctx.fillText("Game Over", canvas.width / 2, canvas.height / 2);
  };
  ctx.fillStyle = "#000000";
  ctx.strokeStyle = "#FFFFFF";
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.lineWidth = 4;
  ship = new Ship(mouseX, mouseY);
  $(document).keyup(function(e) {
    switch (event.which) {
      case 80:
        switch (currentState) {
          case gameState.paused:
            currentState = gameState.playing;
            return timeHandle = every(32, gameloop);
          case gameState.playing:
            currentState = gameState.paused;
            clearInterval(timeHandle);
            setTitleFont();
            return ctx.fillText("[Paused]", canvas.width / 2, canvas.height / 2);
        }
    }
  });
  $("#c").mousemove(function(e) {
    mouseX = e.pageX - this.offsetLeft;
    return mouseY = e.pageY - this.offsetTop;
  }).click(function(e) {
    switch (currentState) {
      case gameState.playing:
        return game.lasers.push(new Laser(ship.x, ship.y, -LASER_SPEED, GOOD_COLOR));
      case gameState.title:
        currentState = gameState.playing;
        initGame();
        return timeHandle = every(32, gameloop);
      case gameState.gameOver:
        currentState = gameState.title;
        return drawTitleScreen();
    }
  }).bind("contextmenu", function(e) {
    if (currentState === gameState.playing) {
      game.bombs.push(new Bomb(ship.x, ship.y, -BOMB_SPEED, GOOD_COLOR));
    }
    return false;
  });
  gameloop = function() {
    var bomb, enemy, laser, shrapnal, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _m, _ref, _ref2, _ref3, _ref4, _ref5;
    if (game.crashed) {
      currentState = gameState.crashed;
      clearInterval(timeHandle);
      return;
    }
    game.crashed = true;
    if (game.health <= 0) {
      currentState = gameState.gameOver;
      clearInterval(timeHandle);
      drawGameOver();
      return;
    }
    clearScreen();
    _ref = game.enemies;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      enemy = _ref[_i];
      enemy.update();
    }
    game.enemies = (function() {
      var _j, _len2, _ref2, _results;
      _ref2 = game.enemies;
      _results = [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        enemy = _ref2[_j];
        if (enemy.alive()) {
          _results.push(enemy);
        }
      }
      return _results;
    })();
    if (Math.random() < ENEMY_RAND) {
      game.enemies.push(new Enemy(randInt(0, canvas.width), -10));
    }
    ship.update();
    _ref2 = game.lasers;
    for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
      laser = _ref2[_j];
      laser.update();
    }
    _ref3 = game.lasers;
    for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
      laser = _ref3[_k];
      if (laser.color !== GOOD_COLOR && Math.abs(ship.x - laser.x) <= 12 && Math.abs(ship.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10) {
        laser.killedSomething = true;
        game.health -= 8;
      }
    }
    game.lasers = (function() {
      var _l, _len4, _ref4, _ref5, _results;
      _ref4 = game.lasers;
      _results = [];
      for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
        laser = _ref4[_l];
        if ((0 < (_ref5 = laser.y) && _ref5 < canvas.height) && !laser.killedSomething) {
          _results.push(laser);
        }
      }
      return _results;
    })();
    _ref4 = game.bombs;
    for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
      bomb = _ref4[_l];
      bomb.update();
    }
    game.bombs = (function() {
      var _len5, _m, _ref5, _results;
      _ref5 = game.bombs;
      _results = [];
      for (_m = 0, _len5 = _ref5.length; _m < _len5; _m++) {
        bomb = _ref5[_m];
        if (bomb.cooldown > 0) {
          _results.push(bomb);
        }
      }
      return _results;
    })();
    _ref5 = game.shrapnals;
    for (_m = 0, _len5 = _ref5.length; _m < _len5; _m++) {
      shrapnal = _ref5[_m];
      shrapnal.update();
    }
    game.shrapnals = (function() {
      var _len6, _n, _ref6, _results;
      _ref6 = game.shrapnals;
      _results = [];
      for (_n = 0, _len6 = _ref6.length; _n < _len6; _n++) {
        shrapnal = _ref6[_n];
        if (shrapnal.cooldown > 0) {
          _results.push(shrapnal);
        }
      }
      return _results;
    })();
    setLowerLeftFont();
    ctx.fillText("Health: " + game.health, 10, canvas.height - 10);
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
