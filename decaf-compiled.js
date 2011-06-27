(function(){var x,y,v,z,A,j,e,q,a,k,m,r,f,s,h,t,u,B,C,w,c,i,n;e=document.getElementById("c");a=e.getContext("2d");if(!a)throw"Loading context failed";h=[];m=[];j=[];i=[];t=250;u=200;q=!1;n=void 0;f={title:"Title",playing:"Playing",paused:"Paused",crashed:"Crashed"};k=f.title;z=function(){function b(a,b){this.x=a;this.y=b}b.prototype.move=function(){c.x=(c.x+t)/2;return c.y=(c.y+u)/2};b.prototype.draw=function(){a.strokeStyle="#FFFFFF";a.beginPath();a.moveTo(this.x,this.y-20);a.quadraticCurveTo(this.x+
20,this.y,this.x+20,this.y+20);a.quadraticCurveTo(this.x+5,this.y+10,this.x,this.y+10);a.quadraticCurveTo(this.x-5,this.y+10,this.x-20,this.y+20);a.quadraticCurveTo(this.x-20,this.y,this.x,this.y-20);a.closePath();return a.stroke()};b.prototype.update=function(){this.move();return this.draw()};return b}();y=function(){function b(a,b){this.x=a;this.y=b;this.shootCooldown=0}b.prototype.draw=function(){a.strokeStyle="#FFFFFF";a.beginPath();a.moveTo(this.x-10,this.y-10);a.lineTo(this.x+10,this.y-10);
a.lineTo(this.x,this.y+10);a.closePath();return a.stroke()};b.prototype.move=function(){var a;this.y+=3;a=(c.x-this.x)/12;return this.x+=Math.abs(a)<5?a:5*a/Math.abs(a)};b.prototype.shoot=function(){this.shootCooldown=35;return h.push(new v(this.x,this.y,30,"#FF0000"))};b.prototype.alive=function(){var a,b,g;if(this.y>e.height)return!1;if(Math.abs(c.x-this.x)<35&&Math.abs(c.y-this.y)<35)return!1;b=0;for(g=h.length;b<g;b++)if(a=h[b],a.color!=="#FF0000"&&Math.abs(this.x-a.x)<=12&&Math.abs(this.y-a.y+
a.speed/2)<=(Math.abs(a.speed)+16)/2+10)return a.killedSomething=!0,!1;b=0;for(g=j.length;b<g;b++)if(a=j[b],a.color!=="#FF0000"&&Math.abs(this.x-a.x)<=12&&Math.abs(this.y-a.y+a.speed/2)<=Math.abs(a.speed)/2+12)return a.cooldown=0,!1;b=0;for(g=i.length;b<g;b++)if(a=i[b],a.color!=="#FF0000"&&Math.abs(this.x-a.x)<=11&&Math.abs(this.y-a.y)<=11)return!1;return!0};b.prototype.update=function(){this.shootCooldown===0&&this.shoot();this.shootCooldown-=1;this.move();return this.draw()};return b}();(function(){function b(a,
b){this.x=a;this.y=b;this.shootCooldown=this.angle=0}b.prototype.move=function(){return Math.abs(this.x-c.x)<150&&Math.abs(this.y-c.y)<150?(this.angle=this.y>c.y?Math.PI-Math.atan((this.x-c.x)/(this.y-c.y)):-Math.atan((this.x-c.x)/(this.y-c.y)),this.x+=(c.x-this.x)/4,this.y+=(c.y-this.y)/4):(this.angle=0,this.y+=1)};b.prototype.draw=function(){a.translate(this.x,this.y);a.rotate(this.angle);a.beginPath();a.moveTo(-10,-10);a.lineTo(10,-10);a.lineTo(10,4);a.lineTo(0,10);a.lineTo(-10,4);a.closePath();
a.stroke();a.rotate(-this.angle);return a.translate(-this.x,-this.y)};b.prototype.update=function(){this.move();return this.draw()};return b})();v=function(){function b(a,b,c,d){this.x=a;this.y=b;this.speed=c;this.color=d;this.killedSomething=!1}b.prototype.draw=function(){a.fillStyle=this.color;return a.fillRect(this.x-1,this.y-8,2,16)};b.prototype.move=function(){return this.y+=this.speed};b.prototype.update=function(){this.move();return this.draw()};return b}();A=function(){function b(a,b,c,d,
e){this.x=a;this.y=b;this.angle=c;this.speed=d;this.color=e;this.cooldown=10}b.prototype.move=function(){this.x+=this.speed*Math.cos(this.angle);return this.y+=this.speed*Math.sin(this.angle)};b.prototype.draw=function(){a.fillStyle=this.color;return a.fillRect(this.x-1,this.y-1,2,2)};b.prototype.update=function(){this.cooldown-=1;this.move();return this.draw()};return b}();x=function(){function b(a,b,c,d){this.x=a;this.y=b;this.speed=c;this.color=d;this.cooldown=20}b.prototype.move=function(){return this.y+=
this.speed};b.prototype.explode=function(){var a;return i=i.concat(function(){var b;b=[];for(a=0;a<=9;a++)b.push(new A(this.x,this.y,a*36*Math.PI/180,this.speed,this.color));return b}.call(this))};b.prototype.draw=function(){a.fillStyle=this.color;return a.fillRect(this.x-2,this.y-2,4,4)};b.prototype.update=function(){this.cooldown-=1;this.cooldown<=0&&this.explode();this.move();return this.draw()};return b}();B=function(a,c){return Math.floor(Math.random()*(c-a+1))+a};w=function(){a.fillStyle="#FFFFFF";
a.font="bold 20px Lucidia Console";a.textAlign="center";return a.textBaseline="middle"};C=function(){a.fillStyle="#FFFFFF";a.font="normal 18px Lucidia Console";a.textAlign="left";return a.textBaseline="bottom"};a.fillStyle="#000000";a.strokeStyle="#FFFFFF";a.fillRect(0,0,e.width,e.height);a.lineWidth=4;c=new z(t,u);$(document).keyup(function(){console.log(event.which);switch(event.which){case 80:switch(k){case f.paused:return k=f.playing,n=r(32,s);case f.playing:return k=f.paused,clearInterval(n),
w(),a.fillText("[Paused]",e.width/2,e.height/2)}}});$("#c").mousemove(function(a){t=a.pageX-this.offsetLeft;return u=a.pageY-this.offsetTop}).click(function(){switch(k){case f.playing:return h.push(new v(c.x,c.y,-30,"#0044FF"));case f.title:return k=f.playing,n=r(32,s)}}).bind("contextmenu",function(){k===f.playing&&j.push(new x(c.x,c.y,-12,"#0044FF"));return!1});r=function(a,c){return setInterval(c,a)};s=function(){var b,p,o,g,d,l;if(q)k=f.crashed;if(!f.playing)return clearInterval(n);q=!0;a.fillStyle=
"#000000";a.fillRect(0,0,e.width,e.height);d=0;for(l=m.length;d<l;d++)p=m[d],p.update();m=function(){var a,b,c;c=[];a=0;for(b=m.length;a<b;a++)p=m[a],p.alive()&&c.push(p);return c}();Math.random()<0.05&&m.push(new y(B(0,e.width),-10));c.update();d=0;for(l=h.length;d<l;d++)o=h[d],o.update();h=function(){var a,b,c,d;d=[];a=0;for(b=h.length;a<b;a++)o=h[a],0<(c=o.y)&&c<e.height&&!o.killedSomething&&d.push(o);return d}();d=0;for(l=j.length;d<l;d++)b=j[d],b.update();j=function(){var a,c,d;d=[];a=0;for(c=
j.length;a<c;a++)b=j[a],b.cooldown>0&&d.push(b);return d}();d=0;for(l=i.length;d<l;d++)g=i[d],g.update();i=function(){var a,b,c;c=[];b=0;for(a=i.length;b<a;b++)g=i[b],g.cooldown>0&&c.push(g);return c}();return q=!1};a:switch(k){case f.playing:n=r(32,s);break a;case f.title:w(),a.fillText("Tempus [Dev]",e.width/2,e.height/2-12),a.fillText("Click to play",e.width/2,e.height/2+12),C(),a.fillText("by Jake Stothard",10,e.height-10)}}).call(this);
