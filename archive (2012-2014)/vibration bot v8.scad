

include<common.scad>
include <RatsoShapeLibrary.scad>


// ========================================================

// Main function calls. Build things here.


// the basic body, for both types
//buzzBotBody();
//buzzBotBodyNoBattery();
//buzzBotBody_clipHackCover();

// parts for BuzzBot mini
// DELETE - buzzBotMiniLeg();
//simpleLeg( [5,50,3], 7); // default for BuzzBot mini
//simpleLeg( [8,100,8], 8); // default for BuzzBot big

// ** change these NOT just mini **
//buzzBotMiniWireBlockFoot();
//buzzBotMiniWireBlockFoot(wireType="bristle", buzzBotLegsThick = 8 );
//buzzBotMiniShaftWeight();

// parts for BuzzBot big
//buzzBotBigShaftWeight(length=50);
//buzzBotBigShaftWeight(length=100);
buzzBotBigShaftWeight(length=50);



// these simple elements are called by the other main types

//rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=20, holeOffset=0, nutOffset=0 );
//batteryHolderCase();
//simpleMotorCase();
//wireLockBlock();
//wireLockBlock(wireType="bristle");
//switchCase();


// connector for dowels
//rodClamp()


// ========================================================



// body wall thickness gets used in a bunch of calculations below
bodyWallThick = 1.5;
bodyFloorThick = bodyWallThick*2;

// -------------------------------------
// Battery settings

// these first three need to change depending on battery type
batteryDiameter = 15; // AAA:actual 10.5,use 11, AA: actual 14.5, use 15
batteryLength = 50.5; // AAA: actual 44.5, AA=50.5;  
batteryTerminalWidth = 11; // AAA=9, AA=11; width and height same

// this is for using one of the manufactured battery holders
batteryHolder_AA_1X = [ 17, 57 ];
batteryHolder_AA_2X = [ 31.9, 56.8 ];
batteryHolder_AA_4X = [ 63.5, 58 ];
batteryHolderSize = batteryHolder_AA_2X; // 1x=[ 17, 57 ], 2x=[ 31.9, 56.8 ], 4x=[ 63.5, 58 ]different than the 1x, why?

batteryHolderBoltInset_AA_1X = [ 2.5, 5 ];
batteryHolderBoltInset_AA_2X = [ 13.5, 5.5 ];
batteryHolderBoltInset_AA_4X = [ 3, 29 ];
batteryHolderBoltInset = batteryHolderBoltInset_AA_2X; // 1x=[2.5,5], 4x=[3,center]

batteryHolderWallHeight = 3;

// these stay the same 
batteryTerminalThick = 1.0; // was 1.6, thickness including bent tab, same for AAA/AA
batteryTerminalTabWidth = 3.5; // was 3.5
batteryTerminalTabThick = 1.5; // was 1.6
batteryTerminalTabRatio = 0.3; // where the triangle split occurs
batteryTerminalOpeningWidth = 9; // AAA  7; AA 9
batteryTerminalSlopeMaxWidth = (batteryTerminalWidth+batteryDiameter)/2; // max width of the area  where the terminals begin to slope

// calculate the size of the battery case
batteryCaseSizeOuter = [ 
	batteryHolderSize[0]+(bodyWallThick*2), 
	bodyWallThick+batteryHolderSize[1]+bodyWallThick, 
	batteryHolderWallHeight+bodyFloorThick
];
// the cutout for the battery
batteryCutoutSize = [ 
	batteryHolderSize[0], 
	batteryHolderSize[1], 
	batteryHolderWallHeight+1
];




// -------------------------------------
// Motor settings

// these change depending on the motor
motorBodyDiameter = 19.5; // pager: actual 7.0, use 6.9; hobby: actual 20, use ?
motorBodyLength = 20; // pager: 15 (long), 10 (short); hobby: 25, height 15
motorTopPadding = -5; // pager: 1; hobby: -6? - can be used to solve the non-round hobby motor issue (diameter != height)

// the bumps that help hold the motor in
motorHoldingRailsRadius = 3; // pager 2; hobby 3
motorHoldingRailsOffset = 1.5; // pager 1.5; hobby 2
motorHoldingRailsZoffset = 0.5;

