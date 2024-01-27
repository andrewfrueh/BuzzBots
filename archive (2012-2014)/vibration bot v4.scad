
//include<RatsoShapeLibrary.scad>
include<common.scad>


bodyWallThick = 1.5;

aaaBatteryRadius = 5.5;
aaaBatteryLength = 44; // 44 for the battery + spring compression
aaaTerminalWidth = 9; // actual 8; width and height same
aaaTerminalThick = 1.6;
aaaTerminalTabWallWidth = 3.5; 
aaaTerminalTabWallThick = 1.6; 
aaaTerminalTabWallRatio = 0.3; // where the triangle split occurs
//aaaTerminalOpeningWidth1 = (aaaBatteryRadius*2) - 1;
aaaTerminalOpeningWidth = 7;

aaaBatteryCaseSizeOuter = [ 
	(aaaBatteryRadius*2)+(bodyWallThick*2), 
	bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+aaaBatteryLength+aaaTerminalThick+aaaTerminalTabWallThick+bodyWallThick, 
	(aaaBatteryRadius*2)+(bodyWallThick*1) 
];

motorBodyDiameter = 7; // actual 7.0
motorBodyLength = 17; 
motorRearPadding = 5; 
motorRearNarrow = 4;
motorShaftRadius = 25.5; // this is used for cutout
motorShaftDiameter = motorShaftRadius*2; // should be called "shaftClearance" includes weight, etc. - total clearance, just use the maximum, same as battery
motorShaftLength = 7; // again, total clearance
motorOverallLength = motorRearPadding + motorBodyLength + motorShaftLength;

shaftWeightWallThick = 1.5;
//shaftWeightBaseThick = 0.0;
shaftWeightLength = 4; // the thickness of the weight
shaftWeightIR = 3.53; // motor diam is 7
shaftWeightOR = shaftWeightIR + shaftWeightWallThick; // shaftWeightIR + shaftWeightWallThick;
shaftWeightCutOffset = 1.5; // from center
shaftWeightTailLength = 10;
shaftWeightTailThick = 10;
shaftWeightTailRingIR = 0; // for extra weight
shaftWeightRes = 45;



motorCaseSizeOuter = [ 
	(aaaBatteryRadius*2)+(bodyWallThick*2), 
	bodyWallThick+motorOverallLength+bodyWallThick, 
	(aaaBatteryRadius*2)+(bodyWallThick*1)
];


motorCaseSizeOuterNoHead = [ 
	(aaaBatteryRadius*2)+(bodyWallThick*2), 
	bodyWallThick+motorRearPadding+motorBodyLength, 
	(aaaBatteryRadius*2)+(bodyWallThick*1)
];



flexMotorMountBoltHoleOffset = 1; // from center


mountRingOR = 5;
mountRingIR = 2;

caseMountLoopHeight = 3;
caseMountLoopOffsetX = 6;
caseMountLoopOffsetY = mountRingOR;
//caseMountLoopHoleRadius = 

vibroBotBodySizeOuter = [ 
	(aaaBatteryRadius*2)+(bodyWallThick*2), 
	bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+aaaBatteryLength+aaaTerminalThick+aaaTerminalTabWallThick+bodyWallThick+motorOverallLength+bodyWallThick, 
	//bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+aaaBatteryLength+aaaTerminalThick+aaaTerminalTabWallThick+bodyWallThick+motorBodyLength, 
	(aaaBatteryRadius*2)+(bodyWallThick*1) 
];

batteryCutoutSize = [ (aaaBatteryRadius*2), aaaBatteryLength, (aaaBatteryRadius*2) ];

extraMotorDrop = 0; // drop the motor down into the case a little more
motorCutoutSize = [ motorBodyDiameter, motorBodyLength+1, motorBodyDiameter+extraMotorDrop ];
motorShaftCutoutSize = [ motorShaftDiameter, motorShaftLength, motorShaftDiameter ];


// "wire" here means wire leg
wireDiameter = 2.5;
wireLockBlockSize = [10,10,10];
wireLockBlockOffsetY = 27; // from center
wireLockBlockOffsetX = 10; // from edge
wireLockBlockNutOffsetZ = 0; // to center the nut over the bolt hole

