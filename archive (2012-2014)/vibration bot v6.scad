

// ========================================================

// Main function calls. Build things here.


// the basic body, for both types
//buzzBotBody();

// parts for BuzzBot mini
// DELETE - buzzBotMiniLeg();
//simpleLeg( [5,50,3], 7); // default for BuzzBot mini
//simpleLeg( [8,100,8], 8); // default for BuzzBot big

// ** change these NOT just mini **
//buzzBotMiniWireBlockFoot();
//buzzBotMiniWireBlockFoot(wireType="bristle");
//buzzBotMiniShaftWeight();

// parts for BuzzBot big
//buzzBotBigShaftWeight();



// these simple elements are called by the other main types

//rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=20, holeOffset=0, nutOffset=0 );
//simpleBatteryCase();
//simpleMotorCase();
//wireLockBlock();
//wireLockBlock(wireType="bristle");


// connector for dowels
//rodClamp()


// ========================================================


include<common.scad>


// body wall thickness gets used in a bunch of calculations below
bodyWallThick = 1.5;


// -------------------------------------
// Battery settings

// these first three need to change depending on battery type
batteryDiameter = 15; // AAA:actual 10.5,use 11, AA: actual 14.5, use 15
batteryLength = 50.5; // AAA: actual 44.5, AA=50.5;  
batteryTerminalWidth = 11; // AAA=9, AA=11; width and height same

// these stay the same 
batteryTerminalThick = 1.0; // was 1.6, thickness including bent tab, same for AAA/AA
batteryTerminalTabWidth = 3.5; // was 3.5
batteryTerminalTabThick = 1.5; // was 1.6
batteryTerminalTabRatio = 0.3; // where the triangle split occurs
batteryTerminalOpeningWidth = 9; // AAA  7; AA 9
batteryTerminalSlopeMaxWidth = (batteryTerminalWidth+batteryDiameter)/2; // max width of the area  where the terminals begin to slope

// calculate the size of the battery case
batteryCaseSizeOuter = [ 
	(batteryDiameter)+(bodyWallThick*2), 
	bodyWallThick+batteryTerminalThick+batteryTerminalTabThick+batteryLength+batteryTerminalThick+batteryTerminalTabThick+bodyWallThick, 
	(batteryDiameter)+(bodyWallThick*1) 
];
// the cutout for the battery
batteryCutoutSize = [ (batteryDiameter), batteryLength, (batteryDiameter) ];

// the cutout that makes it easy to remove the battery
batteryCaseSideCutout = [ batteryLength, batteryLength-(batteryDiameter*2), batteryDiameter ]; //[top, bottom, height]



// -------------------------------------
// Motor settings

// these change depending on the motor
motorBodyDiameter = 19.5; // pager: actual 7.0, use 6.9; hobby: actual 20, use ?
motorBodyLength = 25; // pager: 15 (long), 10 (short); hobby: 25, height 15
motorTopPadding = -7; // pager: 1; hobby: -6? - can be used to solve the non-round hobby motor issue (diameter != height)

// the bumps that help hold the motor in
motorHoldingRailsRadius = 2; // pager 2; hobby 3
motorHoldingRailsOffset = 1.5; // pager 1.5; hobby 2

// 
motorRearPadding = 5; 
motorRearNarrow = 3;
motorRearSideCut = 1;
motorSideWallThick = bodyWallThick * 2;
motorBottomWallThick = bodyWallThick * 2;

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
// the overall body
// 
buzzBotBodySizeOuter = [ 
	batteryCaseSizeOuter[0], 
	batteryCaseSizeOuter[1]+motorCaseSizeOuterNoHead[1], 
	batteryCaseSizeOuter[2] 
];

//buzzBotMountSize = [ 10, 4, 30 ];
buzzBotMountTabSize = [ 10, 10, 4 ];
buzzBotMountTabOffsetY = [10,3]; // [front,rear] from end



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
shaftWeightTailRingIR = boltRadius; // for extra weight
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
wireBlockFootTabLength = 15;
wireHoleOffsetY =8;
trapNutOffsetY = 3.5;
streetSweeperBristleSize = [4.0, 1.2]; // [width,thickness], actual [3.2,0.6]


