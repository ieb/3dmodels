use <libs/bezier/quadratic_bezier.scad>
use <libs/NACA/shortcuts.scad>
use <libs/NACA/NACA4.scad>
use <libs/Extrude_Along_Path/path_extrude.scad>;

Deltat=0.05;
$fn=100;


module nose_cone(r=76/2,h=65) {
    
    p0 = [r,0]; 
    p1 = [r,h*(50/65)];
    p2 = [0,h];



    pt = [[0,h],[0,0],[r,0]];
    p = concat(bezier(p0=p0,p1=p1,p2=p2,deltat=Deltat),pt);
    //echo(p);
    rotate([90,0,0])
    union() {
    rotate_extrude()
    polygon(p);
    //translate([0,0,-16])
    //    cylinder(d=66,h=18);
    }
};


module blade_stub(R=10, B=40, H=30, r=2.5, h=5) {
    
    translate([0,0,-B])
    union() {
    cylinder(r=R,h=(H-R));
    translate([0,0,H-R-h-r]) cylinder(r=R+r,h=h);
    //translate([0,0,H-R]) sphere(r=R);
    }
};


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
        };
        // take the drive plate away
        translate([0,1,0])
            drive_plate(R=R,t=3,holes=false);
        drive_plate_screws();
        rotate([90,0,0])
        cylinder(d=10,h=30);
        
     }
}

module screw(l=15,m=6,h=0) {
   translate([0,0,0])
     cylinder(d=m,h=l+3);
   translate([0,0,l])
      cylinder(d=m*(10/6),h=m+h);
    
}

module drive_plate_screw(R=76/2, l=25, m=6) {
       rotate([90,0,0]) {
        translate([0,-R+10,0])
          screw(l=l,m=m,h=50); 
       }
}

module drive_plate_screws() {
        rotate([0,60,0])
        drive_plate_screw();
        rotate([0,-60,0])
        drive_plate_screw();
        rotate([0,-180,0])
        drive_plate_screw();
}


module drive_plate_arm(R=76/2, t=2, holes=true, m=5) {
    difference() {
        union() {
            // end
            translate([0,-R+10,-t])
                cylinder(d=2*m,h=t);
            translate([0,-R+10,-t-m])
                cylinder(d=2*m,h=m);
            //arm
            translate([-(2*m/2),-R+10,-t])
                cube([2*m,35,t]);
        }
        if ( holes ) {
        translate([0,-R+10,-1-m-t])
            cylinder(d=m,h=m+t+2);
        }
    }
 }

module drive_plate(withPin=true, R=76/2, t=3, holes=true) {
    color("silver") 
        rotate([-90,0,0])
         difference() {
          union() {
            // center
            translate([0,0,-t])       
            cylinder(d=30,h=t);
            translate([0,0,-t-15])       
            cylinder(d=20,h=15);
              rotate([0,0,0]) drive_plate_arm(R=R,t=t, holes=holes);
              rotate([0,0,120]) drive_plate_arm(R=R,t=t, holes=holes);
              rotate([0,0,-120]) drive_plate_arm(R=R,t=t, holes=holes);
              if ( !holes ) {
                translate([0,0,-1])
                    cylinder(d=10,h=t+30);
              }
          }
          if ( holes) {;
               // m4 pin
              translate([0,-7,-10-t])
             rotate([-90,0,0])
                translate([0,0,0])
                    screw(l=15,m=4);
                // shaft 
                translate([0,0,-t-29])
                    cylinder(d=10,h=t+30);
          }
        }
  }
  
  
module drive_pin() {
        // drive pin, 3mm 316 pin
    translate([0,-1.5,-15])
        cylinder(r=1.5,h=30);
}


module spinner_base() {

    difference() {
    nose_cone_with_blades(R=76/2);
     translate([-50,-115,-50])
        cube([100,100,100]);
    }
}

module spinner_cap() {

    difference() {
    nose_cone_with_blades(R=76/2);
     translate([-50,-15,-50])
        cube([100,100,100]);
    }
}

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

module foil_section(points,n,m,h,t,v,H,sx,ps) {
     translate([0, 0, n*h/m])
    rotate([0,0,n*t/m]) // section rotate
        // section height, scale and twist
        linear_extrude(height = h/m, 
            twist = -t/m,          
            scale = ps)
     translate([0, 0])
        scale([v*0.8,H]) // chord size
          polygon(points = points); 
}

function scaleX(x, y, f, b, ca, sa) = 
    let (xa = (-x-50)*(b-f)/100)
    let (ya = y*(f-b)/100)
    ((b+f)/2)+xa*ca-ya*sa;
function scaleY(x, y, f, b, ca, sa) = 
    let (xa = (-x-50)*(b-f)/100)
    let (ya = y*(f-b)/100)
    ya*ca+xa*sa;