wireHoleOffsetY =7;
trapNutOffsetY = 4.3;

// "wire" here means ground wire
groundWireRadius = 1.3;
groundWireHoleOffsetX = -1; // from center
groundWireHoleOffsetZ = -0.5;
groundWireBlockSize = [3.5,3,4];
groundWireBlockOffsets = [2.5,25,50];

// pen holder
penHolderRadius = 8;
penHolderThick = 3;
penHolderOffset = 15; // depth of the pen holder
penHolderLegLength = 25;
penHolderRes = 50;
pivotArmBaseHeight = 20;
pivotArmBaseWidth = 10;
pivotArmLegHeight = 10;
pivotArmLegLength = 20;
pivotArmThick = 3;


// 
hexBodyRadius = (aaaBatteryCaseSizeOuter[1]/2) + 10;
hexBodyBaseThick = 1.5;

flexBotBodySizeOuter = [ aaaBatteryCaseSizeOuter[0], aaaBatteryCaseSizeOuter[1]+motorCaseSizeOuterNoHead[1], aaaBatteryCaseSizeOuter[2] ];
flexBotLegsRadius = aaaBatteryCaseSizeOuter[1]; //flexBotBodySizeOuter[1];
flexBotLegsThick = 4; // height of each leg
flexBotLegsMountAngle = 0;
flexBotMountSize = [ 10, 4, 30 ];
flexBotMountTabSize = [ 10, 4, 10 ];
flexBotMountTabOffsetY = [ 10, 40 ];


$fs=1;


// ================================

//batteryTerminalTest();
//rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=pivotArmThick );

//vibroBotBody();
//vibroBotShaftWeight();

flexBotLegs();
//flexBotBody();

//vibroBotHexBody(flexMotorMount=true);
//flexMotorCase();
//flexMotorMount();

//wireLockBlock();
//simpleBatteryCase();
//simpleMotorCase();

//pivotArm();
//penArm();

// ===================================



module pivotArm(){
	difference(){
		union(){
			// mount arm
			translate([ -(pivotArmBaseWidth/2), 0, 0 ]) cube([ pivotArmBaseWidth, pivotArmThick, pivotArmBaseHeight ]);
			// pivot arm
			translate([-(pivotArmThick/2),pivotArmThick,0]) cube([ pivotArmThick, pivotArmLegLength-(pivotArmLegHeight/2), pivotArmLegHeight ]);
			// pivot arm
			translate([ (pivotArmThick/2), pivotArmThick+pivotArmLegLength-(pivotArmLegHeight/2), (pivotArmLegHeight/2) ]) rotate([ 0, -90, 0 ]) rotate([0,0,30]) cylinder(r=(pivotArmLegHeight/2)/cos(30), h=pivotArmThick, $fn=6);
		}
		// mount hole
		translate([ 0, 0, pivotArmBaseHeight-(pivotArmBaseWidth/2) ]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=0 );
		// pivot hole
		translate([ (pivotArmThick/2), pivotArmThick+pivotArmLegLength-(pivotArmLegHeight/2), (pivotArmLegHeight/2) ]) rotate([ 0, 0, 90 ]) rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=pivotArmThick );
	}
}


// -------

module pivotArmOffCenter(){
	difference(){
		union(){
			// mount arm
			translate([ -(pivotArmBaseWidth/2), 0, 0 ]) cube([ pivotArmBaseWidth, pivotArmThick, pivotArmBaseHeight ]);
			translate([ -penHolderRadius-pivotArmThick, 0, 0 ]){	
				// little connector piece
				cube([ penHolderRadius, pivotArmThick, pivotArmLegHeight ]);
				// pivot arm
				translate([0,pivotArmThick,0]) cube([ pivotArmThick, pivotArmLegLength-(pivotArmLegHeight/2), pivotArmLegHeight ]);
				// pivot arm
				translate([ pivotArmThick, pivotArmThick+pivotArmLegLength-(pivotArmLegHeight/2), (pivotArmLegHeight/2) ]) rotate([ 0, -90, 0 ]) rotate([0,0,30]) cylinder(r=(pivotArmLegHeight/2)/cos(30), h=pivotArmThick, $fn=6);
			}
		}
		// mount hole
		translate([ 0, 0, pivotArmBaseHeight-(pivotArmBaseWidth/2) ]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=0 );
		// pivot hole
		translate([ -penHolderRadius, pivotArmThick+pivotArmLegLength-(pivotArmLegHeight/2), (pivotArmLegHeight/2) ]) rotate([ 0, 0, 90 ]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=pivotArmThick );
	}
}


