
//include<RatsoShapeLibrary.scad>
include<common.scad>


bodyWallThick = 1.5;

aaaBatteryRadius = 5.5;
aaaBatteryLength = 44; // 44 for the battery + spring compression
aaaTerminalWidth = 9; // actual 8; width and height same
aaaTerminalThick = 1.4;
aaaTerminalTabWallWidth = 1.5; 
aaaTerminalTabWallThick = 1.5; 
aaaTerminalOpeningWidth = 8;
//aaaTerminalTabThick = 1.5; // how thick the tab needs, though it does compress
//aaaTerminalTabOffset = 3; // from the edge

aaaBatteryCaseSizeOuter = [ 
	(aaaBatteryRadius*2)+(bodyWallThick*2), 
	bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+aaaBatteryLength+aaaTerminalThick+aaaTerminalTabWallThick+bodyWallThick, 
	(aaaBatteryRadius*2)+(bodyWallThick*1) 
];

motorBodyDiameter = 7; // actual 7.0
motorBodyLength = 20; 
motorShaftDiameter =  (aaaBatteryRadius*2); // includes weight, etc. - total clearance, just use the maximum, same as battery
motorShaftLength = 7; // again, total clearance
motorOverallLength = motorBodyLength + motorShaftLength;

motorCaseSizeOuter = [ 
	(aaaBatteryRadius*2)+(bodyWallThick*2), 
	bodyWallThick+motorOverallLength+bodyWallThick, 
	(aaaBatteryRadius*2)+(bodyWallThick*1)
];

flexMotorMountBoltHoleOffset = 1; // from center


mountRingOR = 5;
mountRingIR = 2;
caseMountLoopHeight = 3;
caseMountLoopOffsetX = 6;
caseMountLoopOffsetY = mountRingOR;

vibroBotBodySizeOuter = [ 
	(aaaBatteryRadius*2)+(bodyWallThick*2), 
	bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+aaaBatteryLength+aaaTerminalThick+aaaTerminalTabWallThick+bodyWallThick+motorOverallLength+bodyWallThick, 
	(aaaBatteryRadius*2)+(bodyWallThick*1) 
];

batteryCutoutSize = [ (aaaBatteryRadius*2), aaaBatteryLength, (aaaBatteryRadius*2) ];

extraMotorDrop = 2; // drop the motor down into the case a little more
motorCutoutSize = [ motorBodyDiameter, motorOverallLength, motorBodyDiameter+extraMotorDrop ];
motorShaftCutoutSize = [ motorShaftDiameter, motorShaftLength, motorShaftDiameter+extraMotorDrop ];


// "wire" here means wire leg
wireDiameter = 3.5;
wireLockBlockSize = [10,10,10];
wireLockBlockOffsetY = 33; // from center
wireLockBlockOffsetX = 10; // from edge
wireLockBlockNutOffsetZ = 0; // to center the nut over the bolt hole

wireHoleOffsetY =7;
trapNutOffsetY = 4.0;

// "wire" here means ground wire
groundWireRadius = 1.3;
groundWireHoleOffsetX = -1; // from center
groundWireBlockSize = [3.5,3,4];
groundWireBlockOffsets = [2.5,25,50];


// 
hexBodyRadius = (aaaBatteryCaseSizeOuter[1]/2) + 10;
hexBodyBaseThick = 1.5;

$fs=1;


// ================================

vibroBotBody();
//vibroBotHexBody(flexMotorMount=true);
//flexMotorCase();
//flexMotorMount();

//wireLockBlock();
//simpleBatteryCase();
//simpleMotorCase();

// ===================================


// -------------------------------------------------------------------------
module simpleMotorCase(){
	difference(){
		// outer cube
		cube(motorCaseSizeOuter);
		translate([ 
			(vibroBotBodySizeOuter[0]-motorBodyDiameter)/2, 
			bodyWallThick, 
			vibroBotBodySizeOuter[2]-motorCutoutSize[2]+0.001]) {
			//
			// cutout for motor
			cube(motorCutoutSize);
			// cutout for the motor shaft (the vibration weight)
			translate([-(motorShaftDiameter-motorBodyDiameter)/2,motorBodyLength,-(motorShaftDiameter-motorBodyDiameter)/2]) cube(motorShaftCutoutSize);		
		} // translate
	}
}

// -------------------------------------------------------------------------
module flexMotorCase(){
	union(){
	difference(){
		// outer cube
		cube(motorCaseSizeOuter);
		// cutout for motor
		translate([ (vibroBotBodySizeOuter[0]-motorBodyDiameter)/2, bodyWallThick, 	vibroBotBodySizeOuter[2]-motorCutoutSize[2]+0.001]) cube(motorCutoutSize);
		// cutoff the motor shaft section
		translate([-1,bodyWallThick+motorBodyLength,-1]) cube([motorCaseSizeOuter[0]+2,motorShaftCutoutSize[1]+bodyWallThick+1,motorCaseSizeOuter[2]+2]);		
	} // difference