// 
motorRearPadding = 10; 
motorRearNarrow = 10;
motorRearSideCut = 1;
motorSideWallThick = bodyWallThick * 2;
motorBottomWallThick = bodyFloorThick;

motorCaseSizeOuterNoHead = [ 
	(motorBodyDiameter)+(motorSideWallThick*2), 
	bodyWallThick+motorRearPadding+motorBodyLength, 
	(motorBodyDiameter+motorTopPadding)+(motorBottomWallThick*1)
];

motorCutoutSize = [ 
	motorBodyDiameter, 
	motorBodyLength+1, 
	motorBodyDiameter+motorTopPadding+1 
];


// -------------------------------------
// the switch

switchSize = [15,8,15];
switchScrewPlateWidth = 4;
switchScrewSpace = 19;
switchScrewDiameter = M2_boltDiameter;
switchScrewNutHeight = 4;
switchScrewNutZOffset = 5; // from top
switchScrewHoleDepth = 13; // from top
switchCaseSizeOuter = [ switchSize[0]+(bodyWallThick*2)+(switchScrewPlateWidth*2), switchSize[1], switchSize[2]+bodyFloorThick ];



// -------------------------------------
// the overall body
// 
buzzBotBodySizeOuter = [ 
	batteryCaseSizeOuter[0], 
	batteryCaseSizeOuter[1]+switchCaseSizeOuter[1]+motorCaseSizeOuterNoHead[1], 
	batteryCaseSizeOuter[2] 
];

//buzzBotMountSize = [ 10, 4, 30 ];
buzzBotMountTabHoleSpacing = 30;
buzzBotMountTabHolePadding = 5;
buzzBotMountTabSize = [ buzzBotMountTabHoleSpacing+(buzzBotMountTabHolePadding*2), (buzzBotMountTabHolePadding*2), 6 ];
buzzBotMountTabOffsetY = [0,0]; // [front,rear] from end
buzzBotMountTabMinSpacing = 35; // minimum distance between mounts (to allow room for rodClamp), TODO - should be distance between bolt holes



// -------------------------------------
// small, clip-on shaft weight for pager motor
// 
shaftWeightIR = 3.40; // motor diam is 7, was 3.53
shaftWeightTailLength = 10;
//
shaftWeightWallThick = 1.5;
//shaftWeightBaseThick = 0.0;
shaftWeightLength = 3; // the thickness of the weight
shaftWeightOR = shaftWeightIR + shaftWeightWallThick; // shaftWeightIR + shaftWeightWallThick;
shaftWeightCutOffset = 1.5; // from center
shaftWeightTailThick = 10;
shaftWeightTailRingIR = M3_boltDiameter; // for extra weight
shaftWeightRes = 45;
shaftWeightClipCut = 1;





// -------------------------------------
// other items


// "wire" here means wire leg
wireDiameter = 2.7;
wireLockBlockSize = [10,11,10];
wireLockBlockOffsetY = 27; // from center
wireLockBlockOffsetX = 10; // from edge
wireLockBlockNutOffsetZ = 0; // to center the nut over the bolt hole
wireBlockFootTabLength = buzzBotMountTabHoleSpacing + 15;
wireHoleOffsetY =8;
trapNutOffsetY = 3.5;
streetSweeperBristleSize = [4.0, 1.2]; // [width,thickness], actual [3.2,0.6]


// "wire" here means ground wire
groundWireRadius = 1.3;
groundWireHoleOffsetX = -1; // from center
groundWireHoleOffsetZ = -0.5;
groundWireBlockSize = [ 3.5, 3, 2.5 ];
groundWireBlockOffsets = [bodyWallThick+batteryTerminalThick,(batteryCaseSizeOuter[1])/2,batteryCaseSizeOuter[1]-groundWireBlockSize[1]-5];
groundWireChannelWidth = batteryTerminalThick; 
groundWireChannelHeight = 4;
hasGroundWireChannels = false;


//$fs=1;


// ========================================================