// -------------------------------------------------------------------------
module penArm(){
	difference(){
		union(){
			translate([penHolderOffset,0,0]) difference() {
				cylinder(r=penHolderRadius+penHolderThick, h=pivotArmLegHeight, $fn=penHolderRes);
				translate([0,0,-1]) cylinder(r=penHolderRadius, h=pivotArmLegHeight+2, $fn=penHolderRes);
				translate([-penHolderRadius-penHolderThick-1,-penHolderRadius-penHolderThick-1,-1]) cube([penHolderRadius+penHolderThick+1,penHolderRadius*3,pivotArmLegHeight+2]);
			}
			// arm
			translate([ 0, penHolderRadius, 0 ]) cube([ penHolderOffset, pivotArmThick, pivotArmLegHeight ]);
			// pivot arm
			translate([ -(pivotArmThick/2),-penHolderRadius,0 ]) cube([ pivotArmThick, (penHolderRadius*2)+pivotArmThick, pivotArmLegHeight ]);
		}
		// pivot hole
		translate([ (pivotArmThick/2), 0, (pivotArmLegHeight/2) ]) rotate([ 0, 0, 90 ]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=0 );
	}
}


// -------------------------------------------------------------------------
module simpleMotorCase(){
	difference(){
		// outer cube
		cube(motorCaseSizeOuterNoHead);
		// cutout for motor
		translate([ 
			(vibroBotBodySizeOuter[0]-motorBodyDiameter)/2, 
			bodyWallThick, 
			vibroBotBodySizeOuter[2]-motorCutoutSize[2]+0.001]) {
			//motorRearPadding
			translate([ (motorCutoutSize[0]-motorRearNarrow)/2, 0, 0 ]) trapazoid( motorRearNarrow, motorCutoutSize[0], motorRearPadding+0.001, motorCutoutSize[2] );
			//
			translate([ 0, motorRearPadding, 0 ]) cube(motorCutoutSize);
			// cutout for the motor shaft (the vibration weight)
			translate([-(motorShaftDiameter-motorBodyDiameter)/2,motorRearPadding+motorBodyLength,-(motorShaftDiameter-motorBodyDiameter)/2]) cube(motorShaftCutoutSize);
		}
	}
}

// -------------------------------------------------------------------------
module simpleBatteryCase(){
	difference(){
		// outer cube
		cube(aaaBatteryCaseSizeOuter);
		// cutout for battery
		translate([bodyWallThick,bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick,bodyWallThick+0.001]) cube(batteryCutoutSize);

		// cutout for battery terminals

		// REAR
		translate([ 0, bodyWallThick, bodyWallThick ]) aaaBatteryTerminalCutout();

		// FRONT
		translate([ 
			0,//vibroBotBodySizeOuter[0], 
			bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]+aaaTerminalThick+aaaTerminalTabWallThick, 
			bodyWallThick
			]) mirror([ 0, 1, 0 ]) aaaBatteryTerminalCutout();//rotate([ 0,0,180 ])
	}
}

// -------------------------------------------------------------------------
module flexBotBody(){
	union(){
		simpleBatteryCase();
		translate([0,aaaBatteryCaseSizeOuter[1]-0.001,0]) simpleMotorCase();
		
		
			// mount
			translate([(aaaBatteryCaseSizeOuter[0]/2)-(flexBotMountSize[1]/2)-flexBotMountSize[1],0.001,0]) difference() {
				rotate([0,0,-90]) cube( [flexBotMountSize[2],flexBotMountSize[1],aaaBatteryCaseSizeOuter[2]] );
				// hole
				translate([ 0,-flexBotMountSize[2]+(aaaBatteryCaseSizeOuter[2]/2),aaaBatteryCaseSizeOuter[2]/2 ]) rotate([ 0, 0, 90 ]) rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=flexBotMountSize[1] );
			}
		
