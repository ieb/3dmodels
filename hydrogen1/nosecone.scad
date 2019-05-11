
use <libs/bezier/quadratic_bezier.scad>
use <libs/NACA/shortcuts.scad>
use <libs/NACA/NACA4.scad>

// nose cone radius
ncr = 40;
// nose cone height
nch=65;
// boss radius
br = 10;
// boss height
bh = 30;
// blade angle
angle = 30;
// tip angle
tipAngle = 5;
//$fn=100;
Deltat=0.01;
// 2 = hub body clearnage
// 10 = oil seal housing
// 4 = body aft motor clearance
// 74 = length of motor
// 190 = length of motor mount
// 12.5 = radius of pole
// 15 == offset back from pole
// 50 == offset due to 5% rake
// 600 = height of fin
// 12 = distance from top of fin.
pincenter = [0,2+10+74+4+(190/2)+12.5+15+50,600-12];

spinnercap = true;
spinnerbase = true;
singleblade = true;
leg1 = false;
leg2 = false;
leg3 = false;
leg4 = false;
blade = false;
shaft= true;
aftcasing = false;
frontcasing = false;

ss_version = true;
nonprintable = true;
printable = false;

explode=100;


module nose_cone(r=40,h=65) {
    
    p0 = [r,0]; 
    p1 = [r,h*(50/65)];
    p2 = [0,h];



    pt = [[0,h],[0,0],[r,0]];
    p = concat(bezier(p0=p0,p1=p1,p2=p2,deltat=Deltat),pt);
    //echo(p);
    rotate([90,0,0])
    rotate_extrude()
    polygon(p);
};

module blade_stub(R=10, B=40, H=30, r=2.5, h=5) {
    
    translate([0,0,-B])
    union() {
    cylinder(r=R,h=(H-R));
    translate([0,0,H-R-h-r]) cylinder(r=R+r,h=h);
    //translate([0,0,H-R]) sphere(r=R);
    }
};
module blade_root(R=10, B=40, H=30) {
    //color("green") 
    //translate([0,0,0])
    //cylinder(r=R,h=10);
    
    p0 = [R,0]; 
    p1 = [R,15*(50/65)];
    p2 = [0,20];
    pt = [[0,20],[0,0],[R,0]];
    p = concat(bezier(p0=p0,p1=p1,p2=p2,deltat=Deltat),pt);
    translate([0,0,-B])
    scale([1.5,1])
    color("green") 
    rotate([180,0,0])
    rotate_extrude()
    polygon(p);

}

/*
 R = nose cone radius
 H = node cone height
 r = blade boss radius
 h = blade boss root lenth into boss
*/

module nose_cone_with_blades(R=40, H=65, r=10, h=30) {
        
    difference() {
        nose_cone(r=R, h=H);
        translate([0,-r-5,0])
        union() {
        rotate([0,0,0])
        blade_stub(R=r,B=R,H=h);
        rotate([0,120,0])
        blade_stub(R=r,B=R,H=h);
        rotate([0,-120,0])
        blade_stub(R=r,B=R,H=h);
        }
    }
}

 module tube(od= 20, id=10, l=40, center=true) {
    difference() {
     Cy(r=od,h=l,center=center);
     Cy(r=id,h=l+1,center=center);
    };
};    

module foil(t=15, h=150) {
        // tip shape
        p0 = [0,15]; 
        p1 = [10,10];
        p2 = [10,0];
           
        p4 = [10, -13];
        p5 = [0,-13];

        p = concat(bezier(p0=p0,p1=p1,p2=p2,deltat=Deltat),
                   bezier(p0=p2,p1=p4,p2=p5,deltat=Deltat));
    
        // foil
        difference() {  
            translate([0, -5, -40])
            rotate([180,0,0])
            scale([0.5,0.25,1])
            linear_extrude(height = h, twist = -t, scale = .5)
            translate([-50, 0, 0])
              polygon(points = airfoil_data([-.2, .4, .2])); 


            // remove the tip
            translate([-30,5,-h-30])
                difference() {
                    rotate([90,90,0])
                        cube([20,60,20]);
                    color("red") 
                        translate([30,5,2])
                        rotate([90,90,0])
                        linear_extrude(height=40)
                        polygon(p);
                }
        }

        
}