module foil(h=150, w=75, a=-25) {
        
    // the front edge and back edge are beziers of control points for the
    // shape of the foil
        // front edge
        f1 = [-0.3*w,-0]; 
        f2 = [-0.75*w,h*0.4];
        f3 = [-0.27*w,h*0.8];
           
        f4 = [-0.05*w,h];
        f5 = [0.3*w,h];
    
    

        frontedge = concat(bezier(p0=f1,p1=f2,p2=f3,deltat=Deltat),
           bezier(p0=f3,p1=f4,p2=f5,deltat=Deltat));
    
        // draw the front edge
        /*
        color("red")
        rotate([90,0,0])
        polyline(frontedge,1,1);
        */

        // back edge
        b1 = [0.50*w,-0]; 
        b2 = [0.35*w,h*0.3];
        b3 = [0.6*w,h*0.8];

        b4 = [0.7*w,h];
        b5 = [0.3*w,h];
       
        backedge = concat(bezier(p0=b1,p1=b2,p2=b3,deltat=Deltat),
           bezier(p0=b3,p1=b4,p2=b5,deltat=Deltat));
           
        // draw the backedge edge
        /*
        color("blue")
        rotate([90,0,0])
        polyline(backedge,1,1);
        */
        
        // draw the cords
        /*
        color("green")
        rotate([90,0,0]) {
            for( i = [0:5:len(backedge)-1]) {
                line([frontedge[i][0],frontedge[i][1]],[backedge[i][0],backedge[i][1]],0.2);
            }
        }
        */
        

        

        // draw the aerofoil by construc
        points = airfoil_data(naca=[-.1, .4, .1], N=60, open=false);
        n = len(frontedge)-1;
        np=len(points);
        allpoints = [
                
                for(z=[0:1:n])
                   for(p=[0:1:np-1]) 
                      [scaleX(-points[p][0],
                            points[p][1],
                            frontedge[z][0],
                            backedge[z][0], 
                            cos(a*z/n), 
                            sin(a*z/n)), 
                       scaleY(-points[p][0],
                            points[p][1],
                            frontedge[z][0],
                            backedge[z][0],
                            cos(a*z/n),
                            sin(a*z/n)), 
                   (frontedge[z][1]+backedge[z][1])/2]
                ];
        
        // points goes round the airfoil, creating faces with tiles connecting both sides
        // faces must be triangles
        basefaces1 = [for(p=[0:1:(np-2)/2]) [
             np-p-1,
             np-p,
             p
        ]];
        basefaces2 = [for(p=[0:1:(np-2)/2]) [
             p,
             p+1,
             np-p-1
        ]];
        topfaces1 = [for(p=[0:1:((np-2)/2)-1]) [
             n*np+p,
             n*np+np-p-1,
             n*np+np-p-2
        ]];
        topfaces2 = [for(p=[0:1:((np-2)/2)-1]) [
             n*np+np-p-2,
             n*np+p+1,
             n*np+p
        ]];
        mainfaces1 = [for(z=[0:1:n]) for(p=[0:1:np-2]) 
            [
            p+np*z,
            p+np*(z+1),
            p+np*(z+1)+1
            ]
        ];
        mainfaces2 = [for(z=[0:1:n]) for(p=[0:1:np-2]) 
            [
            p+np*(z+1)+1,
            p+np*z+1,
            p+np*z
            ]
        ];
        joinfaces1 = [for(z=[0:1:n-1]) [
            np*(z+1)-1,
            np*(z+2)-1,
            np*(z+1)
         ]];
        joinfaces2 = [for(z=[0:1:n-1]) [
            np*(z+1)-1,
            np*(z+1),
            np*z
         ]];
        allfaces = concat(basefaces1, basefaces2, topfaces1, topfaces2, joinfaces1, joinfaces2, mainfaces1, mainfaces2);
      polyhedron( 
                points=allpoints,
                faces=allfaces
                );
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
module blade(R=40, H=65, r=10, h=30, A=24, a=15, tr=220 ) {
    difference() {
    rotate([0,0,180-A])
        union() {
           // foil
            
            blade_stub(R=r,B=R,H=h);
            hull() {
                blade_stub(R=r,B=R-12,H=2,r=0);
                translate([2,-3,-R+5])
                intersection() {
                    rotate([0,185,0])
                    translate([-12,0,0])
                        cube([25,1,10]);
                }
            } 
    
            translate([2,-3,-R+5])
            rotate([0,185,0])
              foil(a=-15,h=(tr-R+5),w=40);
            
        };
   translate([0,15,0])
      nose_cone_with_blades(R=R+2);
       
    }

};


//spinner_cap();
//translate([0,-15,0])
blade(R=75/2, h=30, H=61, tr=120);
//foil(t=20,h=120-75/2,R=75/2-10);
//spinner_base();

//drive_plate();
//drive_plate_screws();