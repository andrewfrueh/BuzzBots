
include<RatsoShapeLibrary.scad>
include<common.scad>


bodyWallThick = 1.5;

aaaBatteryRadius = 5.5;
aaaBatteryLength = 46; // 44 for the battery + spring compression
aaaTerminalWidth = 9; // actual 8; width and height same
aaaTerminalThick = 1.4;
aaaTerminalTabWallWidth = 1.5; 
aaaTerminalTabWallThick = 1.5; 
//aaaTerminalTabThick = 1.5; // how thick the tab needs, though it does compress
//aaaTerminalTabOffset = 3; // from the edge

motorBodyDiameter = 7.0; // actual 7.0
motorBodyLength = 18; 
motorShaftDiameter = 8; // includes weight, etc. - total clearance
motorShaftLength = 7; // again, total clearance
motorOverallLength = motorBodyLength + motorShaftLength;


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
motorCutoutSize = [ motorBodyDiameter, motorOverallLength, motorBodyDiameter ];
motorShaftCutoutSize = [ motorShaftDiameter, motorShaftLength, motorShaftDiameter ];


wireDiameter = 2;
boltDiameter = 3.8;
wireLockBlockSize = [10,10,10];

wireHoleOffsetY = 7;
trapNutOffsetY = 3.5;


$fs=1;


// ================================

vibroBotBody();
//wireLockBlock();

// ===================================


module vibroBotBody(){
		//
		openingWidth = aaaTerminalWidth-(aaaTerminalTabWallWidth*2);
	//	
	union(){
	difference(){
		union(){
			cube(vibroBotBodySizeOuter);
			// the mount holes // ring(od, id, height) 
			translate([ 0, caseMountLoopOffsetY, 0 ]) makeCaseLoop();
			translate([  vibroBotBodySizeOuter[0], caseMountLoopOffsetY, 0 ]) rotate([0,0,180]) makeCaseLoop();
			translate([ (vibroBotBodySizeOuter[0]/2), vibroBotBodySizeOuter[1], 0 ]) rotate([0,0,-90]) makeCaseLoop();
			//translate([  vibroBotBodySizeOuter[0], vibroBotBodySizeOuter[1], 0 ]) rotate([0,0,180]) makeCaseLoop();
		}//union - main body

		// cutout for battery
		translate([bodyWallThick,bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick,bodyWallThick+0.001]) cube(batteryCutoutSize);
		// cutout for motor
		translate([ (vibroBotBodySizeOuter[0]-motorBodyDiameter)/2, bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]+aaaTerminalThick+aaaTerminalTabWallThick+bodyWallThick, vibroBotBodySizeOuter[2]-motorCutoutSize[2]+0.001]) {
			cube(motorCutoutSize);
			// cutout for the motor shaft (the vibration weight)
			translate([-(motorShaftDiameter-motorBodyDiameter)/2,motorBodyLength,-(motorShaftDiameter-motorBodyDiameter)/2]) cube(motorShaftCutoutSize);
		}
		
		// cutout for battery terminals
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalWidth)/2, bodyWallThick, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ aaaTerminalWidth, aaaTerminalThick, aaaTerminalWidth*2 ]);
		translate([ (vibroBotBodySizeOuter[0]-openingWidth)/2, bodyWallThick+aaaTerminalThick-0.01, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ openingWidth, aaaTerminalTabWallThick+0.02, aaaTerminalWidth*2 ]);
		
		translate([ (vibroBotBodySizeOuter[0]-aaaTerminalWidth)/2, bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]+aaaTerminalTabWallThick, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ aaaTerminalWidth, aaaTerminalThick, aaaTerminalWidth*2 ]);
		translate([ (vibroBotBodySizeOuter[0]-openingWidth)/2, bodyWallThick+aaaTerminalThick+aaaTerminalTabWallThick+batteryCutoutSize[1]-0.01, (vibroBotBodySizeOuter[2]-aaaTerminalWidth)/2 ]) cube([ openingWidth, aaaTerminalTabWallThick+0.02, aaaTerminalWidth*2 ]);
		
		
	} // difference


	
	} // union
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
		translate([ wireLockBlockSize[0]/2, trapNutOffsetY, wireLockBlockSize[2]/2 ]) trapNutDie(channelHeight=wireLockBlockSize[2]);
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

