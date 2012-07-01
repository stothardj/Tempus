(function() {
  var BAD_COLOR, Bomb, Bomber, Box, Fighter, GOOD_COLOR, HealthUp, Kamikaze, Laser, Ship, Shrapnal, Spinner, audio, canvas, clearScreen, ctx, currentState, dispHealth, drawGameOver, drawTitleScreen, every, firstInit, firstTime, game, gameState, gameloop, genship, initGame, mouse, musicPlaying, pause, randInt, setLowerLeftFont, setTitleFont, ship, timeHandle, unpause,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Box = (function() {

    function Box(x, y) {
      this.x = x;
      this.y = y;
    }

    Box.prototype.boxHit = function(other) {
      return Math.abs(other.x - this.x) < (other.width + this.width) / 2 && Math.abs(other.y - this.y) < (other.height + this.height) / 2;
    };

    Box.prototype.offscreen = function() {
      return this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height;
    };

    Box.prototype.drawAsBox = function() {
      return ctx.fillRect(this.x - this.width / 2, this.y - this.height / 2, this.width, this.height);
    };

    return Box;

  })();

  Bomb = (function(_super) {

    __extends(Bomb, _super);

    function Bomb(x, y, speed, cooldown, owner) {
      this.x = x;
      this.y = y;
      this.speed = speed;
      this.cooldown = cooldown;
      this.owner = owner;
    }

    Bomb.prototype.width = 4;

    Bomb.prototype.height = 4;

    Bomb.prototype.speed = 12;

    Bomb.prototype.move = function() {
      return this.y += this.speed;
    };

    Bomb.prototype.explode = function() {
      var ang;
      return this.owner.shrapnals = this.owner.shrapnals.concat((function() {
        var _results;
        _results = [];
        for (ang = 0; ang <= 9; ang++) {
          _results.push(new Shrapnal(this.x, this.y, ang * 36 * Math.PI / 180, Shrapnal.prototype.speed, this.owner));
        }
        return _results;
      }).call(this));
    };

    Bomb.prototype.draw = function() {
      ctx.fillStyle = this.owner.color;
      return this.drawAsBox();
    };

    Bomb.prototype.update = function() {
      this.cooldown -= 1;
      if (this.cooldown <= 0) this.explode();
      this.move();
      return this.draw();
    };

    return Bomb;

  })(Box);

  HealthUp = (function(_super) {

    __extends(HealthUp, _super);

    function HealthUp(x, y) {
      this.x = x;
      this.y = y;
      this.used = 0;
    }

    HealthUp.prototype.rand = 0.2;

    HealthUp.prototype.width = 4;

    HealthUp.prototype.height = 4;

    HealthUp.prototype.speed = 5;

    HealthUp.prototype.move = function() {
      return this.y += this.speed;
    };

    HealthUp.prototype.draw = function() {
      ctx.fillStyle = "#00FF00";
      return this.drawAsBox();
    };

    HealthUp.prototype.detectUse = function() {
      if (this.boxHit(ship)) {
        console.log("Used");
        this.used = 1;
        game.owners.player.health = Math.min(game.owners.player.health + 15, 100);
        game.timers.dispHealth = 255;
      }
      if (this.offscreen()) this.used = 1;
      if (this.offscreen()) {
        console.log("Offscreen");
        console.log(this.x);
        console.log(this.y);
        console.log(canvas.width);
        return console.log(canvas.height);
      }
    };

    HealthUp.prototype.update = function() {
      this.move();
      this.draw();
      return this.detectUse();
    };

    return HealthUp;

  })(Box);

  Ship = (function() {

    function Ship(x, y) {
      this.x = x;
      this.y = y;
      this.laserCooldown = 0;
      this.bombCooldown = 0;
      this.heat = 0;
    }

    Ship.prototype.width = 40;

    Ship.prototype.height = 40;

    Ship.prototype.boxHit = function(other) {
      return Math.abs(other.x - this.x) < (other.width + this.width) / 2 && Math.abs(other.y - this.y) < (other.height + this.height) / 2;
    };

    Ship.prototype.move = function() {
      this.x = (this.x + mouse.x) / 2;
      return this.y = (this.y + mouse.y) / 2;
    };

    Ship.prototype.draw = function() {
      ctx.strokeStyle = "#FFFFFF";
      ctx.beginPath();
      ctx.moveTo(this.x, this.y - this.height / 2);
      ctx.quadraticCurveTo(this.x + this.width / 2, this.y, this.x + this.width / 2, this.y + this.height / 2);
      ctx.quadraticCurveTo(this.x + this.width / 8, this.y + this.height / 4, this.x, this.y + this.height / 4);
      ctx.quadraticCurveTo(this.x - this.width / 8, this.y + this.height / 4, this.x - this.width / 2, this.y + this.height / 2);
      ctx.quadraticCurveTo(this.x - this.width / 2, this.y, this.x, this.y - this.height / 2);
      ctx.closePath();
      return ctx.stroke();
    };

    Ship.prototype.takeDamage = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3, _results;
      _ref = game.owners.enemies.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= this.width / 2 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + this.height / 2) {
          laser.killedSomething = true;
          game.owners.player.health -= 8;
          game.timers.dispHealth = 255;
        }
      }
      _ref2 = game.owners.enemies.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (this.boxHit(bomb)) {
          bomb.cooldown = 0;
          game.owners.player.health -= 2;
          game.timers.dispHealth = 255;
        }
      }
      _ref3 = game.owners.enemies.shrapnals;
      _results = [];
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (this.boxHit(shrapnal)) {
          shrapnal.cooldown = 0;
          game.owners.player.health -= 2;
          _results.push(game.timers.dispHealth = 255);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Ship.prototype.update = function() {
      this.move();
      this.draw();
      return this.takeDamage();
    };

    return Ship;

  })();

  Bomber = (function(_super) {

    __extends(Bomber, _super);

    function Bomber(x, y) {
      this.x = x;
      this.y = y;
      this.angle = 0;
      this.bombCooldown = 0;
      this.turnVel = (Math.random() - 0.5) / 30;
      this.health = 1;
    }

    Bomber.prototype.rand = 0.01;

    Bomber.prototype.threshold = 30;

    Bomber.prototype.width = 10;

    Bomber.prototype.height = 28;

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
      ctx.moveTo(0, this.height / 2);
      ctx.lineTo(this.width / 2, 0);
      ctx.lineTo(0, -this.height / 2);
      ctx.lineTo(-this.width / 2, 0);
      ctx.closePath();
      ctx.stroke();
      ctx.rotate(-this.angle);
      return ctx.translate(-this.x, -this.y);
    };

    Bomber.prototype.bomb = function() {
      this.bombCooldown = 40;
      return game.owners.enemies.bombs.push(new Bomb(this.x, this.y, 4, 35, game.owners.enemies));
    };

    Bomber.prototype.takeDamage = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.offscreen()) {
        if (this.goneOnScreen) return this.health = 0;
      } else {
        this.goneOnScreen = 1;
      }
      if (this.boxHit(ship)) {
        game.owners.player.health -= 24;
        game.owners.player.kills += 1;
        game.timers.dispHealth = 255;
        return this.health = 0;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= this.width / 2 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + this.height / 2) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (this.boxHit(bomb)) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (this.boxHit(shrapnal)) {
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
    };

    Bomber.prototype.update = function() {
      if (this.bombCooldown === 0) this.bomb();
      this.bombCooldown -= 1;
      this.move();
      this.draw();
      return this.takeDamage();
    };

    return Bomber;

  })(Box);

  Kamikaze = (function(_super) {

    __extends(Kamikaze, _super);

    function Kamikaze(x, y) {
      this.x = x;
      this.y = y;
      this.angle = 0;
      this.shootCooldown = 0;
      this.moveState = 0;
      this.health = 1;
    }

    Kamikaze.prototype.rand = 0.02;

    Kamikaze.prototype.threshold = 15;

    Kamikaze.prototype.width = 20;

    Kamikaze.prototype.height = 20;

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
      ctx.moveTo(-this.width / 2, -this.height / 2);
      ctx.lineTo(this.width / 2, -this.height / 2);
      ctx.lineTo(this.width / 2, this.height / 5);
      ctx.lineTo(0, this.height / 2);
      ctx.lineTo(-this.width / 2, this.height / 5);
      ctx.closePath();
      ctx.stroke();
      ctx.rotate(-this.angle);
      return ctx.translate(-this.x, -this.y);
    };

    Kamikaze.prototype.takeDamage = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.y > canvas.height || this.moveState && this.offscreen()) {
        return this.health = 0;
      }
      if (this.boxHit(ship)) {
        game.owners.player.kills += 1;
        game.owners.player.health -= 35;
        game.timers.dispHealth = 255;
        return this.health = 0;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= this.width / 2 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + this.height / 2) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (this.boxHit(bomb)) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (this.boxHit(shrapnal)) {
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
    };

    Kamikaze.prototype.update = function() {
      this.move();
      this.draw();
      return this.takeDamage();
    };

    return Kamikaze;

  })(Box);

  Shrapnal = (function() {

    function Shrapnal(x, y, angle, speed, owner) {
      this.x = x;
      this.y = y;
      this.angle = angle;
      this.speed = speed;
      this.owner = owner;
      this.cooldown = 10;
    }

    Shrapnal.prototype.speed = 10;

    Shrapnal.prototype.width = 2;

    Shrapnal.prototype.height = 2;

    Shrapnal.prototype.drawAsBox = function() {
      return ctx.fillRect(this.x - this.width / 2, this.y - this.height / 2, this.width, this.height);
    };

    Shrapnal.prototype.move = function() {
      this.x += this.speed * Math.cos(this.angle);
      return this.y += this.speed * Math.sin(this.angle);
    };

    Shrapnal.prototype.draw = function() {
      ctx.fillStyle = this.owner.color;
      return this.drawAsBox();
    };

    Shrapnal.prototype.update = function() {
      this.cooldown -= 1;
      this.move();
      return this.draw();
    };

    return Shrapnal;

  })();

  Fighter = (function() {

    function Fighter(x, y) {
      this.x = x;
      this.y = y;
      this.shootCooldown = 0;
      this.health = 1;
    }

    Fighter.prototype.rand = 0.03;

    Fighter.prototype.threshold = 0;

    Fighter.prototype.width = 20;

    Fighter.prototype.height = 20;

    Fighter.prototype.boxHit = function(other) {
      return Math.abs(other.x - this.x) < (other.width + this.width) / 2 && Math.abs(other.y - this.y) < (other.height + this.height) / 2;
    };

    Fighter.prototype.draw = function() {
      ctx.strokeStyle = "#FFFFFF";
      ctx.beginPath();
      ctx.moveTo(this.x - this.width / 2, this.y - this.height / 2);
      ctx.lineTo(this.x + this.width / 2, this.y - this.height / 2);
      ctx.lineTo(this.x, this.y + this.height / 2);
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
      return game.owners.enemies.lasers.push(new Laser(this.x, this.y, Laser.prototype.speed, game.owners.enemies));
    };

    Fighter.prototype.takeDamage = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.y > canvas.height) return this.health = 0;
      if (this.boxHit(ship)) {
        game.owners.player.health -= 24;
        game.owners.player.kills += 1;
        game.timers.dispHealth = 255;
        return this.health = 0;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= this.width / 2 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + this.height / 2) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (this.boxHit(bomb)) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (this.boxHit(shrapnal)) {
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
    };

    Fighter.prototype.update = function() {
      if (this.shootCooldown === 0) this.shoot();
      this.shootCooldown -= 1;
      this.move();
      this.draw();
      return this.takeDamage();
    };

    return Fighter;

  })();

  Laser = (function() {

    function Laser(x, y, speed, owner) {
      this.x = x;
      this.y = y;
      this.speed = speed;
      this.owner = owner;
      this.killedSomething = false;
    }

    Laser.prototype.speed = 20;

    Laser.prototype.width = 2;

    Laser.prototype.height = 16;

    Laser.prototype.drawAsBox = function() {
      return ctx.fillRect(this.x - this.width / 2, this.y - this.height / 2, this.width, this.height);
    };

    Laser.prototype.draw = function() {
      ctx.fillStyle = this.owner.color;
      return this.drawAsBox();
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

  Spinner = (function() {

    function Spinner(x, y) {
      this.x = x;
      this.y = y;
      this.angle = 0;
      this.shootCooldown = 0;
      this.burst = 0;
      this.health = 1;
    }

    Spinner.prototype.rand = 0.005;

    Spinner.prototype.threshold = 45;

    Spinner.prototype.width = 20;

    Spinner.prototype.height = 20;

    Spinner.prototype.boxHit = function(other) {
      return Math.abs(other.x - this.x) < (other.width + this.width) / 2 && Math.abs(other.y - this.y) < (other.height + this.height) / 2;
    };

    Spinner.prototype.draw = function() {
      ctx.translate(this.x, this.y);
      ctx.rotate(this.angle);
      ctx.beginPath();
      ctx.moveTo(-this.width / 2, -this.height / 2);
      ctx.lineTo(this.width / 2, -this.height / 2);
      ctx.lineTo(this.width / 2, this.height / 2);
      ctx.lineTo(-this.width / 2, this.height / 2);
      ctx.closePath();
      ctx.stroke();
      ctx.rotate(-this.angle);
      return ctx.translate(-this.x, -this.y);
    };

    Spinner.prototype.move = function() {
      this.angle += 0.1;
      return this.y += 2;
    };

    Spinner.prototype.shoot = function() {
      if (this.burst < 5) {
        this.burst += 1;
      } else {
        this.shootCooldown = 55;
        this.burst = 0;
      }
      return game.owners.enemies.lasers.push(new Laser(this.x, this.y, Laser.prototype.speed, game.owners.enemies));
    };

    Spinner.prototype.takeDamage = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.y > canvas.height) return this.health = 0;
      if (this.boxHit(ship)) {
        game.owners.player.health -= 24;
        game.owners.player.kills += 1;
        game.timers.dispHealth = 255;
        return this.health = 0;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= this.width / 2 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + laser.height) / 2 + this.height / 2) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (this.boxHit(bomb)) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (this.boxHit(shrapnal)) {
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
    };

    Spinner.prototype.update = function() {
      if (this.shootCooldown <= 0) this.shoot();
      this.shootCooldown -= 1;
      this.move();
      this.draw();
      return this.takeDamage();
    };

    return Spinner;

  })();

  GOOD_COLOR = "#0044FF";

  BAD_COLOR = "#FF0000";

  genship = function(t) {
    if (game.owners.player.kills >= t.prototype.threshold && Math.random() < t.prototype.rand) {
      return game.owners.enemies.units.push(new t(randInt(0, canvas.width), -10));
    }
  };

  canvas = document.getElementById("c");

  ctx = canvas.getContext("2d");

  audio = $('<audio></audio>').attr({
    'loop': 'loop'
  }).append($('<source></source>').attr({
    'src': 'media/tonight_full.ogg'
  }).attr({
    'type': 'audio/ogg'
  })).append($('<source></source>').attr({
    'src': 'media/tonight_full.mp3'
  }).attr({
    'type': 'audio/mpeg'
  })).appendTo('body')[0];

  console.log(audio);

  if (!ctx) throw "Loading context failed";

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
    ctx.fillText("Lasers Fired - " + game.owners.player.lasersFired, canvas.width / 2, canvas.height / 2 + 20);
    return ctx.fillText("Bombs Used - " + game.owners.player.bombsFired, canvas.width / 2, canvas.height / 2 + 40);
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
    if (firstTime) firstInit();
    ship = new Ship(mouse.x, mouse.y);
    return game = {
      owners: {
        player: {
          lasers: [],
          bombs: [],
          shrapnals: [],
          units: ship,
          color: GOOD_COLOR,
          health: 100,
          kills: 0,
          lasersFired: 0,
          bombsFired: 0
        },
        enemies: {
          lasers: [],
          bombs: [],
          shrapnals: [],
          units: [],
          color: BAD_COLOR
        }
      },
      timers: {
        dispHealth: 0,
        colorCycle: 0,
        colorCycleDir: 10
      },
      powerups: {
        healthups: []
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
    switch (e.which) {
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
    if (currentState === gameState.playing) return pause();
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
    var bomb, enemy, laser, owner, ownerName, powerup, powerupType, powerupTypeName, shrapnal, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _m, _ref, _ref2, _ref3, _ref4, _ref5, _ref6;
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
    game.powerups.healthups = game.powerups.healthups.concat((function() {
      var _j, _len2, _ref2, _results;
      _ref2 = game.owners.enemies.units;
      _results = [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        enemy = _ref2[_j];
        if (enemy.health <= 0 && Math.random() < HealthUp.prototype.rand) {
          _results.push(new HealthUp(enemy.x, enemy.y));
        }
      }
      return _results;
    })());
    game.owners.enemies.units = (function() {
      var _j, _len2, _ref2, _results;
      _ref2 = game.owners.enemies.units;
      _results = [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        enemy = _ref2[_j];
        if (enemy.health > 0) _results.push(enemy);
      }
      return _results;
    })();
    genship(Fighter);
    genship(Kamikaze);
    genship(Bomber);
    genship(Spinner);
    ship.update();
    _ref2 = game.owners;
    for (ownerName in _ref2) {
      owner = _ref2[ownerName];
      _ref3 = owner.lasers;
      for (_j = 0, _len2 = _ref3.length; _j < _len2; _j++) {
        laser = _ref3[_j];
        laser.update();
      }
      owner.lasers = (function() {
        var _k, _len3, _ref4, _ref5, _results;
        _ref4 = owner.lasers;
        _results = [];
        for (_k = 0, _len3 = _ref4.length; _k < _len3; _k++) {
          laser = _ref4[_k];
          if ((0 < (_ref5 = laser.y) && _ref5 < canvas.height) && !laser.killedSomething) {
            _results.push(laser);
          }
        }
        return _results;
      })();
      _ref4 = owner.bombs;
      for (_k = 0, _len3 = _ref4.length; _k < _len3; _k++) {
        bomb = _ref4[_k];
        bomb.update();
      }
      owner.bombs = (function() {
        var _l, _len4, _ref5, _results;
        _ref5 = owner.bombs;
        _results = [];
        for (_l = 0, _len4 = _ref5.length; _l < _len4; _l++) {
          bomb = _ref5[_l];
          if (bomb.cooldown > 0) _results.push(bomb);
        }
        return _results;
      })();
      _ref5 = owner.shrapnals;
      for (_l = 0, _len4 = _ref5.length; _l < _len4; _l++) {
        shrapnal = _ref5[_l];
        shrapnal.update();
      }
      owner.shrapnals = (function() {
        var _len5, _m, _ref6, _results;
        _ref6 = owner.shrapnals;
        _results = [];
        for (_m = 0, _len5 = _ref6.length; _m < _len5; _m++) {
          shrapnal = _ref6[_m];
          if (shrapnal.cooldown > 0) _results.push(shrapnal);
        }
        return _results;
      })();
    }
    _ref6 = game.powerups;
    for (powerupTypeName in _ref6) {
      powerupType = _ref6[powerupTypeName];
      for (_m = 0, _len5 = powerupType.length; _m < _len5; _m++) {
        powerup = powerupType[_m];
        powerup.update();
      }
      game.powerups[powerupTypeName] = (function() {
        var _len6, _n, _results;
        _results = [];
        for (_n = 0, _len6 = powerupType.length; _n < _len6; _n++) {
          powerup = powerupType[_n];
          if (!powerup.used) _results.push(powerup);
        }
        return _results;
      })();
    }
    if (mouse.leftDown && ship.laserCooldown <= 0) {
      game.owners.player.lasersFired += 1;
      game.owners.player.lasers.push(new Laser(ship.x, ship.y, -Laser.prototype.speed, game.owners.player));
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
      game.owners.player.bombsFired += 1;
      if (currentState === gameState.playing) {
        game.owners.player.bombs.push(new Bomb(ship.x, ship.y, -Bomb.prototype.speed, 20, game.owners.player));
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
    if (ship.laserCooldown > 0) ship.laserCooldown -= 1;
    if (ship.bombCooldown > 0) ship.bombCooldown -= 1;
    if (ship.heat > 0) ship.heat -= 1;
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