/*
* R = hub radius
* H = hub height
* r = blade stub radius
* h = blade stub height
* A = angle of attack at root
* a = angle of attach at tip
* tr = tip radius
*/
module blade(R=40, H=65, r=10, h=30, A=20, a=5, tr=220 ) {
    rotate([0,0,180+A])
    difference() {
        union() {
           // foil
            echo(A);
            echo(a);
            foil(t=(A-a),h=(tr-R));
            // boss
            union() {
                blade_stub(R=r,B=R,H=h);
                blade_root(R=r, B=R, H=h);
                difference() {
                    union() {
                        color("red") translate([1,5,-21])
                              rotate([-82,0,-5.1])
                              scale([1.1,2,1])
                                rotate_extrude()
                                  translate([26,0,0])
                                    difference() {
                                        translate([-10,-9])
                                            square([10,4]);
                                        circle(r=11);
                                    }
                        blade_root(R=r, B=R, H=h);
                            color("red") translate([0,-19,-25])
                              rotate([92,0,0])
                              scale([0.91,1.8,1])
                                rotate_extrude()
                                  translate([26,0,0])
                                    difference() {
                                        translate([-10,-15])
                                            square([12,12]);
                                        circle(r=16);
                                    }
                      };
                translate([-50,-50,-40])
                      cube([100,100,100]);
                    }
//                translate([-20.5,9,5])
//                  ring_segment(R=11, r=9, h=10,w1= 270, w2=320);
//                translate([-24.5,-11,5])
//                  ring_segment(R=11, r=8, h=10,w1= 30, w2=60);
//                translate([18,-28,5])
//                  ring_segment(R=27, r=25, h=10,w1= 108, w2=135);
//                translate([12,22,5])
//                  ring_segment(R=27, r=25, h=10,w1= 240, w2=260);
            };
        };
    };

};

module motor() {
    color("black") rotate([90,0,0])
    rotate_extrude()
    polygon([[0,0],[(63/2)-5,0],[63/2,5],[63/2,74-5],[63/2-5,74],[0,74],[0,0]]);
}


module rectifier() {
    color("black")
    translate([16,0,0])
    rotate([0,180,90])
    union() {
        cube([60,32,12]);
        translate([5,4,12])
            cube([6,1,12]);
        translate([30-3,4,12])
            cube([6,1,12]);
        translate([60-5-6,4,12])
            cube([6,1,12]);
        translate([5,32-4-1,12])
            cube([6,1,12]);
        translate([60-5-6,32-4-1,12])
            cube([6,1,12]);
    }
}

module motor_mounting(R=35,r=32,w=5,h=300) {
    echo("Motor Mounting is OD:",(2*R)," ID:",(2*r)," wall:",(R-r));
    pcd45 = sqrt(((45/2)*(45/2))/2);
    color("silver")
    rotate([-90,0,0])
    difference() {
        // 
        cylinder(r=R,h=h);
        // hole for shaft
        translate([0,0,-1])
        cylinder(r=8,h=h+2);
        // slot for wires
        translate([-5,-30,-1])
             cube([10,8,h+2]);
        translate([-5,-26,-1])
             cylinder(r=4,h=h+2);
        translate([5,-26,-1])
            cylinder(r=4,h=h+2);
        // mounting holes
        translate([pcd45,pcd45,-1])
            cylinder(r=2.2,h=h+2);
        translate([-pcd45,pcd45,-1])
            cylinder(r=2.2,h=h+2);
        translate([-pcd45,-pcd45,-1])
            cylinder(r=2.2,h=h+2);
        translate([pcd45,-pcd45,-1])
            cylinder(r=2.2,h=h+2);
        //
        translate([0,0,w])
        cylinder(r=r,h=h-2*w);
        translate([-50,R-10,w])
            cube([100,100,(h-2*w)/2-30]);
        translate([-50,R-10,h/2+30])
            cube([100,100,(h-2*w)/2-30]);
        echo("Slot ",(h-2*w)/2-30);
        // mounting pole
        translate([0,0,(h/2)])
            rotate([90,0,0])
                cylinder(r=12.5,h=600);
        
    }

}

