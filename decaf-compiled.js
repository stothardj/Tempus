(function(){var z,G,H,I,A,J,K,s,f,t,a,n,B,L,C,u,M,v,b,l,w,D,m,E,x,N,y,d,r,F;f=document.getElementById("c");a=f.getContext("2d");s=$("<audio></audio>").attr({loop:"loop"}).append($("<source><source>").attr({src:"media/tonight_full.ogg"})).appendTo("body")[0];if(!a)throw"Loading context failed";x=function(b,o){return Math.floor(Math.random()*(o-b+1))+b};u=function(b,o){return setInterval(o,b)};d=b=void 0;v=!0;m={x:250,y:200,leftDown:!1,rightDown:!1};r=void 0;l={title:"Title",gameover:"GameOver",playing:"Playing",
paused:"Paused",crashed:"Crashed"};n=l.title;J=function(){function b(o,a){this.x=o;this.y=a;this.heat=this.bombCooldown=this.laserCooldown=0}b.prototype.move=function(){this.x=(this.x+m.x)/2;return this.y=(this.y+m.y)/2};b.prototype.draw=function(){a.strokeStyle="#FFFFFF";a.beginPath();a.moveTo(this.x,this.y-20);a.quadraticCurveTo(this.x+20,this.y,this.x+20,this.y+20);a.quadraticCurveTo(this.x+5,this.y+10,this.x,this.y+10);a.quadraticCurveTo(this.x-5,this.y+10,this.x-20,this.y+20);a.quadraticCurveTo(this.x-
20,this.y,this.x,this.y-20);a.closePath();return a.stroke()};b.prototype.update=function(){this.move();return this.draw()};return b}();H=function(){function c(b,a){this.x=b;this.y=a;this.shootCooldown=0}c.prototype.draw=function(){a.strokeStyle="#FFFFFF";a.beginPath();a.moveTo(this.x-10,this.y-10);a.lineTo(this.x+10,this.y-10);a.lineTo(this.x,this.y+10);a.closePath();return a.stroke()};c.prototype.move=function(){var b;this.y+=3;b=(d.x-this.x)/12;return this.x+=Math.abs(b)<5?b:5*b/Math.abs(b)};c.prototype.shoot=
function(){this.shootCooldown=35;return b.owners.enemies.lasers.push(new A(this.x,this.y,20,b.owners.enemies))};c.prototype.alive=function(){var a,g,c,e;if(this.y>f.height)return!1;if(Math.abs(d.x-this.x)<35&&Math.abs(d.y-this.y)<35)return b.owners.player.health-=24,b.owners.player.kills+=1,b.timers.dispHealth=255,!1;e=b.owners.player.lasers;g=0;for(c=e.length;g<c;g++)if(a=e[g],Math.abs(this.x-a.x)<=12&&Math.abs(this.y-a.y+a.speed/2)<=(Math.abs(a.speed)+16)/2+10)return a.killedSomething=!0,b.owners.player.kills+=
1,!1;e=b.owners.player.bombs;g=0;for(c=e.length;g<c;g++)if(a=e[g],Math.abs(this.x-a.x)<=12&&Math.abs(this.y-a.y+a.speed/2)<=Math.abs(a.speed)/2+12)return a.cooldown=0,b.owners.player.kills+=1,!1;e=b.owners.player.shrapnals;g=0;for(c=e.length;g<c;g++)if(a=e[g],Math.abs(this.x-a.x)<=11&&Math.abs(this.y-a.y)<=11)return b.owners.player.kills+=1,!1;return!0};c.prototype.update=function(){this.shootCooldown===0&&this.shoot();this.shootCooldown-=1;this.move();return this.draw()};return c}();I=function(){function c(b,
a){this.x=b;this.y=a;this.moveState=this.shootCooldown=this.angle=0}c.prototype.move=function(){var b;switch(this.moveState){case 0:return Math.abs(this.x-d.x)<150&&Math.abs(this.y-d.y)<150?this.moveState=1:(this.angle=0,this.y+=1);case 1:return b=this.y>d.y?Math.PI-Math.atan((this.x-d.x)/(this.y-d.y)):-Math.atan((this.x-d.x)/(this.y-d.y)),Math.abs(b-this.angle)<Math.PI/24||Math.abs(b-this.angle)>Math.PI*2-Math.PI/24?(this.angle=b,this.moveState=2):this.angle<b&&this.angle-b<Math.PI||Math.PI*2-this.angle-
b<Math.PI?this.angle+=Math.PI/24:this.angle-=Math.PI/24;case 2:return this.x+=30*Math.cos(this.angle+Math.PI/2),this.y+=30*Math.sin(this.angle+Math.PI/2)}};c.prototype.draw=function(){a.translate(this.x,this.y);a.rotate(this.angle);a.beginPath();a.moveTo(-10,-10);a.lineTo(10,-10);a.lineTo(10,4);a.lineTo(0,10);a.lineTo(-10,4);a.closePath();a.stroke();a.rotate(-this.angle);return a.translate(-this.x,-this.y)};c.prototype.alive=function(){var a,g,c,e;if(this.y>f.height||this.moveState&&(this.x<0||this.x>
f.width||this.y<0||this.y>f.height))return!1;if(Math.abs(d.x-this.x)<35&&Math.abs(d.y-this.y)<35)return b.owners.player.kills+=1,b.owners.player.health-=35,b.timers.dispHealth=255,!1;e=b.owners.player.lasers;g=0;for(c=e.length;g<c;g++)if(a=e[g],Math.abs(this.x-a.x)<=12&&Math.abs(this.y-a.y+a.speed/2)<=(Math.abs(a.speed)+16)/2+10)return a.killedSomething=!0,b.owners.player.kills+=1,!1;e=b.owners.player.bombs;g=0;for(c=e.length;g<c;g++)if(a=e[g],Math.abs(this.x-a.x)<=12&&Math.abs(this.y-a.y+a.speed/
2)<=Math.abs(a.speed)/2+12)return a.cooldown=0,b.owners.player.kills+=1,!1;e=b.owners.player.shrapnals;g=0;for(c=e.length;g<c;g++)if(a=e[g],Math.abs(this.x-a.x)<=11&&Math.abs(this.y-a.y)<=11)return b.owners.player.kills+=1,!1;return!0};c.prototype.update=function(){this.move();return this.draw()};return c}();G=function(){function c(a,b){this.x=a;this.y=b;this.bombCooldown=this.angle=0;this.turnVel=(Math.random()-0.5)/30}c.prototype.move=function(){this.x+=2*Math.cos(this.angle+Math.PI/2);this.y+=
2*Math.sin(this.angle+Math.PI/2);this.angle+=this.turnVel;return this.goneOnScreen=0};c.prototype.draw=function(){a.translate(this.x,this.y);a.rotate(this.angle);a.beginPath();a.moveTo(0,14);a.lineTo(5,0);a.lineTo(0,-14);a.lineTo(-5,0);a.closePath();a.stroke();a.rotate(-this.angle);return a.translate(-this.x,-this.y)};c.prototype.bomb=function(){this.bombCooldown=40;return b.owners.enemies.bombs.push(new z(this.x,this.y,4,35,b.owners.enemies))};c.prototype.update=function(){this.bombCooldown===0&&
this.bomb();this.bombCooldown-=1;this.move();return this.draw()};c.prototype.alive=function(){var a,c,i,e;if(this.x<0||this.x>f.width||this.y<0||this.y>f.height){if(this.goneOnScreen)return!1}else this.goneOnScreen=1;if(Math.abs(d.x-this.x)<35&&Math.abs(d.y-this.y)<35)return b.owners.player.health-=24,b.owners.player.kills+=1,b.timers.dispHealth=255,!1;e=b.owners.player.lasers;c=0;for(i=e.length;c<i;c++)if(a=e[c],Math.abs(this.x-a.x)<=12&&Math.abs(this.y-a.y+a.speed/2)<=(Math.abs(a.speed)+16)/2+10)return a.killedSomething=
!0,b.owners.player.kills+=1,!1;e=b.owners.player.bombs;c=0;for(i=e.length;c<i;c++)if(a=e[c],Math.abs(this.x-a.x)<=12&&Math.abs(this.y-a.y+a.speed/2)<=Math.abs(a.speed)/2+12)return a.cooldown=0,b.owners.player.kills+=1,!1;e=b.owners.player.shrapnals;c=0;for(i=e.length;c<i;c++)if(a=e[c],Math.abs(this.x-a.x)<=11&&Math.abs(this.y-a.y)<=11)return b.owners.player.kills+=1,!1;return!0};return c}();A=function(){function b(a,c,d,e){this.x=a;this.y=c;this.speed=d;this.owner=e;this.killedSomething=!1}b.prototype.draw=
function(){a.fillStyle=this.owner.color;return a.fillRect(this.x-1,this.y-8,2,16)};b.prototype.move=function(){return this.y+=this.speed};b.prototype.update=function(){this.move();return this.draw()};return b}();K=function(){function b(a,c,d,e,f){this.x=a;this.y=c;this.angle=d;this.speed=e;this.owner=f;this.cooldown=10}b.prototype.move=function(){this.x+=this.speed*Math.cos(this.angle);return this.y+=this.speed*Math.sin(this.angle)};b.prototype.draw=function(){a.fillStyle=this.owner.color;return a.fillRect(this.x-
1,this.y-1,2,2)};b.prototype.update=function(){this.cooldown-=1;this.move();return this.draw()};return b}();z=function(){function b(a,c,d,e,f){this.x=a;this.y=c;this.speed=d;this.cooldown=e;this.owner=f}b.prototype.move=function(){return this.y+=this.speed};b.prototype.explode=function(){var a;return this.owner.shrapnals=this.owner.shrapnals.concat(function(){var b;b=[];for(a=0;a<=9;a++)b.push(new K(this.x,this.y,a*36*Math.PI/180,10,this.owner));return b}.call(this))};b.prototype.draw=function(){a.fillStyle=
this.owner.color;return a.fillRect(this.x-2,this.y-2,4,4)};b.prototype.update=function(){this.cooldown-=1;this.cooldown<=0&&this.explode();this.move();return this.draw()};return b}();y=function(){a.fillStyle="#FFFFFF";a.font="bold 20px Lucidia Console";a.textAlign="center";return a.textBaseline="middle"};N=function(){a.fillStyle="#FFFFFF";a.font="normal 18px Lucidia Console";a.textAlign="left";return a.textBaseline="bottom"};t=function(){a.fillStyle="#000000";return a.fillRect(0,0,f.width,f.height)};
C=function(){t();y();a.fillText("Tempus [Dev]",f.width/2,f.height/2-12);a.fillText("Click to play",f.width/2,f.height/2+12);N();return a.fillText("by Jake Stothard",10,f.height-10)};L=function(){t();y();a.fillText("Game Over",f.width/2,f.height/2-20);a.font="normal 18px Lucidia Console";a.fillText("Kills - "+b.owners.player.kills,f.width/2,f.height/2);a.fillText("Lasers Fired - "+b.owners.player.lasers_fired,f.width/2,f.height/2+20);return a.fillText("Bombs Used - "+b.owners.player.bombs_fired,f.width/
2,f.height/2+40)};a.strokeStyle="#FFFFFF";a.lineWidth=4;M=function(){$("#enableMusic")[0].checked&&s.play();return v=!1};D=function(){v&&M();d=new J(m.x,m.y);return b={owners:{player:{lasers:[],bombs:[],shrapnals:[],units:d,color:"#0044FF",health:100,kills:0,lasers_fired:0,bombs_fired:0},enemies:{lasers:[],bombs:[],shrapnals:[],units:[],color:"#FF0000"}},timers:{dispHealth:0,colorCycle:0,colorCycleDir:10},crashed:!1}};B=function(){a.beginPath();a.arc(f.width/2,f.height/2,Math.min(f.width,f.height)/
2-20,0,Math.max(b.owners.player.health,0)*Math.PI/50,!1);return a.stroke()};E=function(){n=l.paused;clearInterval(r);B();y();return a.fillText("[Paused]",f.width/2,f.height/2)};F=function(){n=l.playing;return r=u(32,w)};$(document).keyup(function(){switch(event.which){case 80:switch(n){case l.paused:return F();case l.playing:return E()}}});$("#c").mousemove(function(a){m.x=a.pageX-this.offsetLeft;return m.y=a.pageY-this.offsetTop}).mouseout(function(){if(n===l.playing)return E()}).mousedown(function(a){switch(a.which){case 1:return m.leftDown=
!0;case 3:return m.rightDown=!0}}).mouseup(function(a){switch(a.which){case 1:return m.leftDown=!1;case 3:return m.rightDown=!1}}).click(function(){switch(n){case l.paused:return F();case l.title:return n=l.playing,D(),r=u(32,w);case l.gameOver:return n=l.title,C()}}).bind("contextmenu",function(){return!1});$("#enableMusic").change(function(){if(!v)return $("#enableMusic")[0].checked?(s.play(),!0):(s.pause(),!1)});w=function(){var c,o,g,i,e,p,h,k,j,q;if(b.crashed)n=l.crashed,clearInterval(r);else{b.crashed=
!0;b.timers.colorCycle+=b.timers.colorCycleDir;b.timers.colorCycle=Math.min(b.timers.colorCycle,255);b.timers.colorCycle=Math.max(b.timers.colorCycle,0);if(b.timers.colorCycle===0||b.timers.colorCycle===255)b.timers.colorCycleDir*=-1;if(b.owners.player.health<=0)n=l.gameOver,clearInterval(r),L();else{t();j=b.owners.enemies.units;h=0;for(k=j.length;h<k;h++)o=j[h],o.update();b.owners.enemies.units=function(){var a,c,d,e;d=b.owners.enemies.units;e=[];a=0;for(c=d.length;a<c;a++)o=d[a],o.alive()&&e.push(o);
return e}();Math.random()<0.03&&b.owners.player.kills>=0&&b.owners.enemies.units.push(new H(x(0,f.width),-10));Math.random()<0.02&&b.owners.player.kills>=15&&b.owners.enemies.units.push(new I(x(0,f.width),-10));Math.random()<0.01&&b.owners.player.kills>=30&&b.owners.enemies.units.push(new G(x(0,f.width),-10));d.update();j=b.owners;for(e in j){i=j[e];q=i.lasers;h=0;for(k=q.length;h<k;h++)g=q[h],g.update()}j=b.owners.enemies.lasers;h=0;for(k=j.length;h<k;h++)if(g=j[h],Math.abs(d.x-g.x)<=12&&Math.abs(d.y-
g.y+g.speed/2)<=(Math.abs(g.speed)+16)/2+10)g.killedSomething=!0,b.owners.player.health-=8,b.timers.dispHealth=255;j=b.owners.enemies.bombs;h=0;for(k=j.length;h<k;h++)if(c=j[h],Math.abs(d.x-c.x)<=12&&Math.abs(d.y-c.y+c.speed/2)<=Math.abs(c.speed)/2+10)c.cooldown=0,b.owners.player.health-=2,b.timers.dispHealth=255;j=b.owners.enemies.shrapnals;k=0;for(h=j.length;k<h;k++)if(p=j[k],Math.abs(d.x-p.x)<=12&&Math.abs(d.y-p.y+p.speed/2)<=Math.abs(p.speed)/2+10)p.cooldown=0,b.owners.player.health-=2,b.timers.dispHealth=
255;h=b.owners;for(e in h)i=h[e],i.lasers=function(){var a,b,c,d,e;c=i.lasers;e=[];b=0;for(a=c.length;b<a;b++)g=c[b],0<(d=g.y)&&d<f.height&&!g.killedSomething&&e.push(g);return e}();j=b.owners;for(e in j){i=j[e];q=i.bombs;k=0;for(h=q.length;k<h;k++)c=q[k],c.update()}h=b.owners;for(e in h)i=h[e],i.bombs=function(){var a,b,d,e;d=i.bombs;e=[];b=0;for(a=d.length;b<a;b++)c=d[b],c.cooldown>0&&e.push(c);return e}();j=b.owners;for(e in j){i=j[e];q=i.shrapnals;k=0;for(h=q.length;k<h;k++)p=q[k],p.update()}h=
b.owners;for(e in h)i=h[e],i.shrapnals=function(){var a,b,c,d;c=i.shrapnals;d=[];b=0;for(a=c.length;b<a;b++)p=c[b],p.cooldown>0&&d.push(p);return d}();if(m.leftDown&&d.laserCooldown<=0)b.owners.player.lasers_fired+=1,b.owners.player.lasers.push(new A(d.x,d.y,-20,b.owners.player)),d.laserCooldown=d.heat>80?7:d.heat>40?5:2,d.heat+=7;if(m.rightDown&&d.bombCooldown<=0)b.owners.player.bombs_fired+=1,n===l.playing&&b.owners.player.bombs.push(new z(d.x,d.y,-12,20,b.owners.player)),d.bombCooldown=d.heat>
80?20:d.heat>40?10:5,d.heat+=10;d.laserCooldown>0&&(d.laserCooldown-=1);d.bombCooldown>0&&(d.bombCooldown-=1);d.heat>0&&(d.heat-=1);a.textAlign="center";a.textBaseline="bottom";d.heat>80?(a.fillStyle="rgb(".concat(b.timers.colorCycle,",0,0)"),a.font="bold 20px Lucidia Console",a.fillText("[ Heat Critical ]",f.width/2,f.height-30)):d.heat>40?(a.fillStyle="rgb(".concat(b.timers.colorCycle,",",b.timers.colorCycle,",0)"),a.font="normal 18px Lucidia Console",a.fillText("[ Heat Warning ]",f.width/2,f.height-
30)):a.fillStyle="#00FF00";if(b.timers.dispHealth>0)a.strokeStyle="rgb(".concat(b.timers.dispHealth,",",b.timers.dispHealth,",",b.timers.dispHealth,")"),B(),a.strokeStyle="#FFFFFF",b.timers.dispHealth-=10;return b.crashed=!1}}};switch(n){case l.playing:D();r=u(32,w);break;case l.title:C()}}).call(this);