module buzzBotBigShaftWeight(
	shaftDiameter = 2.8, // actual 2
	width = 7.5,
	length = 20,
	height = 7,
	// use new M type framework in common
	trapNutOffset = 4,
	boltHeadHoleOffset = 3 // from trapNut
	){

	r1 = width;
	r2 = width;

	difference(){
		// main body
		translate([0,0,-(height/2)]) cam(r1,r2,length,height);
		// shaft hole
		cylinder(r=shaftDiameter/2,h=height+1,center=true, $fs=1);
		// trap nut 
		rotate([0,0,180]) translate([0,trapNutOffset,0]) trapNutDie(boltDiameter = M2_boltDiameter, nutHeight = M2_nutHeight, nutDiameterMin = M2_nutDiameterMin, nutDiameterMax = M2_nutDiameterMax, holeLength=length+(r1*2), holeOffset=(length/2)+(r1/2), boltHoleRes=6 );

		// recessed hole for bolt head
		//translate([0,trapNutOffset+boltHeadHoleOffset,0]) rotate([-90,0,0]) cylinder( r=(M2_boltHeadDiameter/2)*(1/sin(60)), h=length+width, center=false, $fn=6 );

		// hole for attaching more weight
		translate([0,length,0]) cylinder(r=(M3_boltDiameter/2)*(1/sin(60)),h=height+1, center=true, $fs=1);
	}
	
}


// -------------------------------------------------------------------------

//simpleMotorCase();

module simpleMotorCase(){
	difference(){
		union(){
			difference(){
			
				// outer cube
				cube(motorCaseSizeOuterNoHead);
				
				// cutout for motor
				translate([ 
					motorSideWallThick, 
					bodyWallThick, 
					motorBottomWallThick]) {

					//motorRearPadding
					translate([ (motorCutoutSize[0]-motorRearNarrow)/2, 0, 0 ]) trapazoid( motorRearNarrow, motorCutoutSize[0], motorRearPadding+0.001, motorCutoutSize[2] );
					// cutout for motor
					translate([ 0, motorRearPadding, 0 ]) cube(motorCutoutSize);

				} // translate
				
			} // difference
		
			// add bumps to keep the motor in place
			// bump
			translate([ motorSideWallThick, bodyWallThick+motorRearPadding, motorBottomWallThick+(motorCutoutSize[2]-1)-motorHoldingRailsRadius+motorHoldingRailsZoffset ]) difference(){
					translate([-motorHoldingRailsOffset,0,0]) rotate([ -90, 0, 0 ]) cylinder(r=motorHoldingRailsRadius, h=motorCutoutSize[1]-1);
					// cube to cutoff
					translate([ -0.001, -1, -motorHoldingRailsRadius ]) mirror([1,0,0]) cube([ motorHoldingRailsRadius*2, motorCutoutSize[1]+2, (motorHoldingRailsRadius*2)+2 ]);
			}// bump 
			translate([ motorSideWallThick+motorCutoutSize[0], bodyWallThick+motorRearPadding, motorBottomWallThick+(motorCutoutSize[2]-1)-motorHoldingRailsRadius+motorHoldingRailsZoffset ]) mirror([1,0,0]) difference(){
					translate([-motorHoldingRailsOffset,0,0]) rotate([ -90, 0, 0 ]) cylinder(r=motorHoldingRailsRadius, h=motorCutoutSize[1]-1);
					// cube to cutoff
					translate([ -0.001, -1, -motorHoldingRailsRadius ]) mirror([1,0,0]) cube([ motorHoldingRailsRadius*2, motorCutoutSize[1]+2, (motorHoldingRailsRadius*2)+2 ]);
			}
			
		}// union - for the bumps
		
		// cuts for allowing the sides to flex out
		translate([ -1, motorCaseSizeOuterNoHead[1]-motorBodyLength-0.001, motorBottomWallThick]) cube([motorCaseSizeOuterNoHead[0]+2, motorRearSideCut, motorCaseSizeOuterNoHead[2]+1 ]);

		//cutout between motor and positive terminal, motorRearNarrow
		translate([ (motorCaseSizeOuterNoHead[0]-motorRearNarrow)/2, -1, motorBottomWallThick ]) cube([ motorRearNarrow, (bodyWallThick*2)+0.002, motorCutoutSize[2]]);

	}// difference - for the rear side cutout

}

