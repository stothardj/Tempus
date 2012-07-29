// Make it impossible to select text since this steals focus from game
if (typeof document.body.onselectstart !== "undefined") //IE route
    document.body.onselectstart=function(){return false;};
else if (typeof document.body.style.MozUserSelect !== "undefined") //Firefox route
    document.body.style.MozUserSelect="none";
else //All other route (ie: Opera)
    document.body.onmousedown=function(){return false;}