module mounting_pole() {
    echo("Mointing pole OD:25, ID:21, wall:2");
    color("silver")
    difference() {
        translate([0,2+10+74+4+(190/2),30])
        rotate([-5,0,0])
        difference() {
            union() {
                cylinder(r=12.5,h=600);
                translate([-2.5,12.5,9])
                    cube([5,30,600-9]);
            };
            // make it a tube
            translate([0,0,-5])
                cylinder(r=12.5-2,h=610);
            
        }
        pivot_pin();
        translate([-5,2+10+74+4+(190/2)+14,35])
             cube([10,35,6]);
    }
    
}

module leg_bushing() {
       // bushing clearance in pivot, from pole
    // 18mm OD with a M12 clearance hole
    bush_length=15;
    color("silver")
       translate(pincenter)
                 translate([2.5,0,0])
                    rotate([0,90,0])
                      difference() {
                       cylinder(r=9,h=bush_length);
                       translate([0,0,-1])
                       cylinder(r=6,h=bush_length+2);
                      }
    color("silver")
       translate(pincenter)
                 translate([-2.5-bush_length,0,0])
                    rotate([0,90,0])
                      difference() {
                       cylinder(r=9,h=bush_length);
                       translate([0,0,-1])
                       cylinder(r=6,h=bush_length+2);
                      }

}

module side_plates() {
    color("silver")
    difference() {
       translate(pincenter)
        translate([-41/2,75,0])
        difference() {
            union() {
                rotate([0,90,0])
                cylinder(r=95,h=41);
                translate([0,0,-95])
                cube([41,65,95*2]);
            }
            translate([3,-200+90,-96])
                cube([35,160,202]);
            translate([-50,53,-100])
                cube([100,160,202]);
        };
       pivot_pin();
        
    }

        
}

module lift_plate() {
// lift plate
       translate(pincenter)
            difference() {
                 translate([-35/2,0,0])
                    rotate([0,90,0])
                       translate([0,0,0])
                          cylinder(r=95,h=35);
            // groove in lift plate
                 translate([-37/2,0,0])
                    rotate([0,90,0])
                        difference() {
                          cylinder(r=80,h=37);
                          translate([0,0,-1])
                           cylinder(r=70,h=39);
                          translate([0,0,((37-25)/2)])
                            cylinder(r=100,h=25);
                        }
       
        }
}

module bushing_clearance() {
       translate(pincenter)
                        translate([-30,0,0])
                                rotate([0,90,0])
                                        translate([0,0,-1])
                                            cylinder(r=9,h=62);
}

module pivot_pin() {
       translate(pincenter)
            // m12 clearance in pivot
        translate([-25,0,0])
            rotate([0,90,0])
                        cylinder(r=6,h=50);
}