// -------------------------------------------------------------------------
//batteryHolderCase();
module batteryHolderCase(
	boltHoleDiameter = M2_boltDiameter
	){
	
	difference(){
		// outer cube
		//echo("batteryCaseSizeOuter",batteryCaseSizeOuter);
		cube(batteryCaseSizeOuter);
		// cutout for battery
		translate([bodyWallThick,bodyWallThick,bodyFloorThick+0.001]) cube(batteryCutoutSize);
		// bolt holes
		translate([ bodyWallThick+batteryHolderBoltInset[0], bodyWallThick+batteryHolderBoltInset[1], -1 ]) cylinder( r=boltHoleDiameter/2, h=bodyFloorThick+2, $fn=boltHoleDiameter*3 );
		translate([ batteryCaseSizeOuter[0]-bodyWallThick-batteryHolderBoltInset[0], batteryCaseSizeOuter[1]-bodyWallThick-batteryHolderBoltInset[1], -1 ]) cylinder( r=boltHoleDiameter/2, h=bodyFloorThick+2, $fn=boltHoleDiameter*3 );

	}
}


// -------------------------------------------------------------------------
// NOTE: I tried to define all the variables here as properties, but... then when I make the body, I need to know the size of the thing to use it in a model. So now I want to make all the variables globals at the top... but then I'm back to that system. hmmm.


module switchCase(
	//switchSize = [16,8,12], // z is from bottom of screw plate ('cause it hangs from that)
	screwPlateWidth = switchScrewPlateWidth, // the metal plate that hangs off the side for mounting
	screwDiameter = switchScrewDiameter,
	wallThick = bodyWallThick,
	floorThick = bodyFloorThick
	){

	caseSize = switchCaseSizeOuter;// [ switchSize[0]+(wallThick*2)+(screwPlateWidth*2), switchSize[1], switchSize[2]+floorThick ];
	custoutSize = [ switchSize[0], switchSize[1]+2, switchSize[2]+1 ];

	//
	difference(){
		// outer case
		cube(caseSize);
		// cutout for switch
		translate([screwPlateWidth+wallThick,-1,floorThick]) cube(custoutSize);

		// screw hole and nut
		translate([ (caseSize[0]/2)-(switchScrewSpace/2), caseSize[1]/2, caseSize[2]-switchScrewNutZOffset ]) cylinder(r=(M2_boltDiameter/2)*.8, h=switchScrewHoleDepth, $fn=M2_boltDiameter*4, center=true ); //rotate([90,0,90]) trapNutDie(channelHeight=caseSize[0]/2, holeLength=switchScrewHoleDepth+0.001, boltDiameter = M2_boltDiameter, nutHeight = M2_nutHeight, nutDiameterMin = M2_nutDiameterMin, nutDiameterMax = M2_nutDiameterMax, horizontal=true);

		translate([ (caseSize[0]/2)+(switchScrewSpace/2), caseSize[1]/2, caseSize[2]-switchScrewNutZOffset ]) cylinder(r=(M2_boltDiameter/2)*.8, h=switchScrewHoleDepth, $fn=M2_boltDiameter*4, center=true ); //rotate([90,0,-90]) trapNutDie(channelHeight=caseSize[0]/2, holeLength=switchScrewHoleDepth+0.001, boltDiameter = M2_boltDiameter, nutHeight = M2_nutHeight, nutDiameterMin = M2_nutDiameterMin, nutDiameterMax = M2_nutDiameterMax, horizontal=true);

	}		
}




// -------------------------------------------------------------------------

// BuzzBot

//buzzBotBody();

module buzzBotBody(){

	tabFrontOffsetX = max( buzzBotMountTabMinSpacing/2, motorCaseSizeOuterNoHead[0]/2 ); // tabFrontOffsetX || buzzBotMountTabMinSpacing
	tabRearOffsetX = max( buzzBotMountTabMinSpacing/2, buzzBotBodySizeOuter[0]/2 ); // tabFrontOffsetX || buzzBotMountTabMinSpacing

