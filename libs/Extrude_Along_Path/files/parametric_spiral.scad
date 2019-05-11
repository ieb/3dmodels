use <path_extrude.scad>;

pi=3.14159;

myPoints = [ for(t = [0:90:359]) [cos(t+45),sin(t+45)] ];
myPath = [ for(t = [0:3.6:360]) 
    [5*cos(2*t),5*sin(2*t), (t<90)?0:((t-90) * 4*pi/180)] ];

path_extrude(points=myPoints, path=myPath);
