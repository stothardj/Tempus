((function(){var a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,_,ba,bb,bc,bd,be,bf,bg,bh,bi,bj={}.hasOwnProperty,bk=function(a,b){function d(){this.constructor=a}for(var c in b)bj.call(b,c)&&(a[c]=b[c]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};b=function(){function a(a){this.framecount=a,this.frame=0}return a.prototype.nextFrame=function(){return this.frame+=1},a.prototype.finished=function(){return this.frame>=this.framecount},a.prototype.drawFrame=function(){},a}(),G=function(){function a(a,b,c,d,e){this.x=a,this.y=b,this.angle=c,this.speed=d,this.owner=e,this.cooldown=10}return a.prototype.speed=10,a.prototype.width=2,a.prototype.height=2,a.prototype.drawAsBox=function(){return P.fillRect(this.x-this.width/2,this.y-this.height/2,this.width,this.height)},a.prototype.move=function(){return this.x+=this.speed*Math.cos(this.angle),this.y+=this.speed*Math.sin(this.angle)},a.prototype.draw=function(){return this.drawAsBox()},a.prototype.update=function(){return this.cooldown-=1,this.move()},a}(),s=function(a){function b(a,c,d){this.x=a,this.y=c,this.angle=d,b.__super__.constructor.call(this,5),this.halfWidth=this.width>>1,this.halfHeight=this.height>>1,this.fifthHeight=this.height/5|0}return bk(b,a),b.prototype.width=20,b.prototype.height=20,b.prototype.drawFrame=function(){var a;return P.strokeStyle="rgba(255,0,0,".concat(1-this.frame/this.framecount,")"),a=this.frame*2,P.translate(this.x,this.y),P.rotate(this.angle),P.beginPath(),P.moveTo(-this.halfWidth-a,-this.halfHeight-a),P.lineTo(this.halfWidth+a,-this.halfHeight-a),P.lineTo(this.halfWidth+a,this.fifthHeight+a),P.lineTo(0,this.halfHeight+a),P.lineTo(-this.halfWidth-a,this.fifthHeight+a),P.closePath(),P.stroke(),P.rotate(-this.angle),P.translate(-this.x,-this.y)},b}(b),g=function(){function a(a,b){this.x=a,this.y=b}return a.prototype.boxHit=function(a){return Math.abs(a.x-this.x)<a.width+this.width>>1&&Math.abs(a.y-this.y)<a.height+this.height>>1},a.prototype.offscreen=function(){return this.x<0||this.x>O.width||this.y<0||this.y>O.height},a.prototype.drawAsBox=function(){return P.fillRect(this.x-(this.width>>1),this.y-(this.height>>1),this.width,this.height)},a}(),f=function(a){function b(a,c,d){this.x=a,this.y=c,this.angle=d,b.__super__.constructor.call(this,5),this.halfWidth=this.width>>1,this.halfHeight=this.height>>1}return bk(b,a),b.prototype.width=10,b.prototype.height=28,b.prototype.drawFrame=function(){var a;return P.strokeStyle="rgba(255,0,0,".concat(1-this.frame/this.framecount,")"),a=this.frame*2,P.translate(this.x,this.y),P.rotate(this.angle),P.beginPath(),P.moveTo(0,this.halfHeight+a),P.lineTo(this.halfWidth+a,0),P.lineTo(0,-this.halfHeight-a),P.lineTo(-this.halfWidth-a,0),P.closePath(),P.stroke(),P.rotate(-this.angle),P.translate(-this.x,-this.y)},b}(b),u=function(){function a(a,b,c,d){this.x=a,this.y=b,this.speed=c,this.owner=d,this.hitSomething=!1,this.halfHeight=this.height>>1}return a.prototype.speed=20,a.prototype.height=16,a.prototype.width=6,a.prototype.draw=function(){return P.beginPath(),P.moveTo(this.x,this.y-this.halfHeight),P.lineTo(this.x,this.y+this.halfHeight),P.closePath(),P.stroke()},a.prototype.move=function(){return this.y+=this.speed},a.prototype.update=function(){return this.move()},a}(),l=function(a){function c(a,b){this.x=a,this.y=b,this.removed=!1,this.locked=!1,this.scoreValue=0}return bk(c,a),c.prototype.getAnimation=function(){return new b(0)},c.prototype.takeDamage=function(){var a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p;if(this.boxHit(be))return be.damage(this.impactDamage),V.owners.player.kills+=1,this.health=0;m=V.owners.player.lasers;for(e=0,i=m.length;e<i;e++){c=m[e];if(Math.abs(this.x-c.x)<=this.width/2+u.prototype.width/2&&Math.abs(this.y-c.y+c.speed/2)<=(Math.abs(c.speed)+c.height)/2+this.height/2)return c.hitSomething=!0,V.owners.player.kills+=1,this.health=0}n=V.owners.player.bombs;for(f=0,j=n.length;f<j;f++){a=n[f];if(this.boxHit(a))return a.cooldown=0,V.owners.player.kills+=1,this.health=0}o=V.owners.player.shrapnels;for(g=0,k=o.length;g<k;g++){d=o[g];if(this.boxHit(d))return V.owners.player.kills+=1,this.health=0}p=V.owners.player.darts;for(h=0,l=p.length;h<l;h++){b=p[h];if(this.boxHit(b))return V.owners.player.kills+=1,b.target.locked=!1,b.removed=!0,this.health=0}},c.prototype.update=function(){},c.prototype.draw=function(){},c}(g),o="#0044FF",c="#FF0000",k="#FFFFFF",y="#FFFFFF",J="#FFFF00",A=100,B=4e3,z=80,C=40,w=3,t=2,D=1,a=!1,V=void 0,be=void 0,U=!0,ba=!1,_={x:250,y:200,leftDown:!1,rightDown:!1,beginLeftHold:void 0},bg=void 0,L=void 0,bh=void 0,W={title:"Title",gameover:"GameOver",playing:"Playing",paused:"Paused",crashed:"Crashed"},Q=void 0,M=void 0,x=function(a){function b(a,b){this.x=a,this.y=b,this.used=0}return bk(b,a),b.prototype.move=function(){return this.y+=this.speed},b.prototype.draw=function(){return P.fillStyle=this.color,this.drawAsBox()},b.prototype.detectUse=function(){this.boxHit(be)&&(this.used=1,this.use());if(this.offscreen())return this.used=1},b.prototype.update=function(){return this.move(),this.draw(),this.detectUse()},b}(g),r=function(a){function b(a,c){this.x=a,this.y=c,b.__super__.constructor.call(this,this.x,this.y),this.angle=0,this.moveState=0,this.health=1,this.halfWidth=this.width>>1,this.halfHeight=this.height>>1,this.fifthHeight=this.height/5|0,this.scoreValue=2}return bk(b,a),b.prototype.rand=.015,b.prototype.threshold=15,b.prototype.width=20,b.prototype.height=20,b.prototype.impactDamage=35,b.prototype.turnSpeed=Math.PI/24,b.prototype.move=function(){var a;switch(this.moveState){case 0:return Math.abs(this.x-be.x)<150&&Math.abs(this.y-be.y)<150?this.moveState=1:(this.angle=0,this.y+=1);case 1:return this.y>be.y?a=Math.PI-Math.atan((this.x-be.x)/(this.y-be.y)):a=-Math.atan((this.x-be.x)/(this.y-be.y)),Math.abs(a-this.angle)<this.turnSpeed||Math.abs(a-this.angle)>Math.PI*2-this.turnSpeed?(this.angle=a,this.moveState=2):this.angle<a&&this.angle-a<Math.PI||Math.PI*2-this.angle-a<Math.PI?this.angle+=this.turnSpeed:this.angle-=this.turnSpeed;case 2:return this.x+=30*Math.cos(this.angle+Y),this.y+=30*Math.sin(this.angle+Y)}},b.prototype.draw=function(){return P.translate(this.x,this.y),P.rotate(this.angle),P.beginPath(),P.moveTo(-this.halfWidth,-this.halfHeight),P.lineTo(this.halfWidth,-this.halfHeight),P.lineTo(this.halfWidth,this.fifthHeight),P.lineTo(0,this.halfHeight),P.lineTo(-this.halfWidth,this.fifthHeight),P.closePath(),P.stroke(),P.rotate(-this.angle),P.translate(-this.x,-this.y)},b.prototype.removeOffScreen=function(){return this.y>O.height||this.moveState>0&&this.offscreen()?(this.removed=!0,!0):!1},b.prototype.update=function(){this.move();if(!this.removeOffScreen())return this.takeDamage()},b.prototype.getAnimation=function(){return new s(this.x,this.y,this.angle)},b}(l),j=function(){function a(){this.canvas=document.getElementById("c"),this.ctx=this.canvas.getContext("2d")}return a.prototype.setTitleFont=function(){return this.ctx.fillStyle="#FFFFFF",this.ctx.font="bold 20px Helvetica",this.ctx.textAlign="center",this.ctx.textBaseline="middle"},a.prototype.setLowerLeftFont=function(){return this.ctx.fillStyle="#FFFFFF",this.ctx.font="normal 18px Helvetica",this.ctx.textAlign="left",this.ctx.textBaseline="bottom"},a.prototype.clearScreen=function(){return this.ctx.fillStyle="#000000",this.ctx.fillRect(0,0,this.canvas.width,this.canvas.height)},a.prototype.drawTitleScreen=function(){return this.clearScreen(),this.setTitleFont(),this.ctx.fillText("Tempus",this.canvas.width>>1,(this.canvas.height>>1)-12),this.ctx.fillText("Click to play",this.canvas.width>>1,(this.canvas.height>>1)+12),this.setLowerLeftFont(),this.ctx.fillText("by Jake Stothard",10,this.canvas.height-10)},a.prototype.drawGameOver=function(){return this.clearScreen(),this.setTitleFont(),this.ctx.fillText("Game Over",this.canvas.width>>1,(this.canvas.height>>1)-20),this.ctx.font="normal 18px Helvetica",this.ctx.fillText("Score - "+V.owners.player.score,this.canvas.width>>1,this.canvas.height>>1),this.ctx.fillText("Kills - "+V.owners.player.kills,this.canvas.width>>1,(this.canvas.height>>1)+20),this.ctx.fillText("Lasers Fired - "+V.owners.player.lasersFired,this.canvas.width>>1,(this.canvas.height>>1)+40),this.ctx.fillText("Bombs Used - "+V.owners.player.bombsFired,this.canvas.width>>1,(this.canvas.height>>1)+60),this.ctx.fillText("Darts Used - "+V.owners.player.dartsFired,this.canvas.width>>1,(this.canvas.height>>1)+80)},a.prototype.drawHealth=function(){return Q===W.paused?this.ctx.strokeStyle="#00FF00":this.ctx.strokeStyle="rgba(0,255,0,".concat(V.timers.dispHealth/255,")"),this.ctx.beginPath(),this.ctx.arc(this.canvas.width>>1,this.canvas.height>>1,(Math.min(this.canvas.width,this.canvas.height)>>1)-20,0,Math.max(be.health,0)*Math.PI*2/A,!1),this.ctx.stroke(),Q===W.paused?this.ctx.strokeStyle="rgb(0,127,255)":this.ctx.strokeStyle="rgba(0,127,255,".concat(V.timers.dispHealth/255,")"),this.ctx.beginPath(),this.ctx.arc(this.canvas.width>>1,this.canvas.height>>1,(Math.min(this.canvas.width,this.canvas.height)>>1)-40,0,Math.max(be.shield,0)*Math.PI*2/B,!1),this.ctx.stroke()},a.prototype.drawLives=function(){var a,b,c,d;if(V.owners.player.lives<1)return;Q===W.paused?this.ctx.fillStyle="#FFFFFF":this.ctx.fillStyle="rgba(255,255,255,".concat(V.timers.dispLives/255,")"),d=[];for(a=b=1,c=V.owners.player.lives;1<=c?b<=c:b>=c;a=1<=c?++b:--b)this.ctx.beginPath(),this.ctx.arc(11*a,this.canvas.height-11,5,0,Math.PI*2,!1),this.ctx.closePath(),d.push(this.ctx.fill());return d},a.prototype.drawTarget=function(a,b){return this.ctx.strokeRect(a-10,b-10,20,20),this.ctx.beginPath(),this.ctx.moveTo(a-14,b),this.ctx.lineTo(a-6,b),this.ctx.moveTo(a+6,b),this.ctx.lineTo(a+14,b),this.ctx.moveTo(a,b-14),this.ctx.lineTo(a,b-6),this.ctx.moveTo(a,b+6),this.ctx.lineTo(a,b+14),this.ctx.stroke()},a}(),i=function(){function b(){}var a;return a=void 0,b.get=function(){return a!=null?a:a=new j},b}(),N=function(a,b,c){return b<a&&a<c||b>a&&a>c},F=function(a){function b(a,b){this.x=a,this.y=b,this.reset(this.x,this.y),this.halfWidth=this.width>>1,this.eighthWidth=this.width>>3,this.halfHeight=this.height>>1,this.fourthHeight=this.height>>2}return bk(b,a),b.prototype.reset=function(a,b){return this.x=a,this.y=b,this.laserCooldown=0,this.bombCooldown=0,this.heat=0,this.laserPower=1,this.health=A,this.shield=0,this.lockOn=!1},b.prototype.width=40,b.prototype.height=40,b.prototype.move=function(){return this.x=this.x+_.x>>1,this.y=this.y+_.y>>1},b.prototype.drawShield=function(){return P.strokeStyle="rgb(0,".concat(V.timers.colorCycle>>1,",",V.timers.colorCycle,")"),P.beginPath(),P.arc(this.x,this.y,Math.min(this.width,this.height),0,2*Math.PI,!1),P.stroke()},b.prototype.drawSight=function(){return P.strokeStyle="#FF0000",P.lineWidth=D,P.beginPath(),P.moveTo(this.x,this.y-this.halfHeight),P.lineTo(this.x,0),P.closePath(),P.stroke(),P.lineWidth=t},b.prototype.draw=function(){P.beginPath(),P.moveTo(this.x,this.y-this.halfHeight),P.quadraticCurveTo(this.x+this.halfWidth,this.y,this.x+this.halfWidth,this.y+this.halfHeight),P.quadraticCurveTo(this.x+this.eighthWidth,this.y+this.fourthHeight,this.x,this.y+this.fourthHeight),P.quadraticCurveTo(this.x-this.eighthWidth,this.y+this.fourthHeight,this.x-this.halfWidth,this.y+this.halfHeight),P.quadraticCurveTo(this.x-this.halfWidth,this.y,this.x,this.y-this.halfHeight),P.closePath(),P.stroke(),this.shield>0&&this.drawShield();if(this.lockOn)return this.drawSight()},b.prototype.damage=function(a){V.timers.dispHealth=255,this.shield-=a*20;if(this.shield<0)return this.health+=Math.floor(this.shield/20),this.shield=0},b.prototype.takeDamage=function(){var a,b,c,d,e,f,g,h,i,j,k,l,m;j=V.owners.enemies.lasers;for(d=0,g=j.length;d<g;d++)b=j[d],Math.abs(this.x-b.x)<=this.width/2&&Math.abs(this.y-b.y+b.speed/2)<=(Math.abs(b.speed)+b.height)/2+this.height/2&&(b.hitSomething=!0,this.damage(8));k=V.owners.enemies.bombs;for(e=0,h=k.length;e<h;e++)a=k[e],this.boxHit(a)&&(a.cooldown=0,this.damage(2));l=V.owners.enemies.shrapnels,m=[];for(f=0,i=l.length;f<i;f++)c=l[f],this.boxHit(c)?(c.cooldown=0,m.push(this.damage(2))):m.push(void 0);return m},b.prototype.cooldown=function(){this.laserCooldown>0&&(this.laserCooldown-=1),this.bombCooldown>0&&(this.bombCooldown-=1);if(this.heat>0)return this.heat-=1},b.prototype.lockOnEnemies=function(a,b){var c,d,e,f,g;f=V.owners.enemies.units,g=[];for(d=0,e=f.length;d<e;d++)c=f[d],N(c.x,a,this.x)&&(c.y<b||c.y<this.y)?g.push(c.locked=!0):g.push(void 0);return g},b.prototype.update=function(){var a,b;return a=this.x,b=this.y,this.move(),this.lockOn&&this.lockOnEnemies(a,b),this.takeDamage(),this.shield=Math.max(this.shield-1,0),this.cooldown()},b}(g),h=function(){function a(a,b,c,d){this.x=a,this.y=b,this.target=c,this.owner=d,this.removed=!1,this.launchCountDown=10,this.explodeCountDown=30}return a.prototype.width=10,a.prototype.height=10,a.prototype.draw=function(){return P.beginPath(),P.moveTo(this.x,this.y-5),P.lineTo(this.x+5,this.y),P.lineTo(this.x,this.y+5),P.lineTo(this.x-5,this.y),P.closePath(),P.stroke()},a.prototype.explode=function(){var a;return this.owner.shrapnels=this.owner.shrapnels.concat(function(){var b,c;c=[];for(a=b=0;b<=9;a=++b)c.push(new G(this.x,this.y,a*36*Math.PI/180,G.prototype.speed,this.owner));return c}.call(this))},a.prototype.move=function(){return this.launchCountDown>0||this.target==null?(this.y-=20,this.launchCountDown-=1):(this.x=this.x*.8+this.target.x*.2|0,this.y=this.y*.8+this.target.y*.2|0)},a.prototype.update=function(){this.move(),this.explodeCountDown-=1;if(this.explodeCountDown<0)return this.explode(),this.target.locked=!1,this.removed=!0},a}(),d=function(a){function b(a,b,c,d,e){this.x=a,this.y=b,this.speed=c,this.cooldown=d,this.owner=e}return bk(b,a),b.prototype.width=4,b.prototype.height=4,b.prototype.speed=12,b.prototype.move=function(){return this.y+=this.speed},b.prototype.explode=function(){var a;return this.owner.shrapnels=this.owner.shrapnels.concat(function(){var b,c;c=[];for(a=b=0;b<=9;a=++b)c.push(new G(this.x,this.y,a*36*Math.PI/180,G.prototype.speed,this.owner));return c}.call(this))},b.prototype.draw=function(){return P.fillStyle=this.owner.color,this.drawAsBox()},b.prototype.update=function(){return this.cooldown-=1,this.cooldown<=0&&this.explode(),this.move()},b}(g),bd=function(a,b){return Math.floor(Math.random()*(b-a+1))+a},S=function(a,b){return setInterval(b,a)},bb=function(a,b){var c,d,e,f,g;b==null&&(b=function(a){return a}),e=[],d=[];for(f=0,g=a.length;f<g;f++)c=a[f],(b(c)?e:d).push(c);return[e,d]},Y=Math.PI/2,e=function(a){function b(a,c){this.x=a,this.y=c,b.__super__.constructor.call(this,this.x,this.y),this.angle=0,this.bombCooldown=Math.floor(Math.random()*this.cooldownTime),this.turnVel=(Math.random()-.5)/30,this.health=1,this.goneOnScreen=!1,this.halfWidth=this.width>>1,this.halfHeight=this.height>>1,this.scoreValue=5}return bk(b,a),b.prototype.rand=.01,b.prototype.threshold=30,b.prototype.width=10,b.prototype.height=28,b.prototype.cooldownTime=40,b.prototype.impactDamage=24,b.prototype.move=function(){return this.x+=2*Math.cos(this.angle+Y),this.y+=2*Math.sin(this.angle+Y),this.angle+=this.turnVel},b.prototype.draw=function(){return P.translate(this.x,this.y),P.rotate(this.angle),P.beginPath(),P.moveTo(0,this.halfHeight),P.lineTo(this.halfWidth,0),P.lineTo(0,-this.halfHeight),P.lineTo(-this.halfWidth,0),P.closePath(),P.stroke(),P.rotate(-this.angle),P.translate(-this.x,-this.y)},b.prototype.bomb=function(){return this.bombCooldown=this.cooldownTime,V.owners.enemies.bombs.push(new d(this.x,this.y,4,35,V.owners.enemies))},b.prototype.removeOffScreen=function(){if(this.offscreen()){if(this.goneOnScreen)return this.removed=!0,!0}else this.goneOnScreen=!0;return!1},b.prototype.update=function(){this.bombCooldown===0&&this.bomb(),this.bombCooldown-=1,this.move();if(!this.removeOffScreen())return this.takeDamage()},b.prototype.getAnimation=function(){return new f(this.x,this.y,this.angle)},b}(l),q=function(a){function b(a,c){this.x=a,this.y=c,b.__super__.constructor.call(this,this.x,this.y)}return bk(b,a),b.prototype.rand=.05,b.prototype.width=4,b.prototype.height=4,b.prototype.speed=5,b.prototype.color="#00FF00",b.prototype.use=function(){return be.health=Math.min(be.health+15,A),V.timers.dispHealth=255},b}(x),I=function(a){function b(a,c,d){this.x=a,this.y=c,this.angle=d,b.__super__.constructor.call(this,5),this.halfWidth=this.width>>1,this.halfHeight=this.height>>1}return bk(b,a),b.prototype.width=20,b.prototype.height=20,b.prototype.drawFrame=function(){var a;return P.strokeStyle="rgba(255,0,0,".concat(1-this.frame/this.framecount,")"),a=this.frame*2,P.translate(this.x,this.y),P.rotate(this.angle),P.beginPath(),P.moveTo(-this.halfWidth-a,-this.halfHeight-a),P.lineTo(this.halfWidth+a,-this.halfHeight-a),P.lineTo(this.halfWidth+a,this.halfHeight+a),P.lineTo(-this.halfWidth-a,this.halfHeight+a),P.closePath(),P.stroke(),P.rotate(-this.angle),P.translate(-this.x,-this.y)},b}(b),n=function(a){function b(a,c){this.x=a,this.y=c,b.__super__.constructor.call(this,5),this.halfWidth=this.width>>1,this.halfHeight=this.height>>1}return bk(b,a),b.prototype.width=20,b.prototype.height=20,b.prototype.drawFrame=function(){var a;return P.strokeStyle="rgba(255,0,0,".concat(1-this.frame/this.framecount,")"),P.beginPath(),a=this.frame*2,P.moveTo(this.x-this.halfWidth-a,this.y-this.halfHeight-a),P.lineTo(this.x+this.halfWidth+a,this.y-this.halfHeight-a),P.lineTo(this.x,this.y+this.halfHeight+a),P.closePath(),P.stroke()},b}(b),v=function(a){function b(a,c){this.x=a,this.y=c,b.__super__.constructor.call(this,this.x,this.y)}return bk(b,a),b.prototype.rand=.02,b.prototype.width=4,b.prototype.height=4,b.prototype.speed=5,b.prototype.color="#FF9900",b.prototype.use=function(){return be.laserPower+=1},b}(x),E=function(a){function b(a,c){this.x=a,this.y=c,b.__super__.constructor.call(this,this.x,this.y)}return bk(b,a),b.prototype.rand=.1,b.prototype.width=4,b.prototype.height=4,b.prototype.speed=5,b.prototype.color="#0088FF",b.prototype.use=function(){return be.shield=Math.min(be.shield+200,B),V.timers.dispHealth=255},b}(x),m=function(a){function b(a,c){this.x=a,this.y=c,b.__super__.constructor.call(this,this.x,this.y),this.shootCooldown=Math.floor(Math.random()*this.cooldownTime),this.health=1,this.halfWidth=this.width>>1,this.halfHeight=this.height>>1,this.scoreValue=1}return bk(b,a),b.prototype.rand=.02,b.prototype.threshold=0,b.prototype.width=20,b.prototype.height=20,b.prototype.cooldownTime=35,b.prototype.impactDamage=24,b.prototype.draw=function(){return P.beginPath(),P.moveTo(this.x-this.halfWidth,this.y-this.halfHeight),P.lineTo(this.x+this.halfWidth,this.y-this.halfHeight),P.lineTo(this.x,this.y+this.halfHeight),P.closePath(),P.stroke()},b.prototype.move=function(){var a;return this.y+=3,a=(be.x-this.x)/12,Math.abs(a)<5?this.x+=a|0:a>0?this.x+=5:this.x-=5},b.prototype.shoot=function(){return this.shootCooldown=this.cooldownTime,V.owners.enemies.lasers.push(new u(this.x,this.y,u.prototype.speed,V.owners.enemies))},b.prototype.removeOffScreen=function(){return this.y>O.height?(this.removed=!0,!0):!1},b.prototype.update=function(){this.shootCooldown===0&&this.shoot(),this.shootCooldown-=1,this.move();if(!this.removeOffScreen())return this.takeDamage()},b.prototype.getAnimation=function(){return new n(this.x,this.y)},b}(l),H=function(a){function b(a,c){this.x=a,this.y=c,b.__super__.constructor.call(this,this.x,this.y),this.angle=0,this.shootCooldown=Math.floor(Math.random()*this.cooldownTime),this.burst=0,this.health=1,this.halfWidth=this.width>>1,this.halfHeight=this.height>>1,this.scoreValue=10}return bk(b,a),b.prototype.rand=.005,b.prototype.threshold=45,b.prototype.width=20,b.prototype.height=20,b.prototype.cooldownTime=55,b.prototype.impactDamage=24,b.prototype.draw=function(){return P.translate(this.x,this.y),P.rotate(this.angle),P.beginPath(),P.moveTo(-this.halfWidth,-this.halfHeight),P.lineTo(this.halfWidth,-this.halfHeight),P.lineTo(this.halfWidth,this.halfHeight),P.lineTo(-this.halfWidth,this.halfHeight),P.closePath(),P.stroke(),P.rotate(-this.angle),P.translate(-this.x,-this.y)},b.prototype.move=function(){return this.angle+=.1,this.y+=2},b.prototype.shoot=function(){return this.burst<5?this.burst+=1:(this.shootCooldown=this.cooldownTime,this.burst=0),V.owners.enemies.lasers.push(new u(this.x,this.y,u.prototype.speed,V.owners.enemies))},b.prototype.removeOffScreen=function(){return this.y>O.height?(this.removed=!0,!0):!1},b.prototype.update=function(){this.shootCooldown<=0&&this.shoot(),this.shootCooldown-=1,this.move();if(!this.removeOffScreen())return this.takeDamage()},b.prototype.getAnimation=function(){return new I(this.x,this.y,this.angle)},b}(l),p=function(){function a(a){this.owners={player:{lasers:[],bombs:[],darts:[],shrapnels:[],unit:a,color:o,score:0,kills:0,lasersFired:0,bombsFired:0,dartsFired:0,lives:w},enemies:{lasers:[],bombs:[],darts:[],shrapnels:[],units:[],color:c}},this.timers={dispHealth:0,dispLives:0,colorCycle:0,colorCycleDir:10},this.powerups={healthups:{classType:q,instances:[]},laserups:{classType:v,instances:[]},shieldups:{classType:E,instances:[]}},this.animations=[],this.display=i.get(),this.crashed=!1}return a.prototype.checkCrashed=function(){if(this.crashed){Q=W.crashed,clearInterval(bg);return}return this.crashed=!0},a.prototype.cycleColorTimers=function(){this.timers.colorCycle+=this.timers.colorCycleDir,this.timers.colorCycle=Math.min(this.timers.colorCycle,255),this.timers.colorCycle=Math.max(this.timers.colorCycle,0);if(this.timers.colorCycle===0||this.timers.colorCycle===255)return this.timers.colorCycleDir*=-1},a.prototype.checkLifeLost=function(){if(be.health<=0)return this.owners.player.lives-=1,be.reset(0,this.display.canvas.height),this.timers.dispLives=255},a.prototype.checkGameOver=function(){return this.owners.player.lives<0?(Q=W.gameOver,clearInterval(bg),bh=(new Date).getTime(),this.display.drawGameOver(),!0):!1},a.prototype.updateEnemies=function(){var a,b,c,d,e;d=this.owners.enemies.units,e=[];for(b=0,c=d.length;b<c;b++)a=d[b],e.push(a.update());return e},a.prototype.genPowerup=function(a){var b,c,d,e,f;e=this.owners.enemies.units,f=[];for(c=0,d=e.length;c<d;c++)b=e[c],b.health<=0&&Math.random()<a.prototype.rand&&f.push(new a(b.x,b.y));return f},a.prototype.generatePowerups=function(){var a,b,c,d;c=this.powerups,d=[];for(b in c)a=c[b],d.push(a.instances=a.instances.concat(this.genPowerup(a.classType)));return d},a.prototype.removeDeadEnemies=function(){var a,b,c;return this.generatePowerups(),this.owners.enemies.units=function(){var a,c,d,e;d=this.owners.enemies.units,e=[];for(a=0,c=d.length;a<c;a++)b=d[a],b.removed||e.push(b);return e}.call(this),c=bb(this.owners.enemies.units,function(a){return a.health>0}),this.owners.enemies.units=c[0],a=c[1],this.owners.player.score+=a.reduce(function(a,b){return a+b.scoreValue},0),this.animations=this.animations.concat(function(){var c,d,e;e=[];for(c=0,d=a.length;c<d;c++)b=a[c],e.push(b.getAnimation());return e}())},a.prototype.removeFinishedAnimations=function(){var a;return this.animations=function(){var b,c,d,e;d=this.animations,e=[];for(b=0,c=d.length;b<c;b++)a=d[b],a.finished()||e.push(a);return e}.call(this)},a.prototype.generateEnemies=function(){var a,b,c,d,f;d=[m,r,e,H],f=[];for(b=0,c=d.length;b<c;b++)a=d[b],this.owners.player.kills>=a.prototype.threshold&&Math.random()<a.prototype.rand?f.push(this.owners.enemies.units.push(new a(bd(0,O.width),-10))):f.push(void 0);return f},a.prototype.updateFired=function(){var a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t;o=this.owners,t=[];for(e in o){d=o[e],p=d.lasers;for(g=0,k=p.length;g<k;g++)c=p[g],c.update();d.lasers=function(){var a,b,e,f,g;e=d.lasers,g=[];for(a=0,b=e.length;a<b;a++)c=e[a],0<(f=c.y)&&f<O.height&&!c.hitSomething&&g.push(c);return g}(),q=d.bombs;for(h=0,l=q.length;h<l;h++)a=q[h],a.update();d.bombs=function(){var b,c,e,f;e=d.bombs,f=[];for(b=0,c=e.length;b<c;b++)a=e[b],a.cooldown>0&&f.push(a);return f}(),r=d.shrapnels;for(i=0,m=r.length;i<m;i++)f=r[i],f.update();d.shrapnels=function(){var a,b,c,e;c=d.shrapnels,e=[];for(a=0,b=c.length;a<b;a++)f=c[a],f.cooldown>0&&e.push(f);return e}(),s=d.darts;for(j=0,n=s.length;j<n;j++)b=s[j],b.update();t.push(d.darts=function(){var a,c,e,f;e=d.darts,f=[];for(c=0,a=e.length;c<a;c++)b=e[c],b.removed||f.push(b);return f}())}return t},a.prototype.updatePowerups=function(){var a,b,c,d,e,f,g,h;f=this.powerups,h=[];for(c in f){b=f[c],g=b.instances;for(d=0,e=g.length;d<e;d++)a=g[d],a.update();h.push(this.powerups[c].instances=function(){var c,d,e,f;e=b.instances,f=[];for(c=0,d=e.length;c<d;c++)a=e[c],a.used||f.push(a);return f}())}return h},a.prototype.shootLaser=function(){var a,b,c;this.owners.player.lasersFired+=be.laserPower;for(a=b=1,c=be.laserPower;1<=c?b<=c:b>=c;a=1<=c?++b:--b)this.owners.player.lasers.push(new u(be.x+a*4-be.laserPower*2,be.y,-u.prototype.speed,this.owners.player));return be.heat>z?be.laserCooldown=7:be.heat>C?be.laserCooldown=5:be.laserCooldown=2,be.heat+=7},a.prototype.shootBomb=function(){return this.owners.player.bombsFired+=1,this.owners.player.bombs.push(new d(be.x,be.y,-d.prototype.speed,20,this.owners.player)),be.heat>z?be.bombCooldown=20:be.heat>C?be.bombCooldown=10:be.bombCooldown=5,be.heat+=10},a.prototype.shootDart=function(a){return this.owners.player.dartsFired+=1,this.owners.player.darts.push(new h(be.x,be.y,a,this.owners.player))},a}(),console.log("Game init"),R=i.get(),P=R.ctx,O=R.canvas,K=document.getElementById("audio");if(P==null)throw"Loading context failed";T=function(){return P.lineWidth=t,$("#enableMusic")[0].checked&&(K.play(),ba=!0),U=!1},Z=function(){return U&&T(),be=new F(_.x,_.y),V=new p},bf=function(){return bg=S(26,X)},bc=function(){return M=(new Date).getTime(),Q=W.paused,clearInterval(bg),R.drawHealth(),R.drawLives(),R.setTitleFont(),P.fillText("[Paused]",O.width>>1,O.height>>1)},bi=function(){return Q=W.playing,_.beginLeftHold+=(new Date).getTime()-M,bf()},$(document).keyup(function(a){switch(a.which){case 80:switch(Q){case W.paused:return bi();case W.playing:return bc()}}}),$("#c").mousemove(function(a){return _.x=a.pageX-this.offsetLeft,_.y=a.pageY-this.offsetTop}).mouseout(function(a){if(Q===W.playing)return L=setTimeout(bc,1e3)}).mouseenter(function(a){if(L!=null)return clearTimeout(L),L=void 0}).mousedown(function(a){switch(a.which){case 1:return _.leftDown=!0,_.beginLeftHold=(new Date).getTime();case 3:return _.rightDown=!0}}).mouseup(function(a){switch(a.which){case 1:return _.leftDown=!1;case 3:return _.rightDown=!1}}).click(function(a){switch(Q){case W.paused:return bi();case W.title:return Q=W.playing,Z(),bf();case W.gameOver:if((new Date).getTime()-bh>500)return Q=W.title,R.drawTitleScreen()}}).bind("contextmenu",function(a){return!1}),$("#enableMusic").change(function(a){if(!U)return $("#enableMusic")[0].checked?(K.play(),ba=!0):(K.pause(),ba=!1)}),X=function(){var a,b,c,d,e,f,g,h,i,j,l,m,n,o,p,q,r,s,t,u,v,w,x,A,B,D,E,F,G,H,I,K,L;V.checkCrashed(),V.cycleColorTimers(),V.checkLifeLost();if(V.checkGameOver())return;R.clearScreen(),V.updateEnemies(),V.removeDeadEnemies(),V.removeFinishedAnimations(),V.generateEnemies(),be.update(),V.updateFired(),V.updatePowerups();if(_.leftDown)(new Date).getTime()-_.beginLeftHold<1e3?be.laserCooldown<=0&&V.shootLaser():be.lockOn=!0;else{if(be.lockOn){B=V.owners.enemies.units;for(i=0,n=B.length;i<n;i++)d=B[i],d.locked&&V.shootDart(d)}be.lockOn=!1}_.rightDown&&be.bombCooldown<=0&&V.shootBomb(),P.strokeStyle=k,D=V.owners.enemies.units;for(j=0,o=D.length;j<o;j++)d=D[j],d.draw();P.strokeStyle=y,be.draw(),E=V.owners;for(g in E){f=E[g],P.strokeStyle=f.color,P.fillStyle=f.color,F=f.lasers;for(l=0,p=F.length;l<p;l++)e=F[l],e.draw();G=f.bombs;for(m=0,q=G.length;m<q;m++)b=G[m],b.draw();H=f.shrapnels;for(v=0,r=H.length;v<r;v++)h=H[v],h.draw();I=f.darts;for(w=0,s=I.length;w<s;w++)c=I[w],c.draw()}P.strokeStyle=J,K=V.owners.enemies.units;for(x=0,t=K.length;x<t;x++)d=K[x],d.locked&&R.drawTarget(d.x,d.y);L=V.animations;for(A=0,u=L.length;A<u;A++)a=L[A],a.drawFrame(),a.nextFrame();return P.textAlign="center",P.textBaseline="bottom",be.heat>z?(P.fillStyle="rgb(".concat(V.timers.colorCycle,",0,0)"),P.font="bold 20px Helvetica",P.fillText("[ Heat Critical ]",O.width/2,O.height-30)):be.heat>C&&(P.fillStyle="rgb(".concat(V.timers.colorCycle,",",V.timers.colorCycle,",0)"),P.font="normal 18px Helvetica",P.fillText("[ Heat Warning ]",O.width/2,O.height-30)),V.timers.dispHealth>0&&(R.drawHealth(),V.timers.dispHealth-=10),V.timers.dispLives>0&&(R.drawLives(),V.timers.dispLives-=1),V.crashed=!1},a?(Q=W.playing,Z(),bf()):(Q=W.title,R.drawTitleScreen())})).call(this)