// "wire" here means ground wire
groundWireRadius = 1.3;
groundWireHoleOffsetX = -1; // from center
groundWireHoleOffsetZ = -0.5;
groundWireBlockSize = [3.5,3,4];
groundWireBlockOffsets = [bodyWallThick+batteryTerminalThick,(batteryCaseSizeOuter[1])/2,batteryCaseSizeOuter[1]-groundWireBlockSize[1]];
groundWireChannelWidth = batteryTerminalThick; 
groundWireChannelHeight = 4;




//$fs=1;


// ========================================================


/* ################## MOVED TO FABRICATION/ROBOTICS #######################

//rodClamp(rodDiameter=13.7, boltSpacing=35); // 1/2 in dowel

//rodClamp(rodDiameter=9, boltSpacing=25); // 5/16 in dowel

rodClamp(rodDiameter=7.3, boltSpacing=20); // 1/4 in dowel


module rodClamp(
	bodyWall = 4.4,
	rodDiameter = 7.3, // .25in dowel is 6.3mm, .5in dowel is 12.7mm
	rodFloor = 2, // space below the rod
	boltDiameter = M3_boltDiameter,
	boltSpacing = 20,
	type = "A"
	){
	bodyHeight = rodDiameter+rodFloor-(rodDiameter*0.2); // was 8
	bodyDiameter = boltSpacing + boltDiameter + (bodyWall);// was 30,
	boltInset = (bodyDiameter-boltSpacing)/4; // channel for the bolt, from edge
	rodInset = bodyHeight-rodFloor; // 0 is no floor

	//
	difference(){
		//
		cylinder(r=bodyDiameter/2, h=bodyHeight, $fn=bodyDiameter*2);
		//
		translate([0,0,bodyHeight+(rodDiameter/2)-rodInset]) rotate([0,90,0]) cylinder(r=rodDiameter/2, h=bodyDiameter+1, center=true, $fn=rodDiameter*4);
		translate([-(bodyDiameter/2)-1,-(rodDiameter/2),bodyHeight+(rodDiameter/2)-rodInset]) cube([bodyDiameter+2,rodDiameter,(rodDiameter/2)+rodInset+1]);
		
		if(type=="A"){
			// make the cutout for bolt channel
			difference(){
				translate([0,0,bodyHeight/2]) rotate_extrude($fn=boltSpacing*4) translate([(boltSpacing/2),0,0]) square([boltDiameter,bodyHeight+2], center=true);
				translate([-(bodyDiameter/2)-1,-(rodDiameter/2)-(bodyWall/2),0]) cube([bodyDiameter+2,rodDiameter+(bodyWall),bodyHeight+4]);
			}
		}else if(type=="B"){
			/*
			rotate([0,0,270+asin( ((rodDiameter/2)+bodyWall) / (boltSpacing/2) )]) translate([0,boltSpacing/2,bodyHeight/2]) rotate([90,0,180]) trapNutDie( holeLength=10, holeOffset=0, boltHoleRes=20, horizontal=true );
			rotate([0,0,90+asin( ((rodDiameter/2)+bodyWall) / (boltSpacing/2) )]) translate([0,boltSpacing/2,bodyHeight/2]) rotate([90,0,180]) trapNutDie( holeLength=10, holeOffset=0, boltHoleRes=20, horizontal=true );
			*/

			//
			rotate([0,0,270+asin( ((rodDiameter/2)+bodyWall) / (boltSpacing/2) )]) translate([0,boltSpacing/2,-0.001]) rotate([90,0,180]) trapNutDie( holeLength=10, holeOffset=5, boltHoleRes=20, horizontal=true, channelHeight=0, nutOffset=0, nutHeight=M3_nutHeight*1.5 );
			rotate([0,0,90+asin( ((rodDiameter/2)+bodyWall) / (boltSpacing/2) )]) translate([0,boltSpacing/2,-0.001]) rotate([90,0,180]) trapNutDie( holeLength=10, holeOffset=5, boltHoleRes=20, horizontal=true, channelHeight=0, nutOffset=0, nutHeight=M3_nutHeight*1.5  );
			
		}
		
	}
}
############################################  */






