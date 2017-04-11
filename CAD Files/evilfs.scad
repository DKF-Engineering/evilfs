// use E-mount description from http://www.thingiverse.com/thing:330812 project by Thingiverse user gmcbay:
use <FujicaXtoEMount.scad> 

sony_emount_ffd = 18.0;

minolta_af_ffd = 44.5; // flange focal distance, see https://en.wikipedia.org/wiki/Flange_focal_distance
external_ring_height = 2.2; // ring from Minolta AF extension tube
external_ring_hole_dia = 1.8/2; // ring from Minolta AF extension tube
external_ring_hole_circle_dia = 57.0; // ring from Minolta AF extension tube
external_ring_lock_width = 8.0; // bajonet lock from Minolta AF extension tube
lock_button_length = 10;
lock_button_width = 7;

minolta_af_outer_dia = 64;
minolta_af_inner_dia = 51; // Minolta AF inner diameter
entrance_aperture = minolta_af_inner_dia;

TS_filter_drawer_height = 6.1;
TS_filter_drawer_width = 55.7;
TS_filter_drawer_depth = TS_filter_drawer_width;

//--------------------------------------------------------------------------------------------------
front_flange_height = 7.0; // similar to Minolta AF adapter
rear_flange_dia = 61.0; // similar to Sony E mount

ffd_tolerance = 0.75;
overall_length = (minolta_af_ffd - sony_emount_ffd) - external_ring_height - ffd_tolerance;

drawer_tolerance = 0.5;
drawer_h = TS_filter_drawer_height;
drawer_w = TS_filter_drawer_width;
drawer_d = TS_filter_drawer_depth;

cage_wall = 4.0;
cage_height = drawer_h+2*cage_wall;
optical_aperture = entrance_aperture;
cage_depth = drawer_w+1*cage_wall;
cage_width = drawer_w+2*cage_wall;
cage_chamfer = 1.5;

rear_flange_height = overall_length - (front_flange_height + cage_height);

// use high tessellation on the cylinders to get a good fit
$fn = 300;

//--------------------------------------------------------------------------------------------------

union()
{
 // front adapter:
 rotate([0,0,90])
 translate([0,0,cage_height+front_flange_height/2])
 difference()
	{
		difference() // lock
			{
				difference()
					{
						difference() // flange ring
							{
								cylinder(d=minolta_af_outer_dia, h=front_flange_height, center=true);
								cylinder(d=entrance_aperture, h=front_flange_height+0.1, center=true);
							}
						union() // 3 mounting holes for external ring
							{
								for(i=[0:2])
									{
										rotate([0,0,i*120])
										translate([external_ring_hole_circle_dia/2,0,0])
										cylinder(d=external_ring_hole_dia, h=front_flange_height+0.1, center=true);
									}
							}
					}
				rotate([0,0,-90])
				union() // lock button
					{
						translate([minolta_af_inner_dia/2+0.6+lock_button_length/2,0,front_flange_height/2-(1.5-0.1)/2])
						cube([lock_button_length,lock_button_width,1.5+0.1], center=true);
						translate([external_ring_hole_circle_dia/2,0,0])
						cylinder(d=1.1, h=front_flange_height, center=true);
						translate([external_ring_hole_circle_dia/2,0,front_flange_height/2-(1.5)/2-1])
						cylinder(d=2.0, h=1, center=true);
					}
			}
		rotate([35,90,0])
		translate([0,0,minolta_af_outer_dia/2-1/2])
		cylinder(d=1.5, h=1+0.1, center=true);
	}

 // filter cage:
 rotate([0,0,-7])
 rotate([0,0,90])
 rotate([0,0,90])
 translate([0,0,(cage_height)/2])
 difference()
	{
		difference()
			{
				translate([-cage_wall/2,0,0])
				difference()
					{
						difference()
							{
								translate([cage_wall,0,0]) cube([cage_depth,cage_width,cage_height], center=true);
								translate([(cage_wall-0.1)/2,0,0]) cube([drawer_d+0.1,drawer_w+drawer_tolerance,drawer_h+drawer_tolerance], center=true);
							}
						rotate([90,90,0]) // fixation screw M4
						translate([0,cage_wall/2,-(cage_width/2-(cage_wall)/2)])
						cylinder(d=3, h=cage_wall+0.1, center=true);
					}
				cylinder(d=optical_aperture, h=cage_height+0.1, center=true);
			}
		// create chamfer
		rotate([0,0,45]) 
		difference()
			{
				cube([cage_width*sqrt(2)+0.1,cage_width*sqrt(2)+0.1,cage_height+1+0.1], center=true);
				cube([cage_width*sqrt(2)-2*cage_chamfer,cage_width*sqrt(2)-2*cage_chamfer,cage_height+1], center=true);
			}
	}

 // rear adapter:
 rotate([180,0,-155])
 eMountLensRear(rear_flange_height, rear_flange_height);
}