	// add joint for hinge
	difference(){
		union(){
			translate([motorCaseSizeOuter[0]/2, -(motorCaseSizeOuter[2]/2)/sin(60), motorCaseSizeOuter[2]/2]) rotate([180,90,0]) rotate([0,0,30]) cylinder(r=(motorCaseSizeOuter[2]/2)/sin(60), h=motorCaseSizeOuter[0]/2, $fn=6);
			// filler cube
			translate([0,-(motorCaseSizeOuter[2]/2)/sin(60),0]) cube([motorCaseSizeOuter[0]/2,(motorCaseSizeOuter[2]/2)/sin(60),motorCaseSizeOuter[2]]); //(motorCaseSizeOuter[2]/2)/sin(60)
		}
		// nut hole 
		translate([(nutHeight/2)-1,-(motorCaseSizeOuter[2]/2)/sin(60),motorCaseSizeOuter[2]/2]) rotate([0,90,0]) rotate([0,0,30]) {
			cylinder(r=nutHoleDiam/2, h=nutHeight+1, center=true,$fn=6);
			//
			cylinder(r=boltDiameter/2, h=motorCaseSizeOuter[0],$fn=6);
		}
	}// difference for hinge hole
	} // union
}
module flexMotorMount(hasNut=false){
	translate([0,0,0]) rotate([-90,0,0]){

	// add joint for hinge
	difference(){
		union(){
			translate([motorCaseSizeOuter[0]/2, -(motorCaseSizeOuter[2]/2)/sin(60), motorCaseSizeOuter[2]/2]) rotate([180,90,0]) rotate([0,0,30]) cylinder(r=(motorCaseSizeOuter[2]/2)/sin(60), h=motorCaseSizeOuter[0]/2, $fn=6);
			// filler cube
			translate([0,-(motorCaseSizeOuter[2]/2)/sin(60),0]) cube([motorCaseSizeOuter[0]/2,(motorCaseSizeOuter[2]/2)/sin(60),motorCaseSizeOuter[2]]); //(motorCaseSizeOuter[2]/2)/sin(60)
		}
		
		translate([-1,-(motorCaseSizeOuter[2]/2)/sin(60)-flexMotorMountBoltHoleOffset, (motorCaseSizeOuter[2]/2) ]) rotate([0,90,0]) rotate([0,0,30]) {
			// nut hole 
			if(hasNut){ cylinder(r=nutHoleDiam/2, h=nutHeight+1, center=false,$fn=6); }
			// bolt hole
			cylinder(r=boltDiameter/2, h=motorCaseSizeOuter[0],$fn=6);
		}
	}// difference for hinge hole
	}// translate all

}

// -------------------------------------------------------------------------
module simpleBatteryCase(){
	difference(){
		// outer cube
		cube(aaaBatteryCaseSizeOuter);
		// cutout for battery
		translate([bodyWallThick,bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick,bodyWallThick+0.001]) cube(batteryCutoutSize);
		// cutout for battery terminals
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalWidth)/2, bodyWallThick, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ aaaTerminalWidth, aaaTerminalThick, aaaTerminalWidth*2 ]);
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalOpeningWidth)/2, bodyWallThick+aaaTerminalThick-0.01, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ aaaTerminalOpeningWidth, aaaTerminalTabWallThick+0.02, aaaTerminalWidth*2 ]);
		
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalWidth)/2, bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]+aaaTerminalTabWallThick, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ aaaTerminalWidth, aaaTerminalThick, aaaTerminalWidth*2 ]);
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalOpeningWidth)/2, bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]-0.01, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ aaaTerminalOpeningWidth, aaaTerminalTabWallThick+0.02, aaaTerminalWidth*2 ]);
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
		
		}//union - main body
		
		// cutout for battery
		translate([bodyWallThick,bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick,bodyWallThick+0.001]) cube(batteryCutoutSize);

		// cutout for motor
		translate([ 
			(vibroBotBodySizeOuter[0]-motorBodyDiameter)/2, 
			bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]+aaaTerminalThick+aaaTerminalTabWallThick+bodyWallThick, 
			vibroBotBodySizeOuter[2]-motorCutoutSize[2]+0.001]) {
			//
			cube(motorCutoutSize);
			// cutout for the motor shaft (the vibration weight)
			translate([-(motorShaftDiameter-motorBodyDiameter)/2,motorBodyLength,-(motorShaftDiameter-motorBodyDiameter)/2]) cube(motorShaftCutoutSize);
		}
		
		// cutout for battery terminals
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalWidth)/2, bodyWallThick, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ aaaTerminalWidth, aaaTerminalThick, aaaTerminalWidth*2 ]);
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalOpeningWidth)/2, bodyWallThick+aaaTerminalThick-0.01, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ aaaTerminalOpeningWidth, aaaTerminalTabWallThick+0.02, aaaTerminalWidth*2 ]);
		
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalWidth)/2, bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]+aaaTerminalTabWallThick, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ aaaTerminalWidth, aaaTerminalThick, aaaTerminalWidth*2 ]);
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalOpeningWidth)/2, bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]-0.01, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ aaaTerminalOpeningWidth, aaaTerminalTabWallThick+0.02, aaaTerminalWidth*2 ]);
		
		
	} // difference


	
	} // union
}


module groundWireBlock(offsetY){
	translate([0,offsetY,0]) union(){
		difference(){
			cube(groundWireBlockSize);
			// hole for wire
			translate([(groundWireBlockSize[0]/2)+groundWireHoleOffsetX,-1,groundWireBlockSize[2]/2]) rotate([-90,0,0]) cylinder(r=groundWireRadius, h=groundWireBlockSize[1]+2, $fn=6);
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
		translate([ wireLockBlockSize[0]/2, trapNutOffsetY, wireLockBlockSize[2]/2 ]) trapNutDie(channelHeight=wireLockBlockSize[2], holeOffset=-1, holeLength=11, nutOffset=wireLockBlockNutOffsetZ);
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