module buzzBotBigShaftWeight(
	shaftDiameter = 2.8, // actual 2
	r1 = 7.5,
	r2 = 7.55,
	length = 20,
	height = 7,
	// use new M type framework in common
	trapNutOffset = 5
	){

	difference(){
		// main body
		translate([0,0,-(height/2)]) cam(r1,r2,length,height);
		// shaft hole
		cylinder(r=shaftDiameter/2,h=height+1,center=true);
		//
		translate([0,trapNutOffset,0]) trapNutDie(boltDiameter = M2_boltDiameter, nutHeight = M2_nutHeight, nutDiameterMin = M2_nutDiameterMin, nutDiameterMax = M2_nutDiameterMax, holeLength=length+(r1*2), holeOffset=(r1), boltHoleRes=6 );
		// recessed hole for bolt head
		translate([0,trapNutOffset+r1,0]) rotate([-90,0,0]) cylinder( r=(M2_boltHeadDiameter/2)*(1/sin(60)), h=length, center=false, $fn=6 );
		// hole for attaching more weight
		translate([0,length,0]) cylinder(r=(M3_boltDiameter/2)*(1/sin(60)),h=height+1, center=true, $fn=6);
	}
	
}


// -------------------------------------------------------------------------
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
					// cutout for the motor shaft (the vibration weight), not used if no head
				} // translate
				
			} // difference
		
			// add bumps to keep the motor in place
			// bump
			translate([ motorSideWallThick, bodyWallThick+motorRearPadding, motorBottomWallThick+(motorCutoutSize[2]-1)-motorHoldingRailsRadius ]) difference(){
					translate([-motorHoldingRailsOffset,0,0]) rotate([ -90, 0, 0 ]) cylinder(r=motorHoldingRailsRadius, h=motorCutoutSize[1]-1);
					// cube to cutoff
					translate([ -0.001, -1, -motorHoldingRailsRadius ]) mirror([1,0,0]) cube([ motorHoldingRailsRadius*2, motorCutoutSize[1]+2, (motorHoldingRailsRadius*2)+2 ]);
			}// bump 
			translate([ motorSideWallThick+motorCutoutSize[0], bodyWallThick+motorRearPadding, motorBottomWallThick+(motorCutoutSize[2]-1)-motorHoldingRailsRadius ]) mirror([1,0,0]) difference(){
					translate([-motorHoldingRailsOffset,0,0]) rotate([ -90, 0, 0 ]) cylinder(r=motorHoldingRailsRadius, h=motorCutoutSize[1]-1);
					// cube to cutoff
					translate([ -0.001, -1, -motorHoldingRailsRadius ]) mirror([1,0,0]) cube([ motorHoldingRailsRadius*2, motorCutoutSize[1]+2, (motorHoldingRailsRadius*2)+2 ]);
			}
			
		}// union - for the bumps
		
		// cuts for allowing the sides to flex out
		translate([ -1, motorCaseSizeOuterNoHead[1]-motorBodyLength-0.001, motorBottomWallThick]) cube([motorCaseSizeOuterNoHead[0]+2, motorRearSideCut, motorCaseSizeOuterNoHead[2]+1 ]);

	}// difference - for the rear side cutout

}

// -------------------------------------------------------------------------
module simpleBatteryCase(){
	difference(){
		// outer cube
		cube(batteryCaseSizeOuter);
		// cutout for battery
		translate([bodyWallThick,bodyWallThick+batteryTerminalThick+batteryTerminalTabThick,bodyWallThick+0.001]) cube(batteryCutoutSize);

		// cutout for battery terminals

		// REAR
		translate([ 0, bodyWallThick, bodyWallThick ]) batteryTerminalCutout();

		// FRONT
		translate([ 
			0, //buzzBotBodySizeOuter[0], 
			bodyWallThick+batteryTerminalThick+batteryTerminalTabThick+batteryCutoutSize[1]+batteryTerminalThick+batteryTerminalTabThick, 
			bodyWallThick
			]) mirror([ 0, 1, 0 ]) batteryTerminalCutout();//rotate([ 0,0,180 ])
		
		//  to remove the battery easily
		translate([-1+bodyWallThick+2, (batteryCaseSizeOuter[1]-batteryCaseSideCutout[0])/2, batteryCaseSideCutout[2]+bodyWallThick+1]) rotate([-90,0,90]) trapazoid( batteryCaseSideCutout[0], batteryCaseSideCutout[1], batteryCaseSideCutout[2]+1, bodyWallThick+2 );

		translate([-1, (batteryCaseSizeOuter[1]-batteryCaseSideCutout[1])/2, -1]) cube([ batteryCaseSizeOuter[0]/2, batteryCaseSideCutout[1], bodyWallThick+2 ]);

	}
}