	tabFrontFillInBehindGap=tabFrontOffsetX-(motorCaseSizeOuterNoHead[0]/2)+0.001;
	tabRearFillInBehindGap=tabRearOffsetX-(buzzBotBodySizeOuter[0]/2)+0.001;

	difference(){
		union(){
			// battery holder
			batteryHolderCase();
			// switch
			translate([ (batteryCaseSizeOuter[0]-switchCaseSizeOuter[0])/2, batteryCaseSizeOuter[1], 0 ]) switchCase();
			// motor
			translate([ (batteryCaseSizeOuter[0]-motorCaseSizeOuterNoHead[0])/2, batteryCaseSizeOuter[1]+switchCaseSizeOuter[1],0]) simpleMotorCase();
			
				// mount tab left rear
				translate([ 
					(buzzBotBodySizeOuter[0]/2)-tabRearOffsetX-buzzBotMountTabSize[1]+0.001, 
					buzzBotMountTabSize[0]+buzzBotMountTabOffsetY[1],
					0]) rotate([0,0,-90]) buzzBotTabMount( fillInBehindGap=tabRearFillInBehindGap );
				
				// mount tab left front
				translate([
					(buzzBotBodySizeOuter[0]/2)-tabFrontOffsetX-buzzBotMountTabSize[1]+0.001, 
					buzzBotBodySizeOuter[1]-buzzBotMountTabOffsetY[0], 
					0]) rotate([0,0,-90]) buzzBotTabMount( fillInBehindGap=tabFrontFillInBehindGap );

				// mount tab right rear
				translate([ 
					(buzzBotBodySizeOuter[0]/2)+tabRearOffsetX+buzzBotMountTabSize[1]-0.001,
					buzzBotMountTabSize[0]+buzzBotMountTabOffsetY[1],
					0]) rotate([0,0,-90]) mirror([0,1,0]) buzzBotTabMount( fillInBehindGap=tabRearFillInBehindGap );

				// mount tab right front
				translate([
					(buzzBotBodySizeOuter[0]/2)+tabFrontOffsetX+buzzBotMountTabSize[1]-0.001, 
					buzzBotBodySizeOuter[1]-buzzBotMountTabOffsetY[0], 
					0]) rotate([0,0,-90]) mirror([0,1,0]) buzzBotTabMount( fillInBehindGap=tabFrontFillInBehindGap );

				// tail
				translate([(batteryCaseSizeOuter[0]-buzzBotMountTabSize[0])/2,-buzzBotMountTabSize[1]+0.001,0]) rotate([0,0,0]) buzzBotTabMount();
			
		} // union
	

	} // difference
}

// -------------------------------------------------------------------------

//buzzBotBodyNoBattery();

module buzzBotBodyNoBattery(){

	tabFrontOffsetX = max( buzzBotMountTabMinSpacing/2, motorCaseSizeOuterNoHead[0]/2 ); // tabFrontOffsetX || buzzBotMountTabMinSpacing
	tabRearOffsetX = max( buzzBotMountTabMinSpacing/2, buzzBotBodySizeOuter[0]/2 ); // tabFrontOffsetX || buzzBotMountTabMinSpacing

	tabFrontFillInBehindGap=tabFrontOffsetX-(motorCaseSizeOuterNoHead[0]/2)+0.001;
	tabRearFillInBehindGap=tabRearOffsetX-(buzzBotBodySizeOuter[0]/2)+0.001;

	tailTabSpacing = buzzBotMountTabMinSpacing/2;