module mounting_leg(b=0, t=150, withSockets=true, withPins=true) {
    difference() {
        union() {
            intersection() {
                difference() {
                    union() {
                        translate([0,2+10+74+4+130,20])
                            rotate([-5,0,0])
                                scale([1,6])
                                    cylinder(r=17,h=600);
                        lift_plate();
                        
                    }
                    // groove in lift plate, to remove from aerofoil section
                    translate(pincenter)
                         translate([-37/2,0,0])
                            rotate([0,90,0])
                                difference() {
                                  cylinder(r=80,h=37);
                                  translate([0,0,-1])
                                   cylinder(r=70,h=39);
                                  translate([0,0,((37-25)/2)])
                                    cylinder(r=100,h=25);
                                };
                   // hole for pull down
                   translate([0,2+10+74+4+(190/2),30])
                         rotate([-5,0,0])
                             translate([-37/2,110,600-100])
                                rotate([0,90,0])
                                      cylinder(r=5,h=37);
                   // hole for pull up
                   translate([0,2+10+74+4+(190/2),30])
                         rotate([-5,0,0])
                             translate([-37/2,-40,600-120])
                                rotate([0,90,0])
                                      cylinder(r=5,h=37);
                    // tube
                    translate([0,2+10+74+4+(190/2),20])
                        rotate([-5,0,0])
                            cylinder(r=12.5,h=900);
                    // space for fin
                    translate([0,2+10+74+4+(190/2),20])
                        rotate([-5,0,0])
                            translate([-2.75,12,0])
                                cube([5.5,32,600]);
                    // bushing clearance in pivot, from pole
                    bushing_clearance();
                };
                // extract the section required.
                translate([-150,0,b+30])
                   cube([300,600,t-b]);
             };
             // add pins
            if ( withPins ) {
                intersection() {
                    union() {
                        translate([0,2+10+74+4+130+70,20])
                            rotate([-5,0,0])
                                    cylinder(r=4.95,h=900);
                        translate([0,2+10+74+4+130-70,20])
                            rotate([-5,0,0])
                                    cylinder(r=4.95,h=900);
                    };
                    translate([-150,0,t+30])
                          cube([300,600,5]);
                }
            }
        };
        // remove sockets
        if ( withSockets ) {
            intersection() {
                union() {
                    translate([0,2+10+74+4+130+70,20])
                        rotate([-5,0,0])
                                cylinder(r=5.05,h=900);
                    translate([0,2+10+74+4+130-70,20])
                        rotate([-5,0,0])
                                cylinder(r=5.05,h=900);
                };
                translate([-150,0,b+30-1])
                    cube([300,600,6]);
            }
        }
    }
}


module drive_plate_screws(r=2.5, h=10, H=5) {
    translate([0,-h,25])
     rotate([-90,0,0])
        union() {
            cylinder(r=r,h=h);
            translate([0,0,-H])
            cylinder(r=8.5/2,h=H);
        }
     rotate([0,120,0])
     translate([0,-h,25])
     rotate([-90,0,0])
        union() {
            cylinder(r=r,h=h);
            translate([0,0,-H])
            cylinder(r=8.5/2,h=H);
        }
     rotate([0,-120,0])
     translate([0,-h,25])
     rotate([-90,0,0])
        union() {
            cylinder(r=r,h=h);
            translate([0,0,-H])
            cylinder(r=8.5/2,h=H);
        }
    }
    
module drive_plate_arm() {
    difference() {
        union() {
            translate([0,-35,0])
                cylinder(r=5,h=1.5);
            translate([-5,-35,0])
                cube([10,35,1.5]);
                cylinder(r=15,h=1.5);
        }
        translate([0,-35,-1])
            cylinder(r=2.1,h=3.5);
        translate([0,0,-1])
            cylinder(r=5,h=3.5);
    }
}

module drive_plate(withPin=true) {
        color("silver") 
      translate([0,-20,0])
        rotate([-90,0,0])
          union() {
              rotate([0,0,0]) drive_plate_arm();
              rotate([0,0,120]) drive_plate_arm();
              rotate([0,0,-120]) drive_plate_arm();
            translate([0,0,-10])
              tube(D=17.7,w=(17.7-10)/2,h=10);
          }
  }
  
  
module drive_pin() {
        // drive pin, 3mm 316 pin
    translate([0,-1.5,-15])
        cylinder(r=1.5,h=30);
}

module spinner_base() {
    color("red")
    translate([-2*explode,0,0])
    difference() {
        translate([0,-2,0])
        difference() {
            nose_cone_with_blades(R=ncr, H=nch, r=br, h=bh);
            difference() {
                translate([-ncr,-nch,-ncr]) cube([ncr*2,nch,ncr*2]);
                translate([-ncr,-br-5,-ncr]) cube([ncr*2,nch,ncr*2]);
            }
            // shaft hole
            translate([0,5,0])
                rotate([90,0,0])
                    color("red") cylinder(r=5,h=nch+10);
            // nut plate
            translate([0,-nch+5,0])
                rotate([90,0,0])
                    color("red") cylinder(r=15,h=20);

        }
        drive_plate(withPin=false);    
        drive_plate_screws(r=2.6, h=10, H=15);
    }
}

