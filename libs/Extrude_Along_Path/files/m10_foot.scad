use <path_extrude.scad>;

// see https://en.wikipedia.org/wiki/ISO_metric_screw_thread

length=30;
D=10; // major diameter
P=1.5; // pitch
H=sqrt(3)/2 * P; // height of triangle
R=H/(P/2);
ppr=15; // points per revolution

loops=length/P;
xw=0.4; // extrude width
fh=3; // foot height
fd=100; // foot diameter
cd=20; // cone diameter

myPoints = [ [-H/2-xw+0.1*R,-P/2+0.1], [1/4*H-xw,-P/8], [1/4*H-xw,P/8], [-H/2-xw+0.1*R,P/2-0.1] ];
myPath = [ for(t = [-(180/loops):(360/(ppr*loops)):360+(180/loops)]) 
    [(D/2)*cos(loops*t),(D/2)*sin(loops*t), P*(loops*t)/360] ];

difference(){
    union(){
        translate([0,0,-xw]) rotate(180) cylinder(h=length+xw*2, r=D/2-3/8*H-xw/2, $fn=ppr);
        path_extrude(points=myPoints, path=myPath);
        translate([0,0,-(fh)]) minkowski(){
            rotate(180) cylinder(r=fd/2-1, h=fh-1, $fn=6);
            sphere(r=1, $fn=8);
        }
        translate([0,0,-xw]) cylinder(r1=cd/2+xw, r2=D/2, h=(cd-D)/2+xw, $fn=60);
    }
    translate([0,0,length+D]) cube([D*2,D*2,D*2], center=true);
    #translate([0,0,length+xw]) rotate_extrude($fn=ppr) polygon([[D/2-2,0],[D/2+2,0],[D/2+2,-4]]);
}
