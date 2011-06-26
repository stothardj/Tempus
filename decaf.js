(function() {
  var BAD_COLOR, BOMB_SPEED, Bomb, ENEMY_RAND, Enemy, GOOD_COLOR, LASER_LENGTH, LASER_SPEED, Laser, Ship, Shrapnal, bombs, canvas, crashed, ctx, enemies, every, gameloop, lasers, mouseX, mouseY, paused, randInt, ship, shrapnals, timeHandle;
  canvas = document.getElementById("c");
  ctx = canvas.getContext("2d");
  if (!ctx) {
    throw "Loading context failed";
  }
  GOOD_COLOR = "#0044FF";
  BAD_COLOR = "#FF0000";
  LASER_SPEED = 30;
  LASER_LENGTH = 16;
  BOMB_SPEED = 12;
  ENEMY_RAND = 0.05;
  lasers = [];
  enemies = [];
  bombs = [];
  shrapnals = [];
  mouseX = 250;
  mouseY = 200;
  crashed = false;
  paused = false;
  timeHandle = void 0;
  Ship = (function() {
    function Ship(x, y) {
      this.x = x;
      this.y = y;
    }
    Ship.prototype.move = function() {
      ship.x = (ship.x + mouseX) / 2;
      return ship.y = (ship.y + mouseY) / 2;
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
      return lasers.push(new Laser(this.x, this.y, LASER_SPEED, BAD_COLOR));
    };
    Enemy.prototype.alive = function() {
      var laser, _i, _len;
      if (this.y > canvas.height) {
        return false;
      }
      for (_i = 0, _len = lasers.length; _i < _len; _i++) {
        laser = lasers[_i];
        if (laser.color === GOOD_COLOR && Math.abs(this.x - laser.x) <= 7 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + LASER_LENGTH) / 2 + 10) {
          laser.killedSomething = true;
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
      return shrapnals = shrapnals.concat((function() {
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
  randInt = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };
  ctx.fillStyle = "#000000";
  ctx.strokeStyle = "#FFFFFF";
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.lineWidth = 4;
  ship = new Ship(mouseX, mouseY);
  $(document).keyup(function(e) {
    console.log(event.which);
    switch (event.which) {
      case 80:
        if (paused) {
          timeHandle = every(32, gameloop);
        } else {
          clearInterval(timeHandle);
        }
        return paused = !paused;
    }
  });
  $("#c").mousemove(function(e) {
    mouseX = e.pageX - this.offsetLeft;
    return mouseY = e.pageY - this.offsetTop;
  }).click(function(e) {
    return lasers.push(new Laser(ship.x, ship.y, -LASER_SPEED, GOOD_COLOR));
  }).bind("contextmenu", function(e) {
    bombs.push(new Bomb(ship.x, ship.y, -BOMB_SPEED, GOOD_COLOR));
    return false;
  });
  every = function(ms, cb) {
    return setInterval(cb, ms);
  };
  gameloop = function() {
    var bomb, enemy, laser, shrapnal, _i, _j, _k, _l, _len, _len2, _len3, _len4;
    if (crashed) {
      return clearInterval(timeHandle);
    }
    crashed = true;
    ctx.fillStyle = "#000000";
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    for (_i = 0, _len = lasers.length; _i < _len; _i++) {
      laser = lasers[_i];
      laser.update();
    }
    lasers = (function() {
      var _j, _len2, _ref, _results;
      _results = [];
      for (_j = 0, _len2 = lasers.length; _j < _len2; _j++) {
        laser = lasers[_j];
        if ((0 < (_ref = laser.y) && _ref < canvas.height) && !laser.killedSomething) {
          _results.push(laser);
        }
      }
      return _results;
    })();
    for (_j = 0, _len2 = enemies.length; _j < _len2; _j++) {
      enemy = enemies[_j];
      enemy.update();
    }
    enemies = (function() {
      var _k, _len3, _results;
      _results = [];
      for (_k = 0, _len3 = enemies.length; _k < _len3; _k++) {
        enemy = enemies[_k];
        if (enemy.alive()) {
          _results.push(enemy);
        }
      }
      return _results;
    })();
    if (Math.random() < ENEMY_RAND) {
      enemies.push(new Enemy(randInt(0, canvas.width), -10));
    }
    for (_k = 0, _len3 = bombs.length; _k < _len3; _k++) {
      bomb = bombs[_k];
      bomb.update();
    }
    bombs = (function() {
      var _l, _len4, _results;
      _results = [];
      for (_l = 0, _len4 = bombs.length; _l < _len4; _l++) {
        bomb = bombs[_l];
        if (bomb.cooldown !== 0) {
          _results.push(bomb);
        }
      }
      return _results;
    })();
    for (_l = 0, _len4 = shrapnals.length; _l < _len4; _l++) {
      shrapnal = shrapnals[_l];
      shrapnal.update();
    }
    shrapnals = (function() {
      var _len5, _m, _results;
      _results = [];
      for (_m = 0, _len5 = shrapnals.length; _m < _len5; _m++) {
        shrapnal = shrapnals[_m];
        if (shrapnal.cooldown > 0) {
          _results.push(shrapnal);
        }
      }
      return _results;
    })();
    ship.update();
    return crashed = false;
  };
  timeHandle = every(32, gameloop);
}).call(this);