module spinner_cap() {
    color("blue")
    translate([-1*explode,-2,0])
    difference() {
        nose_cone_with_blades(R=ncr, H=nch, r=br, h=bh);
        translate([-ncr,-br-5,-ncr]) cube([ncr*2,nch,,ncr*2]);
        translate([0,5,0])
            rotate([90,0,0])
                color("red") cylinder(r=5,h=nch+10);
        translate([0,-nch+5,0])
            rotate([90,0,0])
                color("red") cylinder(r=15,h=20);
    }
}

module aft_case() {
    
    difference() {
        union() {
            // 2mm clearnace between rotor and shaft
            translate([0,2,0])
            rotate([-90,0,0])
            // casing  part 1
            difference() {
                // outer
                union() {
                    cylinder(r=40,h=10+74+4+(190/2));
                    // lip
                    translate([0,0,10+74+4+(190/2)])
                        cylinder(r=40-3,h=5);
                }
        

                // 5 mm wall, 10mm end wall
                translate([0,0,10])
                    cylinder(r=35,h=200);
                // oil seal recess
                echo("Oil Seal is 2x 10x18x4 axial double lip seal https://www.ebay.co.uk/itm/METRIC-OIL-SEAL-CHOOSE-YOUR-SIZE-8MM-to-20MM-INTERNAL-DIAMETER-ALL-IN-STOCK/182994438583");
                translate([0,0,-10])
                    cylinder(r=6,h=30);
                translate([0,0,-11])
                    cylinder(r=9,h=20);
                // 25mm mounting pole, 5 degree rake
                translate([0,0,10+74+4+(190/2)-2])
                    rotate([85,0,0])
                        cylinder(r=12.5,h=600);
                
            };
            difference() {
                union() {
                    mounting_leg(b=0,t=15, withSockets=false);
                    color("red") translate([0,2+10+74+4+130,50])
                      scale([1,6,2])
                        rotate_extrude()
                          translate([26,0,0])
                            difference() {
                                translate([-10,-8])
                                    square([10,5]);
                                circle(r=10);
                            }

                }
                // end slice
                translate([-50,10+74+4+(190/2)+2,0])
                   cube([100,600,100]);
                rotate([-90,0,0])
                    cylinder(r=35,h=600);
            }   
        }
        
        
        // m5 clearance holes for allen head bolts
        translate([0,10+74+4+(190/2)+2-50,0])
            cylinder(r=2.5,h=50);
        
                                echo(" 70mm x 2mm orings https://www.ebay.co.uk/itm/2mm-Section-70mm-Bore-NITRILE-70-Rubber-O-Rings/142124982247?hash=item21174f1fe7:m:mp59y6DOIhBNsvMNQUv_PFw:rk:7:pf:0");
        // 1.8mm recess, 3mm width
         translate([0,2,0])
            rotate([-90,0,0])
                translate([0,0,10+74+4+(190/2)-18])
                    cylinder(r=35+1.8,h=3);
         translate([0,2,0])
            rotate([-90,0,0])
                translate([0,0,10+74+4+(190/2)-24])
                    cylinder(r=35+1.8,h=3);

    }
}

module tube(D=76, w=1.5, h=400) {
    
    difference() {
        cylinder(r=D/2,h=h);
        translate([0,0,-1])
        cylinder(r=(D)/2-w,h=h+2);
    }
}
module disk(D=76, d=18, t=1.5) {
    difference() {
        cylinder(r=D/2,h=t);
        translate([0,0,-1])
            cylinder(r=(d)/2,h=t+2);
    }
}    
module m5allenbolt(l=10 ) {
    union() {
        translate([0,0,-1])
        cylinder(r=2.5,h=l+1);
        translate([0,0,-5])
        cylinder(r=4,h=5);
    }
}
module m4allenbolt(l=10 ) {
    union() {
        translate([0,0,-1])
        cylinder(r=2,h=l+1);
        translate([0,0,0])
        cone(r=3,h=1.65);
    }
}
module m3torx(l=5 ) {
    union() {
        cylinder(r=1.5,h=l);
        rotate_extrude()
            polygon([[0,0],[3.15,0],[0,1.8],[0,0]]);
    }
}
module mounting_cup() {
        color("silver") // 316 ss
    
