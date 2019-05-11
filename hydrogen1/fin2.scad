// Sampler.scad - library for parametric airfoils of 4 digit NACA series
// Code: Rudolf Huttary, Berlin 
// June 2015
// commercial use prohibited

 use <libs/NACA/shortcuts.scad>  // see: http://www.thingiverse.com/thing:644830
 use <libs/NACA/naca4.scad>
 
 
 module tube(od= 20, id=10, l=40, center=true) {
    difference() {
     Cy(r=od,h=l,center=center);
     Cy(r=id,h=l+1,center=center);
    };
};    

// duct
//  T(50, 30, 0)
//  rotate_extrude($fn = 100)
//  translate([30, 100, 0])
//  R(0, -180, 90)
//  polygon(points = airfoil_data([-.1, .4, .1], L=100)); 

// drop
//T(50, 30, 0)
//scale([1, 2])
//rotate_extrude()
//Rz(90)
//difference()
//{
//  polygon(points = airfoil_data(30)); 
//  square(100, 100); 
//}

// some winding airfoils
//linear_extrude(height = 100, twist = 30, scale = .5)
//  polygon(points = airfoil_data(30)); 

//translate([50, 0, 0])
//linear_extrude(height = 100, twist = 30, scale = .5)
//translate([-50, 0, 0])
//  polygon(points = airfoil_data(30)); 
$fn=50;

difference() {
    union() {
       // foil
        translate([0, 0, 0])
        scale([0.5,0.25,1])
        linear_extrude(height = 150, twist = -15, scale = .5)
        translate([-50, 0, 0])
          polygon(points = airfoil_data([-.2, .4, .2])); 
        // boss
        difference() {
            union() {
                translate([-8,-5,-5])
                 Cy(r=10,h=30,center=true);
                    // lock
                translate([-8,-5,-15])
                 Cy(r=12.5,h=5,center=true);
                translate([-8,-5,-20])
                    sphere_half(r=10);
                translate([-20.5,9,5])
                  ring_segment(R=11, r=9, h=10,w1= 270, w2=320);
                translate([-24.5,-11,5])
                  ring_segment(R=11, r=8, h=10,w1= 30, w2=60);
                translate([18,-28,5])
                  ring_segment(R=27, r=25, h=10,w1= 108, w2=135);
                translate([12,22,5])
                  ring_segment(R=27, r=25, h=10,w1= 240, w2=260);
            };
            scale([1,1,1.2])
            translate([-5,-5,0])
            difference() {
                translate([-20,-10,0])
                    cube([40,20,20]);
                translate([0,0,-1])
                scale([2,1])
                        sphere_half(r=10, w1=180);
            };
        }    
    };

    translate([-4,0,110])
    difference() {
        translate([-30,-15,2])
        cube([80,30,40]);
        scale([2,1,4])
              sphere_half(r=10, w1=180);
    }

};






        // fillet
/*        translate([-220,-9,0])
        intersection() {
            tube(od=10, id=5, l=25);
            translate([2,2,0])
            union() {
            cube([3,5,10]);
            };
        }*/

//T(30)
// airfoil(naca = 2432, L = 60, N=101, h = 30, open = false); 

// some airfoil objects, Naca values defined with number or vector
// airfoil ();                  // NACA12 object 
// airfoil (2417);              // NACA2417 object 
// airfoil ([.2, .4, .17]);     // NACA2417 object 
// airfoil ([-.10101, .52344, .17122]); // inverted precise curvature

help();  // show help in console

// end of sampler