	difference(){
		union(){
			// battery holder
			//batteryHolderCase();
			// switch
			translate([ (batteryCaseSizeOuter[0]-switchCaseSizeOuter[0])/2, tailTabSpacing, 0 ]) switchCase();
			// motor
			translate([ (batteryCaseSizeOuter[0]-motorCaseSizeOuterNoHead[0])/2, tailTabSpacing+switchCaseSizeOuter[1],0]) simpleMotorCase();
			
				
				// mount tab left front
				translate([
					(buzzBotBodySizeOuter[0]/2)-tabFrontOffsetX-buzzBotMountTabSize[1]+0.001, 
					tailTabSpacing, 
					0]) rotate([0,0,-90]) mirror([1,0,0]) buzzBotTabMount( fillInBehindGap=tabFrontFillInBehindGap );


				// mount tab right front
				translate([
					(buzzBotBodySizeOuter[0]/2)+tabFrontOffsetX+buzzBotMountTabSize[1]-0.001, 
					tailTabSpacing, 
					0]) rotate([0,0,90]) mirror([0,0,0]) buzzBotTabMount( fillInBehindGap=tabFrontFillInBehindGap );

				// tail
				translate([(batteryCaseSizeOuter[0]-buzzBotMountTabSize[0])/2,-buzzBotMountTabSize[1]+0.001,0]) rotate([0,0,0]) buzzBotTabMount( fillInBehindGap=tailTabSpacing);
			
		} // union
	


		//translate([clipHackCaseTranslateTo[0],clipHackCaseTranslateTo[1]-0.001,clipHackCaseTranslateTo[2]-1])roundRectangle([clipHack_outerWidth,clipHack_outerDepth,buzzBotMountTabSize[2]+2], caseCornerRounding );
		//
		translate([(batteryCaseSizeOuter[0]/2),clipHack_boltOffset,-1]) cylinder(r=clipHack_boltCutoutDiameter/2, h=buzzBotMountTabSize[2]+2);

	} // difference

	//
		// the rca jack 
		translate(clipHackCaseTranslateTo) difference() {
			scale(1) import("peripherals v2 - clipHack - case.stl");
		// cutoff back
		translate([-1,clipHack_chopOffset,0]) cube([clipHack_outerWidth+2,clipHack_outerDepth,clipHack_outerHeight]);
	}

}

clipHack_outerWidth = 14;
clipHack_outerDepth = 21;
clipHack_outerHeight = 15;
clipHack_chopOffset = 22;
clipHack_boltOffset = 6.5;
clipHack_boltCutoutDiameter = M3_nutDiameterMax+2;
caseCornerRounding = 3;
clipHackCaseTranslateTo = [(batteryCaseSizeOuter[0]/2)-(clipHack_outerWidth/2), -(buzzBotMountTabSize[1]), buzzBotMountTabSize[2]-0.001]; // caution: clipHack cannot go so low as to raise the floor (else the RCA jack won't fit)



module buzzBotBody_clipHackCover(){
	difference(){
		scale(1) import("peripherals v2 - clipHack - cover.stl");
		translate([-1,clipHack_chopOffset,-1]) cube([clipHack_outerWidth+2,clipHack_outerDepth,clipHack_outerHeight]);
	}
}



// -------------------------------------------------------------------------


module buzzBotTabMount( 
	fillInBehindGap=0
	){
	//
	//buzzBotMountTabSize
	translate([ 0, 0, 0 ]) {
		difference(){
			// tab body
			rotate([0,0,0]) cube( [buzzBotMountTabSize[0],buzzBotMountTabSize[1]+fillInBehindGap,buzzBotMountTabSize[2]] );
			// hole
			translate([ (buzzBotMountTabSize[1]/2), (buzzBotMountTabSize[1]/2), buzzBotMountTabSize[2] ]) rotate([ 90,0,0 ]) rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=buzzBotMountTabSize[2] );
			translate([ (buzzBotMountTabSize[0])-(buzzBotMountTabSize[1]/2), (buzzBotMountTabSize[1]/2), buzzBotMountTabSize[2] ]) rotate([ 90,0,0 ]) rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=buzzBotMountTabSize[2] );
		}
		// add filler behind, for the motor case section (because it is more narrow)
		//translate([ 0, -(batteryCaseSizeOuter[0]-motorCaseSizeOuterNoHead[0])/2, 0 ]) cube([buzzBotMountTabSize[0], fillInBehindGap,buzzBotMountTabSize[2]]);
	}

}

// -------------------------------------------------------------------------