    difference() {
        union(){
                // 4mm disk
                disk(D=76-3,d=12,t=4);
                // 4mm plate wrapped into cylinder 73mm diameter
                tube(D=73,w=4,h=30);
                translate([-15,-33,10])
                cube([30,1.5,50]);
        }
        rotate([0,0,45])
        translate([0,45/2,-1])
             cylinder(d=2.1,h=3.5);
        rotate([0,0,-45])
             translate([0,45/2,-1])
                cylinder(d=2.1,h=3.5);
        rotate([0,0,-135])
             translate([0,45/2,-1])
                cylinder(d=2.1,h=3.5);
        rotate([0,0,135])
             translate([0,45/2,-1])
                cylinder(d=2.1,h=3.5);
        translate([0,-76/2,-1])
         cylinder(d=25,h=3.5);
        
    }
}
        

module genset() {
   rotate([-90,0,0])
            mounting_cup();
   motor();
   translate([0,60+20,32])
            rectifier();
    
}

module ss_endcap() {
    difference() {
        union() {
            difference() {
                tube(D=(76-3), w=10, h=20);
                translate([0,0,3])
                tube(D=(76-2), w=2.8, h=3);
                translate([0,0,3+5])
                tube(D=(76-2), w=2.8, h=3);
            }
            translate([0,0,20])
                difference() {
                    sphere(d=76);
                    sphere(d=76-23);
                    translate([-50,-50,-100])
                    cube([100,100,100]);
                }
        }
        // 3x m3 threaded torx, M3x10
        // minimal stress
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
        rotate([0,0,120])
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
        rotate([0,0,-120])
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
        
    }
}

module ss_case() {
    color("grey") // mostly 316 ss
    translate([0,2,0])
    rotate([-90,0,0])
    difference() {
        union() {
            tube(D=76, w=1.5,h=310);
            // weld to oil seal cap and then onto body.
            disk(D=76, d=18, t=1.5);
            // weld to base of oil seal
            tube(D=18+3, w=1.5,h=11.5);
            // base of oil seal holder
            translate([0,0,10])
                disk(D=18, d=12, t=1.5);
            // leg tube, welded to body
            translate([0,-73/2,2+10+4+74+100])
                rotate([85,0,0])
                    tube(D=25,w=1.5,h=600);
            // leg cover, 1.5mm sheet wrapped
            // may be able to make it out of a squashed tube,
            // or use CF covered foam
            difference() {
                translate([0,10-73/2,2+10+4+74+100])
                    rotate([85,0,0])
                        scale([1,6])
                        tube(D=28,w=1.5,h=600);
                                translate([0,0,50])
                        cylinder(d=76,h=300);
            }
            

        // fixing screws         translate([0,10+4+74+120-40,0])

           
        }
        translate([0,2-73/2,2+10+4+74+100])
            rotate([85,0,0])
                cylinder(d=25-3,h=5.5);
        // m3 torx screws to fix end cap
        translate([0,0,290+15])
            {
                rotate([0,0,60])
                translate([0,76/2,0])
                    rotate([90,0,0])
                        m3torx(l=8);
                rotate([0,0,-60])
                translate([0,76/2,0])
                    rotate([90,0,0])
                        m3torx(l=8);
                rotate([0,0,180])
                translate([0,76/2,0])
                    rotate([90,0,0])
                        m3torx(l=8);
            }
        // gen 1fixing
        translate([0,0,10+4+74+15])
            {
                rotate([0,0,0])
                translate([0,76/2,0])
                    rotate([90,0,0])
                        m3torx(l=8);
                rotate([0,0,-120])
                translate([0,76/2,0])
                    rotate([90,0,0])
                        m3torx(l=8);
                rotate([0,0,120])
                translate([0,76/2,0])
                    rotate([90,0,0])
                        m3torx(l=8);
            }
            
            // gen2 fixing
            translate([0,0,10+4+74+120-15])
            {
                rotate([0,0,0])
                translate([0,76/2,0])
                    rotate([90,0,0])
                        m3torx(l=28);
                rotate([0,0,-120])
                translate([0,76/2,0])
                    rotate([90,0,0])
                        m3torx(l=8);
                rotate([0,0,120])
                translate([0,76/2,0])
                    rotate([90,0,0])
                        m3torx(l=8);
            }



    }