//

module batteryTerminalCutout(){

	trapazoidWidthSmall = (batteryCutoutSize[0]-batteryTerminalTabWidth)/2;
	trapazoidWidthBig = max(batteryTerminalWidth,batteryTerminalSlopeMaxWidth);

	union(){
		
		// slot for the actual terminal
		translate([ (buzzBotBodySizeOuter[0]-batteryTerminalWidth)/2, 0, max( 0, (buzzBotBodySizeOuter[2]-batteryTerminalWidth)/2 ) ]) cube([ batteryTerminalWidth, batteryTerminalThick, buzzBotBodySizeOuter[2] ]);

		// the trapazoids that make up the tabs that come in to hold the terminal in place
		
		// on the side of the terminal
		translate([ (buzzBotBodySizeOuter[0]-batteryTerminalWidth)/2, batteryTerminalThick-0.001, 0 ]) trapazoid( batteryTerminalWidth, (batteryCutoutSize[0]-batteryTerminalTabWidth)/2, (batteryTerminalTabThick*batteryTerminalTabRatio)+0.002, buzzBotBodySizeOuter[2]+2 );
		// on the side of the battery
		translate([ ((buzzBotBodySizeOuter[0]-trapazoidWidthSmall)/2),  batteryTerminalThick+(batteryTerminalTabThick*batteryTerminalTabRatio), 0 ]) trapazoid( trapazoidWidthSmall, trapazoidWidthBig, (batteryTerminalTabThick*(1-batteryTerminalTabRatio))+0.001, buzzBotBodySizeOuter[2]+2 );

		// this clips the tips off the triangular tabs (above)
		translate([ (buzzBotBodySizeOuter[0]-batteryTerminalOpeningWidth)/2, batteryTerminalThick-0.001, 0 ]) cube([ batteryTerminalOpeningWidth, batteryTerminalThick+2, buzzBotBodySizeOuter[2] ]);

	}//union
}



// -------------------------------------------------------------------------

// BuzzBot mini - uses a standard pager motor

