(function(){var B,H,I,J,K,w,L,M,N,m,g,x,a,l,C,O,D,q,P,y,b,i,z,E,k,F,t,Q,A,e,r,G;g=document.getElementById("c");a=g.getContext("2d");m=$("<audio></audio>").attr({loop:"loop"}).append($("<source></source>").attr({src:"media/tonight_full.ogg"})).append($("<source></source>").attr({src:"media/tonight_full.mp3"})).appendTo("body")[0];console.log(m);if(!a)throw"Loading context failed";t=function(b,f){return Math.floor(Math.random()*(f-b+1))+b};q=function(b,f){return setInterval(f,b)};e=b=void 0;y=!0;k=
{x:250,y:200,leftDown:!1,rightDown:!1};r=void 0;i={title:"Title",gameover:"GameOver",playing:"Playing",paused:"Paused",crashed:"Crashed"};l=i.title;B=function(){function b(f,a,c,d,e){this.x=f;this.y=a;this.speed=c;this.cooldown=d;this.owner=e}b.prototype.move=function(){return this.y+=this.speed};b.prototype.explode=function(){var f;return this.owner.shrapnals=this.owner.shrapnals.concat(function(){var b;b=[];for(f=0;f<=9;f++)b.push(new M(this.x,this.y,f*36*Math.PI/180,10,this.owner));return b}.call(this))};
b.prototype.draw=function(){a.fillStyle=this.owner.color;return a.fillRect(this.x-2,this.y-2,4,4)};b.prototype.update=function(){this.cooldown-=1;this.cooldown<=0&&this.explode();this.move();return this.draw()};return b}();H=function(){function c(f,b){this.x=f;this.y=b;this.bombCooldown=this.angle=0;this.turnVel=(Math.random()-0.5)/30;this.health=1}c.prototype.move=function(){this.x+=2*Math.cos(this.angle+Math.PI/2);this.y+=2*Math.sin(this.angle+Math.PI/2);this.angle+=this.turnVel;return this.goneOnScreen=
0};c.prototype.draw=function(){a.translate(this.x,this.y);a.rotate(this.angle);a.beginPath();a.moveTo(0,14);a.lineTo(5,0);a.lineTo(0,-14);a.lineTo(-5,0);a.closePath();a.stroke();a.rotate(-this.angle);return a.translate(-this.x,-this.y)};c.prototype.bomb=function(){this.bombCooldown=40;return b.owners.enemies.bombs.push(new B(this.x,this.y,4,35,b.owners.enemies))};c.prototype.takeDamage=function(){var f,a,c,d;if(this.x<0||this.x>g.width||this.y<0||this.y>g.height){if(this.goneOnScreen)return this.health=
0}else this.goneOnScreen=1;if(Math.abs(e.x-this.x)<25&&Math.abs(e.y-this.y)<34)return b.owners.player.health-=24,b.owners.player.kills+=1,b.timers.dispHealth=255,this.health=0;d=b.owners.player.lasers;a=0;for(c=d.length;a<c;a++)if(f=d[a],Math.abs(this.x-f.x)<=5&&Math.abs(this.y-f.y+f.speed/2)<=(Math.abs(f.speed)+16)/2+14)return f.killedSomething=!0,b.owners.player.kills+=1,this.health=0;d=b.owners.player.bombs;a=0;for(c=d.length;a<c;a++)if(f=d[a],Math.abs(f.x-this.x)<7&&Math.abs(f.y-this.y)<16)return f.cooldown=
0,b.owners.player.kills+=1,this.health=0;d=b.owners.player.shrapnals;a=0;for(c=d.length;a<c;a++)if(f=d[a],Math.abs(f.x-this.x)<6&&Math.abs(f.y-this.y)<15)return b.owners.player.kills+=1,this.health=0};c.prototype.update=function(){this.bombCooldown===0&&this.bomb();this.bombCooldown-=1;this.move();this.draw();return this.takeDamage()};return c}();I=function(){function c(b,a){this.x=b;this.y=a;this.shootCooldown=0;this.health=1}c.prototype.draw=function(){a.strokeStyle="#FFFFFF";a.beginPath();a.moveTo(this.x-
10,this.y-10);a.lineTo(this.x+10,this.y-10);a.lineTo(this.x,this.y+10);a.closePath();return a.stroke()};c.prototype.move=function(){var b;this.y+=3;b=(e.x-this.x)/12;return this.x+=Math.abs(b)<5?b:5*b/Math.abs(b)};c.prototype.shoot=function(){this.shootCooldown=35;return b.owners.enemies.lasers.push(new w(this.x,this.y,20,b.owners.enemies))};c.prototype.takeDamage=function(){var f,a,c,d;if(this.y>g.height)return this.health=0;if(Math.abs(e.x-this.x)<30&&Math.abs(e.y-this.y)<30)return b.owners.player.health-=
24,b.owners.player.kills+=1,b.timers.dispHealth=255,this.health=0;d=b.owners.player.lasers;a=0;for(c=d.length;a<c;a++)if(f=d[a],Math.abs(this.x-f.x)<=10&&Math.abs(this.y-f.y+f.speed/2)<=(Math.abs(f.speed)+16)/2+10)return f.killedSomething=!0,b.owners.player.kills+=1,this.health=0;d=b.owners.player.bombs;a=0;for(c=d.length;a<c;a++)if(f=d[a],Math.abs(f.x-this.x)<12&&Math.abs(f.y-this.y)<12)return f.cooldown=0,b.owners.player.kills+=1,this.health=0;d=b.owners.player.shrapnals;a=0;for(c=d.length;a<c;a++)if(f=
d[a],Math.abs(f.x-this.x)<11&&Math.abs(f.y-this.y)<11)return b.owners.player.kills+=1,this.health=0};c.prototype.update=function(){this.shootCooldown===0&&this.shoot();this.shootCooldown-=1;this.move();this.draw();return this.takeDamage()};return c}();J=function(){function c(b,a){this.x=b;this.y=a;this.used=0}c.prototype.move=function(){return this.y+=5};c.prototype.draw=function(){a.fillStyle="#00FF00";return a.fillRect(this.x-2,this.y-2,4,4)};c.prototype.detectUse=function(){if(Math.abs(e.x-this.x)<
22&&Math.abs(e.y-this.y)<22)this.used=1,b.owners.player.health=Math.min(b.owners.player.health+15,100),b.timers.dispHealth=255;if(this.x<0||this.x>g.width||this.y<0||this.y>g.height)return this.used=1};c.prototype.update=function(){this.move();this.draw();return this.detectUse()};return c}();K=function(){function c(b,a){this.x=b;this.y=a;this.moveState=this.shootCooldown=this.angle=0;this.health=1}c.prototype.move=function(){var b;switch(this.moveState){case 0:return Math.abs(this.x-e.x)<150&&Math.abs(this.y-
e.y)<150?this.moveState=1:(this.angle=0,this.y+=1);case 1:return b=this.y>e.y?Math.PI-Math.atan((this.x-e.x)/(this.y-e.y)):-Math.atan((this.x-e.x)/(this.y-e.y)),Math.abs(b-this.angle)<Math.PI/24||Math.abs(b-this.angle)>Math.PI*2-Math.PI/24?(this.angle=b,this.moveState=2):this.angle<b&&this.angle-b<Math.PI||Math.PI*2-this.angle-b<Math.PI?this.angle+=Math.PI/24:this.angle-=Math.PI/24;case 2:return this.x+=30*Math.cos(this.angle+Math.PI/2),this.y+=30*Math.sin(this.angle+Math.PI/2)}};c.prototype.draw=
function(){a.translate(this.x,this.y);a.rotate(this.angle);a.beginPath();a.moveTo(-10,-10);a.lineTo(10,-10);a.lineTo(10,4);a.lineTo(0,10);a.lineTo(-10,4);a.closePath();a.stroke();a.rotate(-this.angle);return a.translate(-this.x,-this.y)};c.prototype.takeDamage=function(){var a,c,h,d;if(this.y>g.height||this.moveState&&(this.x<0||this.x>g.width||this.y<0||this.y>g.height))return this.health=0;if(Math.abs(e.x-this.x)<30&&Math.abs(e.y-this.y)<30)return b.owners.player.kills+=1,b.owners.player.health-=
35,b.timers.dispHealth=255,this.health=0;d=b.owners.player.lasers;c=0;for(h=d.length;c<h;c++)if(a=d[c],Math.abs(this.x-a.x)<=10&&Math.abs(this.y-a.y+a.speed/2)<=(Math.abs(a.speed)+16)/2+10)return a.killedSomething=!0,b.owners.player.kills+=1,this.health=0;d=b.owners.player.bombs;c=0;for(h=d.length;c<h;c++)if(a=d[c],Math.abs(a.x-this.x)<12&&Math.abs(a.y-this.y)<12)return a.cooldown=0,b.owners.player.kills+=1,this.health=0;d=b.owners.player.shrapnals;c=0;for(h=d.length;c<h;c++)if(a=d[c],Math.abs(a.x-
this.x)<11&&Math.abs(a.y-this.y)<11)return b.owners.player.kills+=1,this.health=0};c.prototype.update=function(){this.move();this.draw();return this.takeDamage()};return c}();w=function(){function b(a,c,e,d){this.x=a;this.y=c;this.speed=e;this.owner=d;this.killedSomething=!1}b.prototype.draw=function(){a.fillStyle=this.owner.color;return a.fillRect(this.x-1,this.y-8,2,16)};b.prototype.move=function(){return this.y+=this.speed};b.prototype.update=function(){this.move();return this.draw()};return b}();
L=function(){function c(b,a){this.x=b;this.y=a;this.heat=this.bombCooldown=this.laserCooldown=0}c.prototype.move=function(){this.x=(this.x+k.x)/2;return this.y=(this.y+k.y)/2};c.prototype.draw=function(){a.strokeStyle="#FFFFFF";a.beginPath();a.moveTo(this.x,this.y-20);a.quadraticCurveTo(this.x+20,this.y,this.x+20,this.y+20);a.quadraticCurveTo(this.x+5,this.y+10,this.x,this.y+10);a.quadraticCurveTo(this.x-5,this.y+10,this.x-20,this.y+20);a.quadraticCurveTo(this.x-20,this.y,this.x,this.y-20);a.closePath();
return a.stroke()};c.prototype.takeDamage=function(){var a,c,e,d,g;d=b.owners.enemies.lasers;c=0;for(e=d.length;c<e;c++)if(a=d[c],Math.abs(this.x-a.x)<=20&&Math.abs(this.y-a.y+a.speed/2)<=(Math.abs(a.speed)+16)/2+20)a.killedSomething=!0,b.owners.player.health-=8,b.timers.dispHealth=255;d=b.owners.enemies.bombs;c=0;for(e=d.length;c<e;c++)if(a=d[c],Math.abs(a.x-this.x)<22&&Math.abs(a.y-this.y)<22)a.cooldown=0,b.owners.player.health-=2,b.timers.dispHealth=255;d=b.owners.enemies.shrapnals;g=[];c=0;for(e=
d.length;c<e;c++)a=d[c],g.push(Math.abs(a.x-this.x)<21&&Math.abs(a.y-this.y)<21?(a.cooldown=0,b.owners.player.health-=2,b.timers.dispHealth=255):void 0);return g};c.prototype.update=function(){this.move();this.draw();return this.takeDamage()};return c}();M=function(){function b(a,c,e,d,g){this.x=a;this.y=c;this.angle=e;this.speed=d;this.owner=g;this.cooldown=10}b.prototype.move=function(){this.x+=this.speed*Math.cos(this.angle);return this.y+=this.speed*Math.sin(this.angle)};b.prototype.draw=function(){a.fillStyle=
this.owner.color;return a.fillRect(this.x-1,this.y-1,2,2)};b.prototype.update=function(){this.cooldown-=1;this.move();return this.draw()};return b}();N=function(){function c(a,b){this.x=a;this.y=b;this.burst=this.shootCooldown=this.angle=0;this.health=1}c.prototype.draw=function(){a.translate(this.x,this.y);a.rotate(this.angle);a.beginPath();a.moveTo(-10,-10);a.lineTo(10,-10);a.lineTo(10,10);a.lineTo(-10,10);a.closePath();a.stroke();a.rotate(-this.angle);return a.translate(-this.x,-this.y)};c.prototype.move=
function(){this.angle+=0.1;return this.y+=2};c.prototype.shoot=function(){this.burst<5?this.burst+=1:(this.shootCooldown=55,this.burst=0);return b.owners.enemies.lasers.push(new w(this.x,this.y,20,b.owners.enemies))};c.prototype.takeDamage=function(){var a,c,h,d;if(this.y>g.height)return this.health=0;if(Math.abs(e.x-this.x)<30&&Math.abs(e.y-this.y)<30)return b.owners.player.health-=24,b.owners.player.kills+=1,b.timers.dispHealth=255,this.health=0;d=b.owners.player.lasers;c=0;for(h=d.length;c<h;c++)if(a=
d[c],Math.abs(this.x-a.x)<=10&&Math.abs(this.y-a.y+a.speed/2)<=(Math.abs(a.speed)+16)/2+10)return a.killedSomething=!0,b.owners.player.kills+=1,this.health=0;d=b.owners.player.bombs;c=0;for(h=d.length;c<h;c++)if(a=d[c],Math.abs(a.x-this.x)<12&&Math.abs(a.y-this.y)<12)return a.cooldown=0,b.owners.player.kills+=1,this.health=0;d=b.owners.player.shrapnals;c=0;for(h=d.length;c<h;c++)if(a=d[c],Math.abs(a.x-this.x)<11&&Math.abs(a.y-this.y)<11)return b.owners.player.kills+=1,this.health=0};c.prototype.update=
function(){this.shootCooldown<=0&&this.shoot();this.shootCooldown-=1;this.move();this.draw();return this.takeDamage()};return c}();A=function(){a.fillStyle="#FFFFFF";a.font="bold 20px Lucidia Console";a.textAlign="center";return a.textBaseline="middle"};Q=function(){a.fillStyle="#FFFFFF";a.font="normal 18px Lucidia Console";a.textAlign="left";return a.textBaseline="bottom"};x=function(){a.fillStyle="#000000";return a.fillRect(0,0,g.width,g.height)};D=function(){x();A();a.fillText("Tempus [Dev]",g.width/
2,g.height/2-12);a.fillText("Click to play",g.width/2,g.height/2+12);Q();return a.fillText("by Jake Stothard",10,g.height-10)};O=function(){x();A();a.fillText("Game Over",g.width/2,g.height/2-20);a.font="normal 18px Lucidia Console";a.fillText("Kills - "+b.owners.player.kills,g.width/2,g.height/2);a.fillText("Lasers Fired - "+b.owners.player.lasersFired,g.width/2,g.height/2+20);return a.fillText("Bombs Used - "+b.owners.player.bombsFired,g.width/2,g.height/2+40)};a.strokeStyle="#FFFFFF";a.lineWidth=
4;P=function(){$("#enableMusic")[0].checked&&m.play();return y=!1};E=function(){y&&P();e=new L(k.x,k.y);return b={owners:{player:{lasers:[],bombs:[],shrapnals:[],units:e,color:"#0044FF",health:100,kills:0,lasersFired:0,bombsFired:0},enemies:{lasers:[],bombs:[],shrapnals:[],units:[],color:"#FF0000"}},timers:{dispHealth:0,colorCycle:0,colorCycleDir:10},powerups:{healthups:[]},crashed:!1}};C=function(){a.beginPath();a.arc(g.width/2,g.height/2,Math.min(g.width,g.height)/2-20,0,Math.max(b.owners.player.health,
0)*Math.PI/50,!1);return a.stroke()};F=function(){l=i.paused;clearInterval(r);C();A();return a.fillText("[Paused]",g.width/2,g.height/2)};G=function(){l=i.playing;return r=q(32,z)};$(document).keyup(function(a){switch(a.which){case 80:switch(l){case i.paused:return G();case i.playing:return F()}}});$("#c").mousemove(function(a){k.x=a.pageX-this.offsetLeft;return k.y=a.pageY-this.offsetTop}).mouseout(function(){if(l===i.playing)return F()}).mousedown(function(a){switch(a.which){case 1:return k.leftDown=
!0;case 3:return k.rightDown=!0}}).mouseup(function(a){switch(a.which){case 1:return k.leftDown=!1;case 3:return k.rightDown=!1}}).click(function(){switch(l){case i.paused:return G();case i.title:return l=i.playing,E(),r=q(32,z);case i.gameOver:return l=i.title,D()}}).bind("contextmenu",function(){return!1});$("#enableMusic").change(function(){if(!y)return $("#enableMusic")[0].checked?(m.play(),!0):(m.pause(),!1)});z=function(){var c,f,s,h,d,m,u,q,v,n,j,o,p;if(b.crashed)l=i.crashed,clearInterval(r);
else{b.crashed=!0;b.timers.colorCycle+=b.timers.colorCycleDir;b.timers.colorCycle=Math.min(b.timers.colorCycle,255);b.timers.colorCycle=Math.max(b.timers.colorCycle,0);if(b.timers.colorCycle===0||b.timers.colorCycle===255)b.timers.colorCycleDir*=-1;if(b.owners.player.health<=0)l=i.gameOver,clearInterval(r),O();else{x();o=b.owners.enemies.units;n=0;for(j=o.length;n<j;n++)f=o[n],f.update();b.powerups.healthups=b.powerups.healthups.concat(function(){var a,c,d,e;d=b.owners.enemies.units;e=[];a=0;for(c=
d.length;a<c;a++)f=d[a],f.health<=0&&Math.random()<0.2&&e.push(new J(f.x,f.y));return e}());b.owners.enemies.units=function(){var a,c,d,e;d=b.owners.enemies.units;e=[];a=0;for(c=d.length;a<c;a++)f=d[a],f.health>0&&e.push(f);return e}();Math.random()<0.03&&b.owners.player.kills>=0&&b.owners.enemies.units.push(new I(t(0,g.width),-10));Math.random()<0.02&&b.owners.player.kills>=15&&b.owners.enemies.units.push(new K(t(0,g.width),-10));Math.random()<0.01&&b.owners.player.kills>=30&&b.owners.enemies.units.push(new H(t(0,
g.width),-10));Math.random()<0.005&&b.owners.player.kills>=45&&b.owners.enemies.units.push(new N(t(0,g.width),-10));e.update();n=b.owners;for(d in n){h=n[d];p=h.lasers;j=0;for(o=p.length;j<o;j++)s=p[j],s.update();h.lasers=function(){var a,b,c,d,e;c=h.lasers;e=[];a=0;for(b=c.length;a<b;a++)s=c[a],0<(d=s.y)&&d<g.height&&!s.killedSomething&&e.push(s);return e}();p=h.bombs;j=0;for(o=p.length;j<o;j++)c=p[j],c.update();h.bombs=function(){var a,b,d,e;d=h.bombs;e=[];a=0;for(b=d.length;a<b;a++)c=d[a],c.cooldown>
0&&e.push(c);return e}();p=h.shrapnals;j=0;for(o=p.length;j<o;j++)v=p[j],v.update();h.shrapnals=function(){var a,b,c,d;c=h.shrapnals;d=[];b=0;for(a=c.length;b<a;b++)v=c[b],v.cooldown>0&&d.push(v);return d}()}j=b.powerups;for(q in j){u=j[q];n=0;for(d=u.length;n<d;n++)m=u[n],m.update();b.powerups[q]=function(){var a,b,c;c=[];b=0;for(a=u.length;b<a;b++)m=u[b],m.used||c.push(m);return c}()}if(k.leftDown&&e.laserCooldown<=0)b.owners.player.lasersFired+=1,b.owners.player.lasers.push(new w(e.x,e.y,-20,b.owners.player)),
e.laserCooldown=e.heat>80?7:e.heat>40?5:2,e.heat+=7;if(k.rightDown&&e.bombCooldown<=0)b.owners.player.bombsFired+=1,l===i.playing&&b.owners.player.bombs.push(new B(e.x,e.y,-12,20,b.owners.player)),e.bombCooldown=e.heat>80?20:e.heat>40?10:5,e.heat+=10;e.laserCooldown>0&&(e.laserCooldown-=1);e.bombCooldown>0&&(e.bombCooldown-=1);e.heat>0&&(e.heat-=1);a.textAlign="center";a.textBaseline="bottom";if(e.heat>80)a.fillStyle="rgb(".concat(b.timers.colorCycle,",0,0)"),a.font="bold 20px Lucidia Console",a.fillText("[ Heat Critical ]",
g.width/2,g.height-30);else if(e.heat>40)a.fillStyle="rgb(".concat(b.timers.colorCycle,",",b.timers.colorCycle,",0)"),a.font="normal 18px Lucidia Console",a.fillText("[ Heat Warning ]",g.width/2,g.height-30);if(b.timers.dispHealth>0)a.strokeStyle="rgb(".concat(b.timers.dispHealth,",",b.timers.dispHealth,",",b.timers.dispHealth,")"),C(),a.strokeStyle="#FFFFFF",b.timers.dispHealth-=10;return b.crashed=!1}}};switch(l){case i.playing:E();r=q(32,z);break;case i.title:D()}}).call(this);
