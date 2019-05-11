use <path_extrude.scad>;

// see https://en.wikipedia.org/wiki/ISO_metric_screw_thread

length=8;
P=2; // pitch
H=sqrt(3)/2 * P; // height of triangle
R=H/(P/2);
ppr=30; // points per revolution

loops=length/P;
D=16;
xw=0.4; // extrude width

myPoints = [ [-H/2+xw+0.1*R,-P/2+0.1], [1/4*H+xw,-P/8], [1/4*H+xw,P/8], [-H/2+xw+0.1*R,P/2-0.1] ];
myPath = [ for(t = [-(180/loops):(360/(ppr*loops)):360+(180/loops)]) 
    [(D/2)*cos(loops*t),(D/2)*sin(loops*t), P*(loops*t)/360] ];

difference(){
    translate([0,0,1]) minkowski(){
            rotate(180) cylinder(r=(24 / cos(30) - xw)/2-1, h=length-2, $fn=6);
            sphere(r=1, $fn=8);
    }
    translate([0,0,-xw]) rotate(180) cylinder(r=D/2-3/8*H+xw, $fn=ppr, h=length+xw*2);
    path_extrude(points=myPoints, path=myPath);
}