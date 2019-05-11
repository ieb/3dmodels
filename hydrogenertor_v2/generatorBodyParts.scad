use <libs/bezier/quadratic_bezier.scad>

$fn=100;
Deltat=0.01;

module bearing_endcap() {
    difference() {
        union() {
            // cap
            cylinder(d=76,h=4);
            // socket
            translate([0,0,4])
               cylinder(d=65,h=20);
        }
       // shaft hole
       translate([0,0,-1])
        cylinder(d=15,h=28);
       // bearing hole, 6mm base
       translate([0,0,6])
            cylinder(d=26,h=25);

        
    }
}

module nose_cone() {
    union() {
        difference() {
            sphere(d=76, center=true);
            translate([-50,-50,-100])
            cube([100,100,100]);
        }
        translate([0,0,-16])
            cylinder(d=66,h=18);
    }
        
}


module spinner(r=40,h=65) {
    
    p0 = [r,0]; 
    p1 = [r,h*(50/65)];
    p2 = [0,h];



    pt = [[0,h],[0,0],[r,0]];
    p = concat(bezier(p0=p0,p1=p1,p2=p2,deltat=Deltat),pt);
    //echo(p);
    //rotate([90,0,0])
    rotate_extrude()
        polygon(p);
    translate([0,0,-16])
        cylinder(d=66,h=18);

};

 module tube(od= 20, id=10, l=40, center=true) {
    difference() {
     cylinder(d=od,h=l,center=center);
     cylinder(d=id,h=l+1,center=center);
    };
}; 

module body_holes() {
    translate([-60,0,142.5])
    rotate([0,90,0])    
    cylinder(d=26,h=50, center=true);    
    
    translate([-60,0,174])
    rotate([0,90,0])    
    cylinder(d=12,h=50, center=true);    
    translate([-60,0,110])
    rotate([0,90,0])    
    cylinder(d=12,h=50, center=true);  
}

module body() {
    difference() {
        translate([0,0,150])
            tube(od=76,id=66,l=300);
        body_holes();
        
    }  
    
}

module bolthole() {
    translate([-48,0,0])
       rotate([0,90,0]) 
       union() {   
           cylinder(d=6,h=21, center=true);  
           translate([0,0,-22.9])
           cylinder(d=10,h=25, center=true);  
       }  
   }
module screwhole() {
    translate([-47,0,0])
    rotate([0,90,0]) 
       union() {   
           cylinder(d=6,h=20, center=true); 
           
           translate([0,0,-50])
           cylinder(d=12,h=100, center=true);  
           translate([0,0,20])
           cylinder(d=2,h=20, center=true);  
       }  
   }

module mounting_leg(base=0,height=45){
    intersection() {
        difference() {
            translate([0,0,180])
            rotate([0,2.5,0])
            rotate([90,0,0])
             rotate([0,-90,0])
             difference() {
               scale([1,6])
                  cylinder(d=34,h=750);
                 // main tube
                 translate([0,0,50])
                    cylinder(d=18.5,h=780);
                 translate([0,-60,10])
                 cylinder(d=7,h=780);
                 translate([0,55,10])
                 cylinder(d=6.5,h=780);
                 // connecting tube
                 translate([0,0,70])
                 rotate([-270,0,0])
                 cylinder(d=19,h=40);
                 
                 
                 
                 // cutaway
                 //translate([0,-100,10])
                 //cube([100,200,900]);
                 
                 
                 
                 
                }
            // cable exit from body
            translate([-60,0,142.5])
                rotate([0,90,0])    
                   union() {
                    cylinder(d=19,h=50, center=true); 
                  }  
            // screw recesses
            translate([-38,0,174])
            rotate([0,90,0])    
            cylinder(d=12,h=5, center=true);    
            translate([-38,0,110])
            rotate([0,90,0])    
            cylinder(d=12,h=5, center=true);  
                  

            // layer 1 fix
            translate([0,0,250])
               bolthole();
            translate([0,0,164])
               bolthole();
            translate([0,0,100])
               bolthole();
            


            // body
            translate([0,0,150])
                tube(od=76,id=1,l=300);
        };
        translate([-height-30-base,-100,0])
        cube([height,200,500]);
    }
}

module foilshape(d=40,f=5.6,b=6.5,h=100) {
         union(){
         difference() {
           scale([1,f])
              cylinder(d=d,h=h);
           translate([-50,-200,-1])
           cube([100,200,h+102]);
         }
         difference() {
           scale([1,b])
             cylinder(d=d,h=h);
           translate([-50,0,-10])
                cube([100,200,h+102]);
         }
        }
}

