$fn=100;

intersection() {
difference() {
        scale([2,1.5,1])
        translate([-0,0,-15/2])
        cylinder(d=10,h=15);
    translate([-17.5,0,-2.5])
    difference() {
    cube([50,50,5.5]);
        translate([10,-1,-1])
    cube([15,6,10]);
    }

    translate([-25,-50,-25])
    cube([50,50,50]);
};
scale([1,1.6,1])
rotate([0,90,0])
hull() {
    translate([-3,0,-20/2])
    cylinder(d=10,h=20);
    translate([3,0,-20/2])
    cylinder(d=10,h=20);
}
}


