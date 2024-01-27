
//include <RatsoShapeLibrary.scad>



/*
Define settings for each nut/bolt type here
*/

// ### layer height of the printer ###
printer_layer_height = 0.4;

// kludge factor for different print nozzles
printer_oversize = 0.5; // 0.35 nozzle use 0.3; 0.6 nozzle use 0.?
printer_oversizeArc = 0.2; // 0.35 nozzle = ???; 0.6 nozzle = 0.2


// ### M3 ###

M3_boltDiameter = 3.0 + printer_oversize; // actual 3.0
M3_boltDiameterArc = 3.0 + printer_oversizeArc; // used for rotary extruded bolt channel
M3_boltHeadDiameter = 6.0 + printer_oversize; // actual 6
M3_nutHeight = 2.4 + printer_oversize; // actual 2.4
M3_lockNutHeight = 4.0 + printer_oversize; // actual 4.0
M3_nutDiameterMin = 5.5 + printer_oversize; // actual 5.5
M3_nutDiameterMax = (5.5*(1/sin(60))) + printer_oversize; // actual 6
M3_nutDiameterArc = 5.5; // used for rotary extruded nut channel

// eventually standardize this interface??, that would allow for easy switching of bolt/nut sizes
M3_dim = [M3_boltDiameter,M3_nutDiameterMin,M3_nutDiameterMax,M3_nutHeight];


// ### M2 ###

M2_boltDiameter = 2.0 + printer_oversize; // actual 2.0
M2_boltHeadDiameter = 4.0 + printer_oversize; // actual 4
M2_nutHeight = 1.6 + printer_oversize; // actual 1.6
M2_nutDiameterMin = 3.8 + printer_oversize; // actual 4
M2_nutDiameterMax = (4.0*(1/sin(60))) + printer_oversize; // actual 4.5

// eventually standardize this interface??, that would allow for easy switching of bolt/nut sizes
M2_dim = [M2_boltDiameter,M2_nutDiameterMin,M2_nutDiameterMax,M2_nutHeight];

// ### M8 ###
M8_rodDiameter = 8 + printer_oversize;

// ### PI ###
pi = 3.14159265359;



// ### shaft sizes for tight fit ###
woodDowel_quarterInch_diameter = 7.1;
woodDowel_halfInch_diameter = 13.5;
stepperMotor_diameter = 5.0 + printer_oversize; // actual 5.0



//--------




// =========================================================

//trapNutDie(channelHeight=20, holeLength=50, holeOffset=15 );
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

// =================================

//stumpWithTrapNut(shaftDiameter=stepperMotor_diameter, stumpWallThick=6, nutBlockThick=12);
//stumpWithTrapNut(shaftDiameter=16 + printer_oversize ); // shaft collar for Chad's drum stand
//stumpWithTrapNut(shaftDiameter=woodDowel_halfInch_diameter, stumpWallThick=8, nutBlockThick=0);
//stumpWithTrapNut(shaftDiameter=woodDowel_quarterInch_diameter); // shaftDiameter was 7.3, but a little too loose


module stumpWithTrapNut(
	shaftDiameter = 7.3,
	stumpWallThick = 4,
	nutBlockThick = 8,
	){

	shaftRadius = shaftDiameter/2;
	stumpRadius = shaftRadius + stumpWallThick;
	stumpHeight = 10;

	nutBlockWidth = M3_nutDiameterMax+stumpWallThick;
	nutBlockOffsetY = stumpRadius + nutBlockThick - stumpWallThick;
	stumpTrapNutOffsetY = shaftRadius + ( max( stumpWallThick, nutBlockThick ) / 2.5 );  //nutBlockOffsetY - (nutBlockThick/2); //
	stumpTrapNutOffsetZ = stumpHeight/2;

	trapNutBoltHoleLength = max( nutBlockThick, stumpWallThick );

		// nut stump
			translate([0,0,0]) difference(){
				union(){
					// stump
					translate([0,0,0]) cylinder(r=stumpRadius, h=stumpHeight, center=false);
					// nut block
					translate([-nutBlockWidth/2,-nutBlockOffsetY,0]) cube([nutBlockWidth,nutBlockThick,stumpHeight]);
				}
				// motor shaft
				translate([0,0,(stumpHeight)/2]) cylinder(r=shaftRadius, h=stumpHeight+1, center=true, $fn=shaftDiameter*3);
				// trap nut
				rotate([0,0,0]) translate([0,-stumpTrapNutOffsetY, stumpHeight-stumpTrapNutOffsetZ]) rotate([0,0,0]) trapNutDie(channelHeight=10 ,holeLength=trapNutBoltHoleLength*2, holeOffset=(-trapNutBoltHoleLength)/2 ); //holeOffset=(length/2)+(r1/2)
			} // translate difference
}