module buzzBotBody(){
	difference(){
		union(){
			simpleBatteryCase();
			translate([ (batteryCaseSizeOuter[0]-motorCaseSizeOuterNoHead[0])/2, batteryCaseSizeOuter[1],0]) simpleMotorCase();
			
				// mount tab left rear
				translate([-buzzBotMountTabSize[1]+0.001,buzzBotMountTabSize[0]+buzzBotMountTabOffsetY[1],0]) rotate([0,0,-90]) buzzBotTabMount();
				// mount tab left front
				translate([-buzzBotMountTabSize[1]+((batteryCaseSizeOuter[0]-motorCaseSizeOuterNoHead[0])/2)+0.001,buzzBotMountTabSize[0]+buzzBotBodySizeOuter[1]-buzzBotMountTabSize[1]-buzzBotMountTabOffsetY[0],0]) rotate([0,0,-90]) buzzBotTabMount();
				// mount tab right rear
				translate([buzzBotBodySizeOuter[0]+buzzBotMountTabSize[1]-0.001,buzzBotMountTabOffsetY[1],0]) rotate([0,0,90]) buzzBotTabMount();
				// mount tab right front
				translate([buzzBotBodySizeOuter[0]-((batteryCaseSizeOuter[0]-motorCaseSizeOuterNoHead[0])/2)+buzzBotMountTabSize[1]-0.001,buzzBotBodySizeOuter[1]-buzzBotMountTabSize[1]-buzzBotMountTabOffsetY[0],0]) rotate([0,0,90]) buzzBotTabMount();
				// tail
				translate([(batteryCaseSizeOuter[0]-buzzBotMountTabSize[0])/2,-buzzBotMountTabSize[1]+0.001,0]) rotate([0,0,0]) buzzBotTabMount();
		
				// ground wire channel
				translate([buzzBotBodySizeOuter[0],0,buzzBotBodySizeOuter[2]-groundWireBlockSize[2]]) {
					groundWireBlock(groundWireBlockOffsets[0]);
					groundWireBlock(groundWireBlockOffsets[1]);
					groundWireBlock(groundWireBlockOffsets[2]);
				}
	
		} // union
	
		//cutout between motor and positive terminal, motorRearNarrow
		translate([ (batteryCaseSizeOuter[0]-motorRearNarrow)/2, batteryCaseSizeOuter[1]-bodyWallThick-0.001, batteryCaseSizeOuter[2]-motorCutoutSize[2] ]) cube([ motorRearNarrow, (bodyWallThick*2)+0.002, motorCutoutSize[2]]);
	
		// rear cutout for wire at ground terminal
		translate([ ((batteryCaseSizeOuter[0]-batteryTerminalWidth)/2)+batteryTerminalWidth-0.001, bodyWallThick, batteryCaseSizeOuter[2]-groundWireChannelHeight ]) cube([ ((batteryCaseSizeOuter[0]-batteryTerminalWidth)/2)+0.002, groundWireChannelWidth, groundWireChannelHeight+1 ]);

		// front cutout for wire at ground terminal
		color(255,0,0) translate([ ((batteryCaseSizeOuter[0]-motorRearNarrow)/2)+motorRearNarrow, batteryCaseSizeOuter[1]-0.001, batteryCaseSizeOuter[2]-groundWireChannelHeight ]) cube([ (batteryCaseSizeOuter[0])+0.002, groundWireChannelWidth, groundWireChannelHeight+1 ]);

	} // difference
}

// -------------------------------------------------------------------------


module buzzBotTabMount( fillInBehindGap=0){
	//
	//buzzBotMountTabSize
	translate([ 0, 0, 0 ]) {
		difference(){
			// tab body
			rotate([0,0,0]) cube( [buzzBotMountTabSize[0],buzzBotMountTabSize[1]+fillInBehindGap,buzzBotMountTabSize[2]] );
			// hole
			translate([ buzzBotMountTabSize[0]/2, buzzBotMountTabSize[0]/2,buzzBotMountTabSize[2] ]) rotate([ 90,0,0 ]) rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=buzzBotMountTabSize[2] );
		}
		// add filler behind, for the motor case section (because it is more narrow)
		//translate([ 0, -(batteryCaseSizeOuter[0]-motorCaseSizeOuterNoHead[0])/2, 0 ]) cube([buzzBotMountTabSize[0],1,buzzBotMountTabSize[2]]);
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
	translate([0,offsetY,0]) union(){
		difference(){
			cube(groundWireBlockSize);
			// hole for wire
			translate([(groundWireBlockSize[0]/2)+groundWireHoleOffsetX,-1, (groundWireBlockSize[2]/2)+groundWireHoleOffsetZ ]) rotate([-90,0,0]) cylinder(r=groundWireRadius, h=groundWireBlockSize[1]+2, $fn=6);
		}
		// support, rightTriangle(size[x,y,z])
		translate([0,0,0]) rotate([-90,0,0]) rightTriangle([ groundWireBlockSize[0], groundWireBlockSize[0], groundWireBlockSize[1] ]);
	}
}


// -------------------------------------------------------



module buzzBotMiniWireBlockFoot(
	wireType="wire",
	buzzBotLegsThick = 4
	){
	difference(){
		union(){
			// cube leading up to block
			translate([-(wireLockBlockSize[0]/2),0,0]) cube([wireLockBlockSize[0],wireBlockFootTabLength+0.001,buzzBotLegsThick]);
			//  block
			translate([-(wireLockBlockSize[0]/2),wireLockBlockSize[1]+wireBlockFootTabLength,0]) mirror([0,1,0]) wireLockBlock(wireType=wireType);
		} // union
		
		// trap nut
		translate([ 0, buzzBotMountTabSize[1]/2,buzzBotMountTabSize[2] ]) rotate([ 90,0,0 ]) rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=buzzBotMountTabSize[2] );

	} // difference
}


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





