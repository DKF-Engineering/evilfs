minolta_af_ffd = 44.5; // flange focal distance, see https://en.wikipedia.org/wiki/Flange_focal_distance
sony_emount_ffd = 18.0;
entrance_aperture = 50; // Minolta AF inner diameter

TS_filter_drawer_height = 6;
TS_filter_drawer_width = 55.5;

//--------------------------------------------------------------------------------------------------

front_flange_height = 7.5; // similar to Minolta AF adapter
rear_flange_dia = 61.0; // similar to Sony E mount

ffd_tolerance = 0.5;
overall_length = (minolta_af_ffd - sony_emount_ffd) - ffd_tolerance;

drawer_h = TS_filter_drawer_height;
drawer_w = TS_filter_drawer_width;

cage_wall = 4.0;
cage_height = drawer_h+2*cage_wall;
optical_aperture = entrance_aperture;

rear_flange_height = overall_length - (front_flange_height + cage_height);

//--------------------------------------------------------------------------------------------------

union()
{
 translate([0,0,cage_height+front_flange_height/2])
 difference()
 {
  cylinder(d=62, h=front_flange_height, center=true);
  cylinder(d=entrance_aperture, h=front_flange_height+0.1, center=true);
 }

 translate([0,0,(cage_height)/2])
 difference()
 {
 translate([-cage_wall/2,0,0])
 difference()
 {
  translate([cage_wall,0,0]) cube([drawer_w+1*cage_wall,drawer_w+2*cage_wall,cage_height], center=true);
  translate([(cage_wall-0.1)/2,0,0]) cube([drawer_w+0.1,drawer_w,drawer_h], center=true);
 }
 cylinder(d=optical_aperture, h=cage_height+0.1, center=true);
 }

 translate([0,0,-rear_flange_height/2])
 difference()
 {
  cylinder(d=rear_flange_dia, h=rear_flange_height, center=true);
  cylinder(d=optical_aperture, h=rear_flange_height+0.1, center=true);
 }
 
 
}
