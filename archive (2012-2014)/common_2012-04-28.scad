

boltDiameter = 3.8; // actual 3
boltHoleResolution = 12;
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
nutCountersink = nutHeight + 1;
cornerBoltBlockWidth = nutDiam * 1.5;
cornerBoltBlockHeight = nutHeight * 4;
cornerBoltBlockSupportThick = 2;


// WARNING!!! some of these things are defined above with slight name variation

nutHoleDiam = 7.0; // actually 6.2; edgeStrip = 6.?; handle = 6.7
nutHoleDiamShort = sin(60) * nutHoleDiam; // actually 5.4 (face to face dist.); edgeStrip = 5.6; handle = 5.?
nutHoleDiamLooseFit = 7.0; // DEPRICATED - for counter-sunk holes`
nutHoleHeight = 3.0; // actually 2.3; edgeStrip = 2.6; handle = 2.9
nutHoleHeightHoriz = 3.2; // has to be high enough to account for sag of the bridging
nutHoleOffset = 1.0; // 
nutCountersinkHeight = nutHoleHeight + 2; // countersunk nut holes (not trap nuts)
nutBlockWallThick = 1.6;
nutBlockWidth = nutHoleDiamShort + (nutBlockWallThick*2);
nutBlockDepth = nutHoleHeight + (nutBlockWallThick*2);
nutBlockHeight = nutHoleDiam + (nutBlockWallThick*2);
nutBlockBoltHoleoffset = 0.5; // offset from center over the bolt hole, so the nut is actually centered over the hole
nutBlockBoltHoleSupportThick = boltHoleSupportThick; // should be the same as your layer height
nutBlockBoltHoleZoffset = (nutHoleDiam/2) + nutBlockWallThick; // offset from center over the bolt hole, so the nut is actually centered over the hole


//
ledHoleDiam = 5.6; // I measured an LED at 4.8

// # these aren't used #
trapNutWidth = 7; // diameter of the nut
trapNutHeight = 2.8; // height of the nut
trapNutDepth = 6; // depth of hole you drop the nut in
trapNutOffset = 1.0;

//--------


include <RatsoShapeLibrary.scad>


// =========================================================

 
//trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0 );
// ** this is a brand-new function
module trapNutDie(channelHeight=nutBlockWidth, holeLength=nutBlockDepth+2, holeOffset=0, nutHeight=nutHoleHeight, nutOffset=nutHoleOffset, boltHoleRes=boltHoleResolution ){
	// hex-hole for the nut
	translate([0,-(nutHeight/2),-nutOffset]) rotate([-90,30,0]) cylinder(r=nutHoleDiam/2, h=nutHeight, $fn=6);
	// channel the nut drops into
	translate([-nutHoleDiamShort/2,-(nutHeight/2),0]) cube([nutHoleDiamShort,nutHeight,channelHeight]);
	// bolt hole
	translate([0,-(holeLength/2)+holeOffset,0]) rotate([-90,0,0]) cylinder(r=boltDiameter/2, h=holeLength, $fn=boltHoleRes);
	
}