			// ground wire channel
			translate([vibroBotBodySizeOuter[0],0,vibroBotBodySizeOuter[2]-groundWireBlockSize[2]]) {
				groundWireBlock(groundWireBlockOffsets[0]);
				groundWireBlock(groundWireBlockOffsets[1]);
				groundWireBlock(groundWireBlockOffsets[2]);
			}

			//
			flexBotTabMount(offsetY=flexBotMountTabOffsetY[0]);
			flexBotTabMount(offsetY=flexBotMountTabOffsetY[1]);
			

	}
}


module flexBotTabMount(offsetY=0){
	//
	//flexBotMountTabSize
	translate([ bodyWallThick+0.001, offsetY, aaaBatteryCaseSizeOuter[2] ]) {
		difference(){
			// tab body
			rotate([0,0,90]) cube( [flexBotMountTabSize[0],flexBotMountTabSize[1],flexBotMountTabSize[2]] );
			// hole
			translate([ 0, flexBotMountTabSize[0]/2, flexBotMountTabSize[2]-(flexBotMountTabSize[0]/2) ]) rotate([ 0,0,90 ]) rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=flexBotMountSize[1] );
		}
		// support, rightTriangle(size[x,y,z])
		translate([0,0,0]) rotate([-90,0,0]) mirror([1,0,0]) rightTriangle([ flexBotMountTabSize[1], flexBotMountTabSize[1], flexBotMountTabSize[0] ]);
	}

}

// -------------------------------------------------------------------------
module flexBotLegs(){
	cutoffOffsetY = flexBotMountSize[0] * sin(flexBotLegsMountAngle);
		union(){
			//
			for(i = [1:3]){
				rotate([0,0,(360/3)*i]) flexBotLegSingle();
			} // for

			difference(){
			translate([ 0, cutoffOffsetY, -(flexBotLegsThick) ]) rotate([ flexBotLegsMountAngle, 0, 0 ]) {
				difference(){
				// mount for body to attach
				translate([flexBotMountSize[1]/2,-flexBotMountSize[0]/2,flexBotLegsThick-0.001]) rotate([0,0,90]) cube(flexBotMountSize);
				// bolt hole
				translate([ -flexBotMountSize[1]/2, 0, flexBotLegsThick-0.001+flexBotMountSize[2]-(flexBotMountSize[0]/2) ]) rotate([ 0, 0, 90 ]) rotate([0,30,0]) trapNutDie(channelHeight=0 ,holeLength=15, holeOffset=0, nutOffset=0, nutHeight=0 );
				}
			}
			// chop off bottom if it hangs down
			translate([ -flexBotMountSize[1], -flexBotMountSize[0], -(flexBotLegsThick*2)+0.001 ]) cube([ flexBotMountSize[1]*2, flexBotMountSize[0]*2, flexBotLegsThick*2 ]);
			}
		} // union

}

module flexBotLegSingle(){
		union(){
			translate([-(wireLockBlockSize[0]/2),0,0]) cube([wireLockBlockSize[0],flexBotLegsRadius-wireLockBlockSize[1]+0.001,flexBotLegsThick]);
			translate([-(wireLockBlockSize[0]/2),flexBotLegsRadius,0]) mirror([0,1,0]) wireLockBlock();
		}
}


