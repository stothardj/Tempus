(function() {
  var Bomb, Bomber, Fighter, HealthUp, Kamikaze, Laser, Ship, Shrapnal, Spinner, audio, canvas, clearScreen, ctx, currentState, dispHealth, drawGameOver, drawTitleScreen, every, firstInit, firstTime, game, gameState, gameloop, initGame, mouse, musicPlaying, pause, randInt, setLowerLeftFont, setTitleFont, ship, timeHandle, unpause;
  canvas = document.getElementById("c");
  ctx = canvas.getContext("2d");
  audio = $('<audio></audio>').attr({
    'loop': 'loop'
  }).append($('<source><source>').attr({
    'src': 'media/tonight_full.ogg'
  })).append($('<source><source>').attr({
    'src': 'media/tonight_full.mp3'
  })).appendTo('body')[0];
  console.log(audio);
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
      this.health = 1;
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
    Bomber.prototype.takeDamage = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height) {
        if (this.goneOnScreen) {
          return this.health = 0;
        }
      } else {
        this.goneOnScreen = 1;
      }
      if (Math.abs(ship.x - this.x) < 25 && Math.abs(ship.y - this.y) < 34) {
        game.owners.player.health -= 24;
        game.owners.player.kills += 1;
        game.timers.dispHealth = 255;
        return this.health = 0;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= 5 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 14) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (Math.abs(bomb.x - this.x) < 7 && Math.abs(bomb.y - this.y) < 16) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (Math.abs(shrapnal.x - this.x) < 6 && Math.abs(shrapnal.y - this.y) < 15) {
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
    };
    Bomber.prototype.update = function() {
      if (this.bombCooldown === 0) {
        this.bomb();
      }
      this.bombCooldown -= 1;
      this.move();
      this.draw();
      return this.takeDamage();
    };
    return Bomber;
  })();
  Fighter = (function() {
    function Fighter(x, y) {
      this.x = x;
      this.y = y;
      this.shootCooldown = 0;
      this.health = 1;
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
    Fighter.prototype.takeDamage = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.y > canvas.height) {
        return this.health = 0;
      }
      if (Math.abs(ship.x - this.x) < 30 && Math.abs(ship.y - this.y) < 30) {
        game.owners.player.health -= 24;
        game.owners.player.kills += 1;
        game.timers.dispHealth = 255;
        return this.health = 0;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= 10 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 10) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (Math.abs(bomb.x - this.x) < 12 && Math.abs(bomb.y - this.y) < 12) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (Math.abs(shrapnal.x - this.x) < 11 && Math.abs(shrapnal.y - this.y) < 11) {
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
    };
    Fighter.prototype.update = function() {
      if (this.shootCooldown === 0) {
        this.shoot();
      }
      this.shootCooldown -= 1;
      this.move();
      this.draw();
      return this.takeDamage();
    };
    return Fighter;
  })();
  HealthUp = (function() {
    function HealthUp(x, y) {
      this.x = x;
      this.y = y;
      this.used = 0;
    }
    HealthUp.prototype.move = function() {
      return this.y += 5;
    };
    HealthUp.prototype.draw = function() {
      ctx.fillStyle = "#00FF00";
      return ctx.fillRect(this.x - 2, this.y - 2, 4, 4);
    };
    HealthUp.prototype.detectUse = function() {
      if (Math.abs(ship.x - this.x) < 22 && Math.abs(ship.y - this.y) < 22) {
        this.used = 1;
        game.owners.player.health = Math.min(game.owners.player.health + 15, 100);
        game.timers.dispHealth = 255;
      }
      if (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height) {
        return this.used = 1;
      }
    };
    HealthUp.prototype.update = function() {
      this.move();
      this.draw();
      return this.detectUse();
    };
    return HealthUp;
  })();
  Kamikaze = (function() {
    function Kamikaze(x, y) {
      this.x = x;
      this.y = y;
      this.angle = 0;
      this.shootCooldown = 0;
      this.moveState = 0;
      this.health = 1;
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
    Kamikaze.prototype.takeDamage = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.y > canvas.height || this.moveState && (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height)) {
        return this.health = 0;
      }
      if (Math.abs(ship.x - this.x) < 30 && Math.abs(ship.y - this.y) < 30) {
        game.owners.player.kills += 1;
        game.owners.player.health -= 35;
        game.timers.dispHealth = 255;
        return this.health = 0;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= 10 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 10) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (Math.abs(bomb.x - this.x) < 12 && Math.abs(bomb.y - this.y) < 12) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (Math.abs(shrapnal.x - this.x) < 11 && Math.abs(shrapnal.y - this.y) < 11) {
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
    Ship.prototype.takeDamage = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3, _results;
      _ref = game.owners.enemies.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= 20 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 20) {
          laser.killedSomething = true;
          game.owners.player.health -= 8;
          game.timers.dispHealth = 255;
        }
      }
      _ref2 = game.owners.enemies.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (Math.abs(bomb.x - this.x) < 22 && Math.abs(bomb.y - this.y) < 22) {
          bomb.cooldown = 0;
          game.owners.player.health -= 2;
          game.timers.dispHealth = 255;
        }
      }
      _ref3 = game.owners.enemies.shrapnals;
      _results = [];
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        _results.push(Math.abs(shrapnal.x - this.x) < 21 && Math.abs(shrapnal.y - this.y) < 21 ? (shrapnal.cooldown = 0, game.owners.player.health -= 2, game.timers.dispHealth = 255) : void 0);
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
  Spinner = (function() {
    function Spinner(x, y) {
      this.x = x;
      this.y = y;
      this.angle = 0;
      this.shootCooldown = 0;
      this.burst = 0;
      this.health = 1;
    }
    Spinner.prototype.draw = function() {
      ctx.translate(this.x, this.y);
      ctx.rotate(this.angle);
      ctx.beginPath();
      ctx.moveTo(-10, -10);
      ctx.lineTo(10, -10);
      ctx.lineTo(10, 10);
      ctx.lineTo(-10, 10);
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
      return game.owners.enemies.lasers.push(new Laser(this.x, this.y, 20, game.owners.enemies));
    };
    Spinner.prototype.takeDamage = function() {
      var bomb, laser, shrapnal, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      if (this.y > canvas.height) {
        return this.health = 0;
      }
      if (Math.abs(ship.x - this.x) < 30 && Math.abs(ship.y - this.y) < 30) {
        game.owners.player.health -= 24;
        game.owners.player.kills += 1;
        game.timers.dispHealth = 255;
        return this.health = 0;
      }
      _ref = game.owners.player.lasers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        laser = _ref[_i];
        if (Math.abs(this.x - laser.x) <= 10 && Math.abs(this.y - laser.y + laser.speed / 2) <= (Math.abs(laser.speed) + 16) / 2 + 10) {
          laser.killedSomething = true;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref2 = game.owners.player.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (Math.abs(bomb.x - this.x) < 12 && Math.abs(bomb.y - this.y) < 12) {
          bomb.cooldown = 0;
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
      _ref3 = game.owners.player.shrapnals;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        shrapnal = _ref3[_k];
        if (Math.abs(shrapnal.x - this.x) < 11 && Math.abs(shrapnal.y - this.y) < 11) {
          game.owners.player.kills += 1;
          return this.health = 0;
        }
      }
    };
    Spinner.prototype.update = function() {
      if (this.shootCooldown <= 0) {
        this.shoot();
      }
      this.shootCooldown -= 1;
      this.move();
      this.draw();
      return this.takeDamage();
    };
    return Spinner;
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
          lasersFired: 0,
          bombsFired: 0
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
        if (enemy.health <= 0 && Math.random() < 0.2) {
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
        if (enemy.health > 0) {
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
    if (Math.random() < 0.005 && game.owners.player.kills >= 45) {
      game.owners.enemies.units.push(new Spinner(randInt(0, canvas.width), -10));
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
          if (bomb.cooldown > 0) {
            _results.push(bomb);
          }
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
          if (shrapnal.cooldown > 0) {
            _results.push(shrapnal);
          }
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
          if (!powerup.used) {
            _results.push(powerup);
          }
        }
        return _results;
      })();
    }
    if (mouse.leftDown && ship.laserCooldown <= 0) {
      game.owners.player.lasersFired += 1;
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
      game.owners.player.bombsFired += 1;
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