    // motor mounted on cradle
    // 3mm of material to secure the cradle with
    // countersunk
    translate([0,2+10+4+74,0])
        rotate([0,60,0])
            genset();
    // fixing screws 
          color("red")
    translate([0,2+10+4+74,0])
    rotate([-90,0,0]) {
        rotate([0,0,60])
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
        rotate([0,0,-60])
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
        rotate([0,0,180])
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
    }


    // motor mounted on cradle
    translate([0,2+10+4+74+120,0])
        rotate([180,120,0])
            genset();
    
    // fixing screws
    color("red")
    translate([0,2+10+4+74+120-30,0])
    rotate([-90,0,0]) {
        rotate([0,0,60])
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
        rotate([0,0,-60])
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
        rotate([0,0,180])
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
    }

    // there are 1.5mm housing and 4mm of material to fix
    // the motor holders into the body. Should use M3 countersunk torx head https://www.accu.co.uk/en/hexalobular-countersunk-screws/474332-SHK-M3-8-V2-A4
    // 3 per holder
    
    
    // end cap
    translate([0,292,0])
    rotate([-90,0,0])
    ss_endcap();
        // 3x m3 threaded torx, M3x10
        // minimal stress
       color("red")
    translate([0,292,0])
    rotate([-90,0,0]) {
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
        rotate([0,0,120])
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
        rotate([0,0,-120])
        translate([0,-76/2,15])
            rotate([-90,0,0])
                m3torx(l=8);
    }


}

module front_case() {
        // casing part 2, with dome nose
    // needs seal arrangement
    h = 170;

    difference() {

        union() {
            translate([0,2+10+74+4+(190/2),0])
            rotate([-90,0,0])
            difference() {
                // outer
                union() {
                    cylinder(r=40,h=h);
                    translate([0,0,h]) sphere(r=40);
                };
                // remove the lip
                cylinder(r=40-3,h=5);
                
                rotate_extrude()
                  translate([5,0,0])
                    circle(r=5);

                // 5 mm wall
                translate([0,0,-5])
                union() {
                    cylinder(r=35,h=h+5);
                    translate([0,0,h+5]) sphere(r=35);
                }
                // mounting pole, 5 degree rake
                translate([0,0,0])
                    rotate([85,0,0])
                      union() {
                        cylinder(r=12.5,h=600);
                      }
            };
            difference() {
                union() {
                mounting_leg(b=0,t=15, withSockets=false);
                color("red") translate([0,2+10+74+4+130,50])
                  scale([1,6.2,2])
                    rotate_extrude()
                      translate([26,0,0])
                        difference() {
                            translate([-10,-8])
                                square([10,5]);
                            circle(r=10);
                        }
                }
                // end slice
                translate([-50,0,0])
                   cube([100,10+74+4+(190/2)+2,100]);
                rotate([-90,0,0])
                    cylinder(r=35,h=600);
                // clear the back fin material
                    // space for fin
            };
        }
        // m5 clearance holes for allen head bolts
        translate([0,10+74+4+(190/2)+2+55,0])
            cylinder(r=2.5,h=50);
        translate([0,10+74+4+(190/2)+2+80,0])
            cylinder(r=2.5,h=50);
         translate([0,2,0])
            rotate([-90,0,0])
                translate([0,0,10+74+4+(190/2)+18])
                    cylinder(r=35+1.8,h=3);
         translate([0,2,0])
            rotate([-90,0,0])
                translate([0,0,10+74+4+(190/2)+24])
                    cylinder(r=35+1.8,h=3);
    }
}