// -------------------------------------------------------------------------
module vibroBotHexBody(flexMotorMount=false){
	difference(){
		union(){
			//
			cylinder(r=hexBodyRadius, h=hexBodyBaseThick);
			//  battery
			translate([-aaaBatteryCaseSizeOuter[0]+(bodyWallThick/2),-aaaBatteryCaseSizeOuter[1]/2,hexBodyBaseThick-bodyWallThick]) simpleBatteryCase();
			// motor
			if(flexMotorMount){
				translate([3,-motorCaseSizeOuter[1]/2,hexBodyBaseThick-bodyWallThick]) flexMotorCase();
			}else{
				translate([-(bodyWallThick/2),-motorCaseSizeOuter[1]/2,hexBodyBaseThick-bodyWallThick]) simpleMotorCase();
			}
			//
			for(i = [1:7]){
				rotate([0,0,(360/6)*i]) translate([-wireLockBlockSize[0]/2,-hexBodyRadius,hexBodyBaseThick]) wireLockBlock();
			} // for
		} // union

		//wireHoleOffsetY
		for(i = [1:7]){
			rotate([0,0,(360/6)*i]) translate([0,-hexBodyRadius+wireHoleOffsetY,-1]) cylinder(r=wireDiameter/2, h=hexBodyBaseThick+2);
		} // for

	} // difference
}

// -------------------------------------------------------------------------

module vibroBotShaftWeight(){
	$fn=shaftWeightRes;
		difference(){
			union(){
				// outer cylinder
				cylinder( r=shaftWeightOR, h=shaftWeightLength );
				// add weight/fin/whatever you call it
				//translate([ -shaftWeightTailThick/2, -shaftWeightTailLength-shaftWeightIR, 0 ]) cube([ shaftWeightTailThick, shaftWeightTailLength+shaftWeightIR, shaftWeightLength ]); 
				 translate([ 0, -shaftWeightIR-shaftWeightTailLength+shaftWeightTailThick/2, 0 ]) cam( shaftWeightTailThick/2, shaftWeightOR, shaftWeightTailLength, shaftWeightLength ); 
			}
			// cutoff flat side of outer
			translate([-shaftWeightOR-1,shaftWeightCutOffset+shaftWeightWallThick,-1]) cube([(shaftWeightOR*2)+2,shaftWeightOR,motorShaftLength+shaftWeightWallThick+2]);
			translate([0,0,-1]) difference() {
				// inner cylinder
				cylinder( r=shaftWeightIR, h=shaftWeightLength+2 );
				// cutoff flat side of inner
				translate([-shaftWeightIR*2,shaftWeightCutOffset,-1]) cube([(shaftWeightIR*4),shaftWeightIR,shaftWeightLength+4]);
			}
		}
	
	if(shaftWeightTailRingIR>0){
	// add ring
	translate([ 0, -shaftWeightOR-shaftWeightTailLength-shaftWeightTailRingIR-(shaftWeightWallThick/2), 0 ]) difference(){
		// outer
		cylinder( r=shaftWeightTailRingIR+shaftWeightWallThick, h=shaftWeightLength );
		// inner
		translate([ 0, 0, -1 ]) cylinder( r=shaftWeightTailRingIR, h=shaftWeightLength+2 );
	}
	}
}

// -------------------------------------------------------------------------

