$fn=100;
module top() {
    union() {
    translate([0,0,-5])
    cylinder(d=4,h=10);
difference() {
    scale([2,2,1])
        sphere(d=18);
    translate([0,0,-4])
        cylinder(d=24,h=30);
    translate([-12,0,-4])
    cylinder(d=4,h=50);
}
}
}

module bottom() {
difference() {
    scale([1.5,1.5,1])
        sphere(d=21);
    translate([0,0,-15])
        cylinder(d=24,h=30);
    translate([-12,0,-10])
    cylinder(d=4,h=50);
}
}

bottom();

