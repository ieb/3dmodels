/* Quadratic Bezier Curve demonstration
Given three points in a plane a quadratic bezier curve can be created according to the formula 

Quadratic Bezier
B(t)=(1-t)(1-t)p0+2(1-t)(t)p1+(t)(t)p2

see: https://en.wikipedia.org/wiki/B%C3%A9zier_curve
and: https://www.joecridge.me/content/pdf/bezier-arcs.pdf

A good explanation on Bezier Curve van be found here:
https://www.youtube.com/watch?v=Qu-QK3uoMdY
*/

//the radius determines the distance of the bottompoint
radius = 30;
//three points (p0,p1,p2) needed to create the quadratic bezier curve
//four points (p0,p1,p2,p3) needed to create the cubic bezier curve
p0 = [radius,0];
//as an exercise increment the y value of p1 (e.g in steps of 10) 
p1 = [120,90];
p2 = [20,120];

//w determines the width of the line (thickness of the surface)
w = 1;

//deltat determines the stepsize of the 'running variable' t. The smaller the step the smoother the curve
deltat = 0.05;

function bezier(p0,p1,p2, deltat=0.05) = [for (t=[0:deltat:1]) pow(1-t,2)*p0+2*(1-t)*t*p1+pow(t,2)*p2];
    
module line(p1,p2,w) {
    hull() {
        translate(p1) circle(r=w,$fn=20);
        translate(p2) circle(r=w,$fn=20);
    }
}

/*using the, slightly modified, poyline module from JustinSDK (thanks Justin Lin). See his documentation here: https://openhome.cc/eGossip/OpenSCAD/Polyline.html. It's good reading. */
module polyline(points, index, w) {
    if(index < len(points)) {
        line(points[index - 1], points[index],w);
        polyline(points, index + 1, w);
    }
}

module display_control_points() {
    translate(p0) color("red") circle(3);
    translate(p1) color("red") circle(3);
    translate(p2) color("red") circle(3);
    color("red") polyline([p0,p1,p2],1,1);
}

/*   MAIN   */
//demonstrates the quadratic bezier. the Points are 
//indicated with red dots.
display_control_points();
color("blue") polyline(bezier(p0,p1,p2),1,w);