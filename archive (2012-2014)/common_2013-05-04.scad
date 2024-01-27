
include <RatsoShapeLibrary.scad>



/*
Define settings for each nut/bolt type here
*/



// ### M3 ###

M3_boltDiameter = 3.8; // actual 3.0
M3_boltHeadDiameter = 6.8; // actual 6
M3_nutHeight = 2.5; // actual 2.4
M3_nutDiameterMin = 5.9; // actual 5.5
M3_nutDiameterMax = 6.9; // actual 6

// eventually standardize this interface??, that would allow for easy switching of bolt/nut sizes
M3_dim = [M3_boltDiameter,M3_nutDiameterMin,M3_nutDiameterMax,M3_nutHeight];


// ### M2 ###

M2_boltDiameter = 3.0; // actual 2.0
M2_boltHeadDiameter = 4.8; // actual 4
M2_nutHeight = 1.8; // actual 1.6
M2_nutDiameterMin = 4.8; // actual 4
M2_nutDiameterMax = 5.3; // actual 4.5

// eventually standardize this interface??, that would allow for easy switching of bolt/nut sizes
M2_dim = [M2_boltDiameter,M2_nutDiameterMin,M2_nutDiameterMax,M2_nutHeight];

// ### PI ###
pi = 3.14159265359;

// ### layer height of the printer ###
printer_layer_height = 0.4;



// DELETE ALL THIS >>>>>>>>>>>
boltDiameter = 3.8; // actual 3
boltRadius = boltDiameter/2;
boltCountersinkDiam = 8; // M3 washer is 7
boltCountersinkDepth = 3.5;
boltHoleDiam = boltDiameter; // KLUDGE FIX THIS

boltHeadDiameter = 6.0; // actual 5
boltHeadHeight = 2.5; // actual 3
boltHeadCountersink = boltHeadHeight + 1; // ?

boltHoleSupportThick = 0.5; // should be the same as your layer height

nutDiam = 6.9; //  actual 6 
nutRadius = nutDiam/2;
nutHeight = 2.5;
// <<<<<<<<<<<<<<<<<<<<<



//--------




// =========================================================

//trapNutDie(channelHeight=0);
//trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0 );
// ** this is a brand-new function
module trapNutDie(
	channelHeight=15, 
	holeLength=10, 
	holeOffset=0, 
	nutOffset=0, 
	boltHoleRes=12,
	boltRadius = M3_boltDiameter/2, // DEPRICATE
	mType = 0,
	boltDiameter = M3_boltDiameter,
	nutHeight = M3_nutHeight,
	nutDiameterMin = M3_nutDiameterMin,
	nutDiameterMax = M3_nutDiameterMax,
	horizontal = false // should add a support to the bolt hole, AND (###TODO###) make the nut height a little higher
	){

	if(!horizontal){
	// hex-hole for the nut
	translate([0,-(nutHeight/2),-nutOffset]) rotate([-90,30,0]) cylinder(r=nutDiameterMax/2, h=nutHeight, $fn=6);
	// channel the nut drops into
	translate([-nutDiameterMin/2,-(nutHeight/2),0]) cube([nutDiameterMin,nutHeight,channelHeight]);
	}else{
	// hex-hole for the nut
	translate([0,-(nutHeight/2),-nutOffset]) rotate([-90,30,0]) cylinder(r=nutDiameterMax/2, h=nutHeight+printer_layer_height, $fn=6);
	// channel the nut drops into
	translate([-nutDiameterMin/2,-(nutHeight/2),0]) cube([nutDiameterMin,nutHeight+printer_layer_height,channelHeight]);
	}

	difference(){
		// bolt hole
		translate([0,-(holeLength/2)+holeOffset,0]) rotate([-90,0,0]) cylinder(r=boltDiameter/2, h=holeLength, $fn=boltHoleRes);
		if(horizontal){
			// cutout slice for support (if horizontal)
			rotate([-90,0,0]) translate([0,0,(nutHeight/2)+0.001]) cylinder(r=(boltDiameter/2)+1, h=printer_layer_height*2);
		}
	}
}