module vibroBotBody(){
		//
	//	
	union(){
	difference(){

		union(){
			cube(vibroBotBodySizeOuter);
			
			// the wire-leg mount blocks
			// left side
			translate([ -wireLockBlockSize[0]-wireLockBlockOffsetX, ((vibroBotBodySizeOuter[1]-wireLockBlockSize[1])/2)-wireLockBlockOffsetY, 0 ]) {
				rotate([0,0,-90]) mirror([1,0,0]) wireLockBlock();
				translate([wireLockBlockSize[0]-0.001,0,0]) cube([wireLockBlockOffsetX+0.002,wireLockBlockSize[1],wireLockBlockSize[2]/2]);// add hip
			}
			translate([ -wireLockBlockSize[0]-wireLockBlockOffsetX, ((vibroBotBodySizeOuter[1]-wireLockBlockSize[1])/2)+wireLockBlockOffsetY, 0 ]) {
				rotate([0,0,-90]) mirror([1,0,0]) wireLockBlock();
				translate([wireLockBlockSize[0]-0.001,0,0]) cube([wireLockBlockOffsetX+0.002,wireLockBlockSize[1],wireLockBlockSize[2]/2]);// add hip
			}
			// right side
			translate([  vibroBotBodySizeOuter[0]+wireLockBlockSize[0]+wireLockBlockOffsetX, ((vibroBotBodySizeOuter[1]-wireLockBlockSize[1])/2)-wireLockBlockOffsetY, 0 ]) {
				rotate([0,0,90]) mirror([0,0,0]) wireLockBlock();
				translate([-wireLockBlockSize[0]-wireLockBlockOffsetX-0.001,0,0]) cube([wireLockBlockOffsetX+0.002,wireLockBlockSize[1],wireLockBlockSize[2]/2]);// add hip
			}
			translate([  vibroBotBodySizeOuter[0]+wireLockBlockSize[0]+wireLockBlockOffsetX, ((vibroBotBodySizeOuter[1]-wireLockBlockSize[1])/2)+wireLockBlockOffsetY, 0 ]) {
				rotate([0,0,90]) mirror([0,0,0]) wireLockBlock();
				translate([-wireLockBlockSize[0]-wireLockBlockOffsetX-0.001,0,0]) cube([wireLockBlockOffsetX+0.002,wireLockBlockSize[1],wireLockBlockSize[2]/2]);// add hip
			}
			// front end
			translate([ (vibroBotBodySizeOuter[0]-wireLockBlockSize[0])/2, vibroBotBodySizeOuter[1]+wireLockBlockSize[1], 0 ]) {
				rotate([0,0,0]) mirror([0,1,0]) wireLockBlock();
			}
			// rear end
			translate([ (vibroBotBodySizeOuter[0]-wireLockBlockSize[0])/2, -wireLockBlockSize[1], 0 ]) {
				rotate([0,0,0]) mirror([0,0,0]) wireLockBlock();
			}

			// ground wire channel
			translate([vibroBotBodySizeOuter[0],0,vibroBotBodySizeOuter[2]-groundWireBlockSize[2]]) {
				groundWireBlock(groundWireBlockOffsets[0]);
				groundWireBlock(groundWireBlockOffsets[1]);
				groundWireBlock(groundWireBlockOffsets[2]);
			}

			// lump for motor shaft
			translate([ ((vibroBotBodySizeOuter[0]-motorShaftCutoutSize[0])/2)-bodyWallThick, vibroBotBodySizeOuter[1]-(bodyWallThick*2)-motorShaftCutoutSize[1], 0 ]) cube([ motorShaftCutoutSize[0]+(bodyWallThick*2), motorShaftCutoutSize[1]+(bodyWallThick*2), vibroBotBodySizeOuter[2] ]);
		
		}//union - main body
		

		// cutout for motor
		translate([ 
			(vibroBotBodySizeOuter[0]-motorBodyDiameter)/2, 
			bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]+aaaTerminalThick+aaaTerminalTabWallThick+bodyWallThick, 
			vibroBotBodySizeOuter[2]-motorCutoutSize[2]+0.001]) {
			//motorRearPadding
			translate([ (motorCutoutSize[0]-motorRearNarrow)/2, 0, 0 ]) trapazoid( motorRearNarrow, motorCutoutSize[0], motorRearPadding+0.001, motorCutoutSize[2] );
			//
			translate([ 0, motorRearPadding, 0 ]) cube(motorCutoutSize);
			// cutout for the motor shaft (the vibration weight)
			translate([-(motorShaftDiameter-motorBodyDiameter)/2,motorRearPadding+motorBodyLength,-(motorShaftDiameter-motorBodyDiameter)/2]) cube(motorShaftCutoutSize);
		}

	
		// cutout for battery
		translate([bodyWallThick,bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick,bodyWallThick+0.001]) cube(batteryCutoutSize);

		// cutout for battery terminals

		// REAR
		translate([ 0, bodyWallThick, bodyWallThick ]) aaaBatteryTerminalCutout();

		// FRONT
		translate([ 
			0,//vibroBotBodySizeOuter[0], 
			bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]+aaaTerminalThick+aaaTerminalTabWallThick, 
			bodyWallThick
			]) mirror([ 0, 1, 0 ]) aaaBatteryTerminalCutout();//rotate([ 0,0,180 ])
			
			
	} // difference


	
	} // union

}






