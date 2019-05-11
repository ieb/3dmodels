                   .:                     :,                                          
,:::::::: ::`      :::                   :::                                          
,:::::::: ::`      :::                   :::                                          
.,,:::,,, ::`.:,   ... .. .:,     .:. ..`... ..`   ..   .:,    .. ::  .::,     .:,`   
   ,::    :::::::  ::, :::::::  `:::::::.,:: :::  ::: .::::::  ::::: ::::::  .::::::  
   ,::    :::::::: ::, :::::::: ::::::::.,:: :::  ::: :::,:::, ::::: ::::::, :::::::: 
   ,::    :::  ::: ::, :::  :::`::.  :::.,::  ::,`::`:::   ::: :::  `::,`   :::   ::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  :::::: ::::::::: ::`   :::::: ::::::::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  .::::: ::::::::: ::`    ::::::::::::::: 
   ,::    ::.  ::: ::, ::`  ::: ::: `:::.,::   ::::  :::`  ,,, ::`  .::  :::.::.  ,,, 
   ,::    ::.  ::: ::, ::`  ::: ::::::::.,::   ::::   :::::::` ::`   ::::::: :::::::. 
   ,::    ::.  ::: ::, ::`  :::  :::::::`,::    ::.    :::::`  ::`   ::::::   :::::.  
                                ::,  ,::                               ``             
                                ::::::::                                              
                                 ::::::                                               
                                  `,,`


https://www.thingiverse.com/thing:186660
Extrude Along Path by gringer is licensed under the Creative Commons - Attribution - Share Alike license.
http://creativecommons.org/licenses/by-sa/3.0/

# Summary

OpenSCAD script to generate the polyhedron that is formed by extruding a polygon along a specified path. List comprehensions allow the path and polygon points to be specified parametrically.

# Instructions

This is a native OpenSCAD implementation of path extrusion.

A polygon is specified as a set of points in 2D space, and a path is specified as a set of points in 3D space. The extrusion script copies the 2D origin-centred polygon along each of the points along the path, rotating each copy around the origin to face the next point on the path, and to be oriented in such a way that the first point on the polygon matches up (as close as possible) with the same point on the next copy.

See the script 'path_extrude.scad' for the most recent version (v2), implementing the above algorithm.

The Perl code (and v1 code) that was previously used for doing this has been included to show something of the history of the script / concept. It also helps me to know how many people blindly download everything vs just downloading the library code (path_extrude.scad).

OpenSCAD Code examples
--

**Pentagon spiral**

    use <path_extrude.scad>;
    myPoints = [ for(t = [0:72:359]) [cos(t-18),sin(t-18)] ];
    myPath = [[-1,0,0],[1,0,0],[2,1,0.5],[2,3,1.5],
        [1,4,2],[-1,4,3],[-2,3,3.5],[-2,1,4.5],[-1,0,5]];
    path_extrude(exShape=myPoints, exPath=myPath);

**Double rotated spiral**

    use <path_extrude.scad>;
    pi=3.14159;
    myPoints = [ for(t = [0:90:359]) [cos(t+45),sin(t+45)] ];
    myPath = [ for(t = [0:3.6:360])
        [5*cos(2*t),5*sin(2*t), (t<90)?0:((t-90) * 4*pi/180)] ];
    path_extrude(exShape=myPoints, exPath=myPath);


**Trefoil knot spinning top**

This uses the Wikipedia trefoil knot equation, with a bit of squash on the X and Y direction to improve printability:  
[https://en.wikipedia.org/wiki/Trefoil_knot  ]   

    use <path_extrude.scad>;
    myPoints = [ for(t = [0:18:359]) 2.5*[cos(t),sin(t)] ];
    // https://en.wikipedia.org/wiki/Trefoil_knot
    myPath = [ for(t = [0:3.6:359]) [
        4*(sin(t) + 2*sin(2*t)),
        4*(cos(t) - 2*cos(2*t)),
        5*(-sin(3*t))] ];
    path_extrude(exPath=myPath, exShape=myPoints, merge=true);
    cylinder(d1=10, d2=2, h=10, $fn=50);
    translate([0,0,9.8]) sphere(d=2, $fn=48);

**Double Helix**

    use <path_extrude.scad>;
    shift=0;
    pi=3.14159;
    for(shift = [0, 360/15]){
        myPoints = [ for(t = [0:72:359]) [cos(t),sin(t)] ];
        myPath = [ for(t = [0:10:359]) [
            (10+1.212*pi*sin(5*t))*cos(t+shift),
            (10+1.212*pi*sin(5*t))*sin(t+shift),
            1.212*pi*cos(5*t)
            ] ];
        path_extrude(exShape=myPoints, exPath=myPath, merge=true);
    }

This is intended to simulate a right-handed DNA backbone with major/minor groove width of {1/3,2/3}, 5 turns per loop, 10 bases per turn, helix radius of 1/3.3 times the arc length of a single turn. The ring radius was 15 in this example.

** M16 Bolt **

see [ https://en.wikipedia.org/wiki/ISO_metric_screw_thread ]

Note that for the bolt thread to extrude properly, I need to bypass the rotation correction algorithm.

    use <path_extrude.scad>;
    length=30;
    P=2; // pitch
    H=sqrt(3)/2 * P; // height of triangle
    R=H/(P/2);
    ppr=20; // points per revolution
    loops=length/P;
    D=16;
    xw=0.4; // extrude width
    
    myPoints = [ [-H/2-xw+0.1*R,-P/2+0.1], [1/4*H-xw,-P/8], [1/4*H-xw,P/8],
        [-H/2-xw+0.1*R,P/2-0.1] ];
    myPath = [ for(t = [-(180/loops):(360/(ppr*loops)):360+(180/loops)]) 
        [(D/2)*cos(loops*t),(D/2)*sin(loops*t), P*(loops*t)/360] ];
    
    difference(){
        union(){
            translate([0,0,-xw]) rotate(180) cylinder(h=length+xw*2, r=D/2-3/8*H-xw/2, $fn=ppr);
            path_extrude(exShape=myPoints, exPath=myPath, exRots=[for(i = [1:(length*ppr)]) 0]);
            translate([0,0,-7]) minkowski(){
                rotate(180) cylinder(r=(24 / cos(30) - xw)/2-1, h=6, $fn=6);
                sphere(r=1, $fn=8);
            }
        }
        translate([0,0,length-2]) rotate_extrude($fn=60)
            polygon([[D/2-4,4],[D/2+4,4],[D/2+4,-2]]);
    
    }

** M16 Nut **

    use <path_extrude.scad>;
    
    length=8;
    P=2; // pitch
    H=sqrt(3)/2 * P; // height of triangle
    R=H/(P/2);
    ppr=30; // points per revolution
    loops=length/P;
    D=16;
    xw=0.4; // extrude width
    
    myPoints = [ [-H/2+xw+0.1*R,-P/2+0.1], [1/4*H+xw,-P/8],
        [1/4*H+xw,P/8], [-H/2+xw+0.1*R,P/2-0.1] ];
    myPath = [ for(t = [-(180/loops):(360/(ppr*loops)):360+(180/loops)]) 
        [(D/2)*cos(loops*t),(D/2)*sin(loops*t), P*(loops*t)/360] ];
    
    difference(){
        translate([0,0,1]) minkowski(){
                rotate(180) cylinder(r=(24 / cos(30) - xw)/2-1, h=length-2, $fn=6);
                sphere(r=1, $fn=8);
        }
        translate([0,0,-xw]) rotate(180) cylinder(r=D/2-3/8*H+xw, $fn=ppr, h=length+xw*2);
        path_extrude(exShape=myPoints, exPath=myPath);
    }

** Worm Gear **

    use <path_extrude.scad>;
    
    myPoints = [ for(t = [0:12:359]) [3*cos(t-18),3*sin(t-18)] ];
    myPath = [ for(t = [0:0.01:1]) [0 + 0.25*cos(5*t*360),0.25*sin(5*t*360),t*5] ];
    myScale = [ for(t = [0:0.01:1]) 0.167*(cos(t*360)+1)+0.667 ];

    translate([0,0,5-0.001]) cylinder(d=6, h=10.001, $fn=31);
    path_extrude(exShape=myPoints, exPath=myPath, doRotate=false, doScale=myScale);

Animation
--

Of course, native OpenSCAD code means that this path extrusion can now be animated:

[Animated Trefoil Knot](http://i.imgur.com/G6jrMT3.gifv)