module legbase_block() {
  intersection() {
    difference() {
    translate([0,0,195])
     rotate([0,2.5,0])
     rotate([90,0,0])
     rotate([0,-90,0])
     difference() {
         union(){
            foilshape(d=35,f=5.6,b=6.3,h=100);
            foilshape(d=45,f=4.0,b=5.0,h=40);
         }
        // main tube 
        cylinder(d=26,h=600,center=false);
        // reinforcing web
        translate([3,12,38])
         rotate([0,-90,0])
            linear_extrude(height=6)
                polygon([[0,0],[75.5,0],[0,75.5],[0,0]]);
              

         // cutaway
        //translate([0,-100,10])
        // cube([100,200,900]);
    }
    // space for weld on tube
    translate([-30,0,197])
     rotate([0,-90,0])
      cylinder(d=28,h=10,center=false);
    translate([-40,-3.5,210])
       cube([5,7,73]);

    translate([0,0,110])
        bolthole();
    translate([1.5,10,220])
        bolthole();
    translate([1.5,-10,220])
        bolthole();
    
    
         // cable exit from body 
            translate([-35,0,142.5])
                rotate([0,90,0])    
                   union() {
                    cylinder(d=27,h=10, center=true); 
                    cylinder(d=22,h=48, center=true); 
                  }  
        // cable entry
            translate([-48,-11,145])
                 cube([22,22,55]);
            translate([-48,0,170])
                cylinder(d=22,h=60, center=true); 
            // body
            translate([0,0,150])
                tube(od=76,id=1,l=300);
    }
    height=40;
     translate([-height-30,-100,0])
        cube([height,200,500]);

   }


}

module legtop_block() {
    translate([0,0,195])
     rotate([0,2.5,0])
     translate([-540,0,0]) {
            rotate([90,0,0])
            rotate([0,-90,0])
     
             difference() {
                 union(){
                    foilshape(d=35,f=5.6,b=6.3,h=20);
                        //mounting plate
                    //translate([0,12,0])
                    //         cube([10,135,55]);
                     
                     translate([0,0,30])
                     rotate([0,-90,0]) 
                        translate([0,23,0])
                         difference() {
                             union() {
                            cylinder(d=80,h=40,center=true);
                             translate([-10,-40,-20])
                             cube([10,80,40]);
                             }
                             translate([-125,-50,-50])
                             cube([100,100,100]);
                         }
                         
            }
                    union() {
                //mounting plate space
                   translate([0,15,-17])
                     rotate([0,-90,0]) 
                        hull(){
                            translate([5,0,0])
                            cylinder(d=6,h=5,center=true);
                            translate([70,0,0])
                            cylinder(d=6,h=5,center=true);
                            translate([70,30,0])
                            cylinder(d=6,h=5,center=true);
                            translate([5,30,0])
                            cylinder(d=6,h=5,center=true);
                        }
    

                 }
                // main tube 
                translate([0,0,-1])
                cylinder(d=26,h=600,center=false);
        // bush hole         
                translate([0,0,30])
                     rotate([0,-90,0]) 
                        translate([0,23,-10])
                        cylinder(d=16,h=150,center=true);
                 // 
                 // cutaway
               //translate([0,-100,10])
               //  cube([100,200,900]);
            }

    
    }


}
module legshell(){
    translate([0,0,195])
     rotate([0,2.5,0])
     translate([0,0,0]) {
            rotate([90,0,0])
            rotate([0,-90,0])
     
            translate([0,0, 65])
             difference() {
                 union(){
                    foilshape(d=35,f=5.6,b=6.3,h=480);
                 }
                 translate([0,0,-1])
                 foilshape(d=31,f=5.6,b=6.3,h=602);
    

                 // 
                 // cutaway
               translate([0,-100,10])
                 cube([100,200,900]);
            }

    
    }

}
module legtube(){
        difference() {
            union() {
            translate([0,0,195])
            rotate([0,2.5,0])
            rotate([90,0,0])
             rotate([0,-90,0])
              union() {
                 // main tube
                 tube(od=25.4,id=18,l=600,center=false);
                  // reinforcing web
                 translate([2.5,13,38])
                  rotate([0,-90,0])
                 linear_extrude(height=5)
                 polygon([[0,0],[75,0],[0,75],[0,0]]);
              }
              }
            // cable entry
            translate([-50,0,180])
                cylinder(d=16,h=50, center=true); 
              
            // body
            translate([0,0,150])
                cylinder(d=76,h=300);
        };
        
        
        // mounting plate
        translate([-595,0,235]) {
            rotate([90,2.5,0]) {
            difference() {
            union() {
                //mounting plate
                hull(){
                translate([5,0,0])
                cylinder(d=5,h=5,center=true);
                translate([50,0,0])
                cylinder(d=5,h=5,center=true);
                translate([50,30,0])
                cylinder(d=5,h=5,center=true);
                translate([5,30,0])
                cylinder(d=5,h=5,center=true);
                }
            }
            //hole for bearing slieve
                translate([25,10,0])
                cylinder(d=16,h=35,center=true);
            }
            // bearing sleve, printed
            //translate([25,10,0])
            //   tube(id=10,od=18,l=32,center=true);
            }
            
        };    

}



//translate([0,0,304])
//   nose_cone(r=76/2,h=65);

//bearing_endcap();

//translate([0,0,4])
//  body();



translate([0,0,4]) {
    legtube();
    legshell();
    //translate([-112,5,209])
    //cube([75,10,72]);
    legbase_block();
    legtop_block();
}

