//
// Fujica X-mount (circa 1970s-1985, not to be confused with the confusingly similarly-named 
// 201X-era Fujifilm X-mount) to E-Mount (Sony NEX, A7/r, A6000, etc) adapter.
//
// Designed by George McBay (george.mcbay@gmail.com).  
//
// Based off measurements made from the 3 Fujica X-mount lenses I have (all 3rd party, one Rokinon and
// two X-Kominar) and my Sony A7 camera. I'm not sure how well the measurements adapt 
// to allowed manufacturing tolerances for either mount given the limited amount of samples, but 
// it should be easy to modify this to match if you run into fit issues with the current values.
//
// There is no explicit locking mechanism on the Fujica X-mount side, but between the tight fit
// of the thread rings and the aperture lock, this hasn't been a problem for me.  Use caution if
// using this with highly valued lenses. 
//

// use high tessellation on the cylinders to get a good fit
//$fn = 300;

// 43.5 is the flange focal distance of the Fujica X-mount
// 18 is the flange focal distance for the Sony E mount
ffdDelta = 43.5 - 18; 

eRingOuterRadius = 23;
eRingInnerRadius = 22;
eRingHeight = 1.5;
eRingDropIn = 5;

fxRingOuterRadius = 25;
fxRingInnerRadius = 23.5;
fxRingHeight = 2;
fxRingZ = 3.5;

outerRadius = 31;
innerRadius = fxRingOuterRadius;

module ringThread(rot, z, length, height, or, ir) {
	translate([0, 0, z - height]) {
		intersection() {
			difference() {
				cylinder(h=height, r=or);
				cylinder(h=height, r=ir);
			}
		
			rotate([0, 0, rot]) {
				translate([ir - length * 0.5, 0 - length * 0.5, 0]) {
					cube(size=length);
				}	
			}
		}
	}
}

module eMountLensRear(z, eRingBaseHeight) {
	z = z - eRingBaseHeight;
	eRingZ = eRingBaseHeight + 5;

	translate([0, 0, z]) {
		difference() {
			union() {
				cylinder(h=eRingBaseHeight, r=outerRadius);
				cylinder(h=eRingBaseHeight+1, r=eRingOuterRadius); 
				cylinder(h=eRingZ, r=eRingInnerRadius);
			}

			cylinder(h=eRingZ, r=19);
			
			// draw the little locking hole on the mounting edge
			translate([0, 27, eRingBaseHeight-2])
         {
				scale([1, 1.33, 1])
            {
					cylinder(h=2, r=1.33);
				}
			}
			translate([12.5, -23.8, eRingBaseHeight-1]) // orientation marker
         {
					cylinder(h=1+0.1, d=1.5);	
			}
		}
	
		ringThread(10, eRingZ, 16, eRingHeight, eRingOuterRadius, eRingInnerRadius);
		ringThread(140, eRingZ, 19, eRingHeight, eRingOuterRadius, eRingInnerRadius);
		ringThread(255, eRingZ, 19, eRingHeight, eRingOuterRadius, eRingInnerRadius);
	}
}

module fxMount(z) {
	translate([0, 0, z]) {
		// little extruded box to engage aperture arm
		rotate([0, 0, 45]) {
			translate([outerRadius - 14, -6, 5.75]) {
				rotate([0, 0, -12]) {
					cube(size=[10, 8, 3.75]);
				}
			}
		}

		ringThread(0 - 6, fxRingZ, 24, fxRingHeight, fxRingOuterRadius, fxRingInnerRadius);
		ringThread(0 - 115, fxRingZ, 26, fxRingHeight, fxRingOuterRadius, fxRingInnerRadius);
		ringThread(0 - 260, fxRingZ, 27, fxRingHeight, fxRingOuterRadius, fxRingInnerRadius);
	}
}

// rotating by 180 degrees in Y here puts the E Mount on the bottom of the model which for me results
// in easier clean-up of Simplify3D autogenerated supports after printing.  YMMV based on printer and 
// slicer software, comment the rotate out to get the E Mount on the top.
*rotate([0, 180, 0]) {
	// main tube area
	difference() {
		cylinder(h=ffdDelta-eRingDropIn, r=outerRadius);
		cylinder(h=ffdDelta-eRingDropIn, r=innerRadius);
	}

	fxMount(0);
	eMountLensRear(ffdDelta, eRingDropIn);
}