module simpleLeg(
	size = [5,50,3], // outer size: X,Y,Z 
	endRadius = 7 // the round end of the leg, only used if size[0] < endRadius
	){
	
	difference(){
		union(){	
			// the body 
			translate([0,0,0]) cam( size[0]/2, size[0]/2, size[1], size[2] );
			// the ends
			cylinder(r=endRadius, h=size[2]);
			translate([0,size[1],0]) cylinder(r=endRadius, h=size[2]);
		}// union
		// trap nut close end
		translate([0,0,size[2]])  rotate([90,0,0]) trapNutDie(channelHeight=0 ,holeLength=size[2]*2, holeOffset=0, nutOffset=0, nutHeight=size[2] );
		// trap nut far end
		translate([0,size[1],size[2]])  rotate([90,0,0]) trapNutDie(channelHeight=0 ,holeLength=size[2]*2, holeOffset=0, nutOffset=0, nutHeight=size[2] );
	}

}

// -------------------------------------------------------------------------








// -------------------------------------------------------------------------

module buzzBotMiniShaftWeight(){
	$fn=shaftWeightRes;
	union(){
		difference(){
			union(){
				// outer cylinder
				cylinder( r=shaftWeightOR, h=shaftWeightLength );
				// add weight/fin/whatever you call it
				 translate([ 0, -shaftWeightIR-shaftWeightTailLength+shaftWeightTailThick/2, 0 ]) cam( shaftWeightTailThick/2, shaftWeightOR, shaftWeightTailLength, shaftWeightLength ); 
			}// union
			// cutoff flat side of outer
			translate([-shaftWeightOR-1,shaftWeightCutOffset+shaftWeightWallThick,-1]) cube([(shaftWeightOR*2)+2,shaftWeightOR,shaftWeightLength+shaftWeightWallThick+2]);
			translate([0,0,-1]) difference() {
				// inner cylinder
				cylinder( r=shaftWeightIR, h=shaftWeightLength+2 );
				// cutoff flat side of inner
				translate([-shaftWeightIR*2,shaftWeightCutOffset,-1]) cube([(shaftWeightIR*4),shaftWeightIR,shaftWeightLength+4]);
			}
			// cutout to make it a clip
			translate([0,shaftWeightCutOffset-shaftWeightClipCut,-1]) cube([ shaftWeightOR+1, shaftWeightClipCut, shaftWeightLength+2 ]);

			if(shaftWeightTailRingIR>0){
			// hole
				translate([ 0, -shaftWeightTailLength+shaftWeightTailRingIR, -1 ]) cylinder( r=shaftWeightTailRingIR, h=shaftWeightLength+2 );
			}
		}// difference
	
	/*
	if(shaftWeightTailRingIR>0){
	// add hole
	translate([ 0, -shaftWeightTailLength, -1 ]) cylinder( r=shaftWeightTailRingIR, h=shaftWeightLength+2 );
	translate([ 0, -shaftWeightOR-shaftWeightTailLength-shaftWeightTailRingIR-(shaftWeightWallThick/2), 0 ]) difference(){
		// outer
		cylinder( r=shaftWeightTailRingIR+shaftWeightWallThick, h=shaftWeightLength );
		// inner
		translate([ 0, 0, -1 ]) cylinder( r=shaftWeightTailRingIR, h=shaftWeightLength+2 );
	}
	}// if
	*/
	}//union


}

// -------------------------------------------------------------------------





// -------------------------------------------------------


module groundWireBlock(offsetY){
	translate([0,offsetY,0]) difference(){
		union(){
			cube(groundWireBlockSize);
			// support, rightTriangle(size[x,y,z])
			translate([0,0,0]) rotate([-90,0,0]) rightTriangle([ groundWireBlockSize[0], groundWireBlockSize[0], groundWireBlockSize[1] ]);
		}
			// hole for wire
			translate([(groundWireBlockSize[0]/2)+groundWireHoleOffsetX,-1, (groundWireBlockSize[2]/2)+groundWireHoleOffsetZ ]) rotate([-90,0,0]) cylinder(r=groundWireRadius, h=groundWireBlockSize[1]+2, $fn=6);
	}
}


