use <../path_extrude/path_extrude.scad>;

myPoints = [ for(t = [0:12:359]) [3*cos(t-18),3*sin(t-18)] ];
myPath = [ for(t = [0:0.01:1]) [0 + 0.25*cos(5*t*360),0.25*sin(5*t*360),t*5] ];
myScale = [ for(t = [0:0.01:1]) 0.167*(cos(t*360)+1)+0.667 ];

translate([0,0,5-0.001]) cylinder(d=6, h=10.001, $fn=31);
path_extrude(points=myPoints, path=myPath, doRotate=false, doScale=myScale);