// -------------------------------------------------------

module batteryTerminalTest(){
	//
	difference(){
	cube([ vibroBotBodySizeOuter[0], 10, vibroBotBodySizeOuter[2] ]);
	translate([ 0, bodyWallThick, bodyWallThick ]) aaaBatteryTerminalCutout();
	translate([ bodyWallThick, bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick, bodyWallThick]) cube(batteryCutoutSize);
	}//difference
}

module aaaBatteryTerminalCutout(){
	union(){
		//
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalWidth)/2, 0, max( 0, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ) ]) cube([ aaaTerminalWidth, aaaTerminalThick, vibroBotBodySizeOuter[2] ]);

		//
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalWidth)/2, aaaTerminalThick-0.001, 0 ]) trapazoid( aaaTerminalWidth, (batteryCutoutSize[0]-aaaTerminalTabWallWidth)/2, (aaaTerminalTabWallThick*aaaTerminalTabWallRatio)+0.002, vibroBotBodySizeOuter[2]+2 );
		translate([ (vibroBotBodySizeOuter[0]-((batteryCutoutSize[0]-aaaTerminalTabWallWidth)/2))/2,  aaaTerminalThick+(aaaTerminalTabWallThick*aaaTerminalTabWallRatio), 0 ]) trapazoid( (batteryCutoutSize[0]-aaaTerminalTabWallWidth)/2, batteryCutoutSize[0], (aaaTerminalTabWallThick*(1-aaaTerminalTabWallRatio))+0.001, vibroBotBodySizeOuter[2]+2 );

		// 
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalOpeningWidth)/2, aaaTerminalThick-0.001, 0 ]) cube([ aaaTerminalOpeningWidth, aaaTerminalThick, vibroBotBodySizeOuter[2] ]);

	}//union
}



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


module makeCaseLoop(){
	difference(){
		translate([mountRingOR,0,0]) rotate([0,0,90]) cam( mountRingOR, mountRingOR, caseMountLoopOffsetX+(mountRingOR), caseMountLoopHeight );
		translate([-caseMountLoopOffsetX,0,-1]) cylinder(r=mountRingIR, h=caseMountLoopHeight+2);
	}
}


module wireLockBlock( wireRad=wireDiameter/2, boltRad=boltDiameter/2 ){
	difference(){
		cube(wireLockBlockSize);
		translate([ wireLockBlockSize[0]/2, wireHoleOffsetY, -1 ]) cylinder(r=wireRad, h=wireLockBlockSize[2]+2);
		translate([ wireLockBlockSize[0]/2, trapNutOffsetY, wireLockBlockSize[2]/2 ]) trapNutDie(channelHeight=wireLockBlockSize[2], holeOffset=-1, holeLength=9.5, nutOffset=wireLockBlockNutOffsetZ);
	}
}


/*
module miniCaseBoltBlock(boosterHeight=3){
	blockUnderDepth = boosterHeight;

	translate([0,0,blockUnderDepth+(nutBlockDepth/2)]){
			union(){
				rotate([ 90,0,180 ]) difference() {
					union() translate([ -(nutBlockWidth/2), -(nutBlockDepth/2), 0 ]) {				
						// nut block body
						translate([0,0,0.01]) cube([ nutBlockWidth, nutBlockDepth, nutBlockHeight ]); // the nut-block
						// under block
						if(blockUnderDepth>0){translate([0,-blockUnderDepth+0.01,0.01]) cube([nutBlockWidth,blockUnderDepth,nutBlockHeight]);}
					}//union
					// trap-nut 
					translate([ 0, 0, panelBoltHoleEdgeOffset ]) trapNutDie( holeLength=(nutBlockDepth+blockUnderDepth+0.01), nutHeight=nutHoleHeightHoriz );
				} rotate() difference()
				// support for the bolt-hole
				translate([0,(nutBlockHeight/2), (nutHoleHeightHoriz/2)]) cylinder(r=(boltDiameter/2)+0.1, h=boltHoleSupportThick);
			}// union
	}// translate
}
*/