difference() {
    union() {

// part 1
if (spinnercap || printable) {
    spinner_cap();
}


// part 2
if ( spinnerbase || printable) {
    spinner_base();
}
if ( singleblade || printable) {
    translate([-3*explode,-br-5-2,0])
    rotate([0,0,0])
    blade(R=ncr, H=nch, r=br, h=bh, A=angle, a=tipAngle);
}

if ( nonprintable ) {
    
    translate([-3*explode,-br-5-2,0])
    rotate([0,0,0])
    blade(R=ncr, H=nch, r=br, h=bh, A=angle, a=tipAngle);
    translate([-3*explode,-br-5-2,0])
    rotate([0,120,0])
    blade(R=ncr, H=nch, r=br, h=bh, A=angle, a=tipAngle);
    translate([-3*explode,-br-5-2,0])
    rotate([0,-120,0])
    blade(R=ncr, H=nch, r=br, h=bh, A=angle, a=tipAngle);

}
if (nonprintable) {
    // 10mm shaft
    difference() {
    color("silver") translate([0,-nch-5,0])
        rotate([-90,0,0])
        cylinder(r=5,h=2+10+74+4+190+nch+5+74+2);
        // drill drive pin
        drive_pin();
        translate([0,-1.5,-15])
            cylinder(r=1.5,h=30);
    }
}
if ( ss_version ) {
    translate([2.5*explode,0,0])
        ss_case();
    translate([0.5*explode,0,0])
        drive_plate();    
    translate([1*explode,0,0])
        drive_plate_screws();    
    translate([1.5*explode,0,0])
        drive_pin();    
    
} else {
    if ( nonprintable ) {
        drive_plate();    
        drive_plate_screws();
        color("red") drive_pin();
        // 2 casing offset
        // 10 casing wall end plate
        // 74 motor length
        // 4 clearance
        //

        translate([0,2+10+74+4,0])
        motor();
        
        // motors are back to back,
        // 190 is the motor mount holder length,
        // potentially quite a long shaft
        translate([0,2+10+74+4+190,0])
        rotate([180,0,0])
        motor();
        
        translate([0,2+10+74+4+20,32])
            rectifier();
        translate([0,2+10+74+4+190-60-20,32])
            rectifier();    

        // 70mm od tube fitting inside casing
        // offset to the face of the aft motor mount
        translate([3*explode,0,0])
        union() {
            translate([0,2+10+74+4,0])
                motor_mounting(R=35,r=32,w=5,h=190);
            // mounting pole
            mounting_pole();
        }
    }
    if (aftcasing || printable) {
        translate([2*explode,0,0])
        aft_case();
    }
    if (frontcasing || printable) {
        //color("green")
        translate([explode,0,0])
        front_case();

    }
    if ( nonprintable ) {
    // leg secton 1, 1mm gasket between body and ley section 1
    color("black") translate([3.5*explode,0,0]) 
      mounting_leg(b=15,t=16, withPins=false);
    }
    if ( leg1 || printable) {
    // sections
    translate([4*explode,0,0]) 
      mounting_leg(b=16,t=150);
    }
    if ( leg2 || printable) {
        
    translate([4.5*explode,0,0]) 
      mounting_leg(b=150,t=300);
    }
    if ( leg3 || printable) {
    translate([5*explode,0,0]) 
      mounting_leg(b=300,t=450);
    }
    if ( leg4 || printable) {
    translate([5.5*explode,0,0]) 
      mounting_leg(b=450,t=650, withPins=false);
    }
}
}; // end uinion
// section tool
if ( nonprintable ) {
    color("green",0.1)
    translate([-100,-100,-200])
    cube([100,500,400]);
}

}

if ( nonprintable ) {
    translate([3*explode,0,0]) 
    leg_bushing();
    translate([6*explode,0,0]) 
    side_plates();
    translate([7*explode,0,0]) 
    pivot_pin();
}






