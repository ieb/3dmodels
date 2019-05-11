use <path_extrude.scad>;
vl = 100; // vase length
vt = 3;  // turns per vase
bpr = 0.75; // base-pair radius
bbr = 2.5; // backbone radius
hr = vl/3.3 * 1/vt; // helix radius
dpb = 360 / (vt * 10); // degrees per base
lip = 360 - dpb / 2; // last iteration position
os = 360 / (vt * 3); // opposite strand separation (in degrees)
bs = dpb * 3; // degrees to slip back when connecting strands
rt = 6; // turns per ring

// *GRINGENE* -- TAA GGN MGN ATH AAY GGN GAR AAY GAR TGA
//            -- TAA GGC AGG ATC AAC GGC GAG AAC GAG TGA

bases = [3,0,0, 2,2,3, 0,2,2, 0,3,2, 0,0,1, 2,2,1, 2,0,2, 0,0,1, 2,0,2, 3,2,0];

function norm(p) = sqrt(p[0]*p[0] + p[1]*p[1] + p[2]*p[2]);

function base2col(b) = (b == 0) ? [0,1,0] :  // Adenine  Green
                       (b == 1) ? [0,0,1] :  // Cytosine Blue
                       (b == 2) ? [1,1,0] :  // Guanine  Yellow
                       [1,0,0];              // Thymine  Red

module drawBases(p1,p2,pos, both=true){
  baseType = floor(bases[((pos/dpb) % len(bases) + len(bases)) % len(bases)]);
  bd = ((baseType % 2) == 0) ? 1.75 : 2.25; // A/G are double-ring purines
  c1 = base2col(baseType);
  c2 = base2col(3-baseType);
  br = (((baseType+1) % 4) < 2) ? 45 : 30;
  translate(p1) color(c1)
    rotate([-acos((p2[2]-p1[2]) / norm(p1-p2)),0,
            -atan2(p2[0]-p1[0],p2[1]-p1[1])]) 
       rotate([0,0,br]) translate([-bpr,-bpr]) cube([bpr*2,bpr*2,norm(p1-p2)/bd]);
  if(both){
  translate(p2) color(c2)
    rotate([-acos((p2[2]-p1[2]) / norm(p1-p2)),0,
            -atan2(p2[0]-p1[0],p2[1]-p1[1])]) 
       rotate([0,180,br]) translate([-bpr,-bpr]) cube([bpr*2,bpr*2,norm(p1-p2)/(4.5-bd)]);
  }
}

echo($t*360);
rotate([200,0,0]) 
translate([-50,0,0]) rotate([$t*360*1,0,0]) {
    st = (dpb/2);
    fi = floor($t * 360);
    fr = ($t*360) - fi;
    fbi = floor($t * 30+0.5);
    fbr = ($t * 30) - fbi;
    fba = fbr * dpb * 3;
    echo(fr);
    translate([-vl/2,0,0]) rotate([0,90,0]) {
        ed1 = (360-dpb/2);
        ed = (ed1 < st) ? (ed1+360) : ed1;
        for(i = [st:dpb:(ed*2)]){
                drawBases([hr*cos(vt*(i)-fba),
                           hr*sin(vt*(i)-fba),
                           (vl*i)/360-fbr*(vl/30)],
                          [hr*cos(vt*(i)+120-fba),
                           hr*sin(vt*(i)+120-fba),
                           (vl*i)/360-fbr*(vl/30)],i+fi, both = (i < (ed+1)));
        }
    }
    // DNA backbone
    pi=3.14159;
    rotate([0,90,0]) for(shift = [0, os]){
        myPoints = [ for(t = [0:60:360]) bbr * [cos(t),sin(t)] ];
        myPath = concat([ for(i = [(-1-(fbr+0.5)*3):3:(((shift!=0)?vl:vl*2)+1)]) [
            hr * cos(vt*(i/vl * 360 + shift)),
            hr * sin(vt*(i/vl * 360 + shift)),
            i - vl/2
            ] ]//, [[hr * cos(vt*(vl * 360 + shift)+dpb*1.5),
               //    hr * sin(vt*(vl * 360 + shift)+dpb*1.5),vl/2]]
        );
        path_extrude(exShape=myPoints, exPath=myPath, merge=false, exRots = [for(i = [0:len(myPath)]) 0]);
    }
}