// -------------------------------------------------------

//buzzBotBigWireBlockFoot();

module buzzBotBigWireBlockFoot(
	wireType="bristle",
	buzzBotLegsThick = 4,
	mountBoltSpacing = 25, // make match the rod clamp
	mountTabLength = 40
	){
	
	mountTabCenter = wireLockBlockSize[1] + (mountTabLength/2);

	difference(){
		union(){
			// mount tab
			translate([-(wireLockBlockSize[0]/2),wireLockBlockSize[1]-0.001,0]) cube([wireLockBlockSize[0],mountTabLength+0.001,buzzBotLegsThick]);
			//  block
			translate([-(wireLockBlockSize[0]/2),0,0]) mirror([0,0,0]) wireLockBlock(wireType=wireType);
		} // union
		
		// trap nut
		translate([ 0, mountTabCenter-(mountBoltSpacing/2),buzzBotLegsThick-(M3_nutHeight/3)+0.001 ]) rotate([ 90,0,0 ]) rotate([0,0,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0 );
		translate([ 0, mountTabCenter+(mountBoltSpacing/2),buzzBotLegsThick-(M3_nutHeight/3)+0.001 ]) rotate([ 90,0,0 ]) rotate([0,0,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0 );

	} // difference
}


// -------------------------------------------------------


module buzzBotMiniWireBlockFoot(
	wireType="wire",
	buzzBotLegsThick = 6
	){
	difference(){
		union(){
			// cube leading up to block
			translate([-(wireLockBlockSize[0]/2),0,0]) cube([wireLockBlockSize[0],wireBlockFootTabLength+0.001,buzzBotLegsThick]);
			//  block
			translate([-(wireLockBlockSize[0]/2),wireLockBlockSize[1]+wireBlockFootTabLength,0]) mirror([0,1,0]) wireLockBlock(wireType=wireType);
		} // union
		
		// trap nut
		translate([ 0, (wireBlockFootTabLength/2)-(buzzBotMountTabHoleSpacing/2),buzzBotLegsThick-(M2_nutHeight/2)+0.001 ]) rotate([ 90,0,0 ]) rotate([0,0,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0 );
		translate([ 0, (wireBlockFootTabLength/2)+(buzzBotMountTabHoleSpacing/2),buzzBotLegsThick-(M2_nutHeight/2)+0.001 ]) rotate([ 90,0,0 ]) rotate([0,0,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0 );

	} // difference
}

// wireBlockFootTabLength, buzzBotMountTabHoleSpacing

// -------------------------------------------------------------------------
module wireLockBlock( 
	wireRad=wireDiameter/2, 
	boltRad=boltDiameter/2,
	wireType = "wire",
	bristleSize= streetSweeperBristleSize
	){

	bristleHoleSize = [ bristleSize[0], bristleSize[1], wireLockBlockSize[2]+1 ];

	difference(){
		cube(wireLockBlockSize);
		// wire hole vert
		translate([ wireLockBlockSize[0]/2, wireHoleOffsetY, wireLockBlockSize[2]/2 ])  rotate([0,0,0]) {
			if(wireType=="bristle"){
				cube(bristleHoleSize, center=true);
			}else{
				cylinder(r=wireRad, h=wireLockBlockSize[2]+2, center=true,$fn=6);
			}
		}
		// wire hole horz
		translate([wireLockBlockSize[0]/2, wireHoleOffsetY, wireLockBlockSize[2]/2 ]) rotate([0,90,0]) {
			if(wireType=="bristle"){
				cube(bristleHoleSize, center=true);
			}else{
				rotate([0,0,30]) cylinder(r=wireRad, h=wireLockBlockSize[2]+2, center=true,$fn=6);
			}
		}
		// trap nut
		translate([ wireLockBlockSize[0]/2, trapNutOffsetY, wireLockBlockSize[2]/2 ]) trapNutDie(channelHeight=wireLockBlockSize[2], holeOffset=-1, holeLength=11, nutOffset=wireLockBlockNutOffsetZ);
	} // difference

}





