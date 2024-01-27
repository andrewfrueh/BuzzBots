
/*

	==========================================
	Ratso's Shape Library
	written by Andrew Frueh (andrewfrueh.com)
	mod: May 2013
	
	 - a collection of shapes used to support the building of objects in OpenSCAD (esp. for 3D printing like Reprap) 
  
	==========================================
	
	The Shapes
 	---
 	
	freeCube(vects[8], bevel) 
	freeTetrahedron(vects[4])
	freePyramid(vects[5])
	roundRectangle(size[x,y,z], rad)
	roundCube(size[x,y,z], rad)
	pill(rad, length)
	cam(rad1, rad2, length, height)
	ring(od, id, height) 
	rightTriangle(size[x,y,z])
	trapazoid( leg1, leg2, length, height )
	filletRectangle(xID, yID, width, height, cutCorners=false, inner=false, activeSide=[1,1,1,1])
	filletCircle(rad, fillX, fillZ, inner=false)
	biscuit(size[x,y,z], sideConvex, bevel=0) 
	bevelRing(OD, ID, height, bevel)
    bevelCube(size[x,y,z], bevel) 
    bevelCylinder(rad, height, bevel) 
    
    
    ----------------------------------
    other notes:
    
    bevelFreeCube() - ## NEED TO BUILD
    
    ## start using bevelRectangle_die()
	
	
    ** roundPolygon() - would be an equalatiral polygon with rounded corners (note: hedron would be awesome, but harder) 
	** lens() - 3D and similar to biscuit
	** freeRoundCube() - would be a freeform rounded cube
	** freeFillet() ?? - could be a set of points and it uses a for() loop to draw the fillet around the object.
    
	#### check the   OpenSCAD Shapes Library (www.openscad.at) for conflicting names, etc. ###
*/

//rightTriangle([25,25,10]);
//trapazoid(20,30,5,2);



// ================================================================================================================
// =====================================        GENERAL FUNCTIONS      ============================================
// ================================================================================================================



// ======================================================
// these functions are taken from the Arduino language

// map( value to map, input range begin, input range end, output range begin, output range end )
function map(x,in_min,in_max,out_min,out_max) = (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;

// constrain( value to constrain, lowest number, highest number )
function constrain(val, low, high) = min( high, max( val, low ) );





// ================================================================================================================
// =====================================             SHAPES            ============================================
// ================================================================================================================




// ======================================================
// freeTetrahedron() - free form tetrahedron, 4 veccts, 4 triangles
//   
module freeTetrahedron( vects ){
	// build the poly
	polyhedron ( points = vects, 
		// winding order - all clockwise
		triangles = [
			[0,1,2], [0,3,1], 
			[0,2,3], [3,2,1]
		]);
}



// ======================================================
// freePyramid() - free form pyramid, 5 vects, 1 rect (bottom) + 4 triangles
//   
module freePyramid( vects ){
	// build the poly
	polyhedron ( points = vects, 
		// winding order - all clockwise
		triangles = [
			[0,1,2], [0,2,3], // rect bottom
			[0,4,1], [0,3,4], [2,1,4], [2,4,3] // triangle sides
		]);
}



/* ======================================================
// freeCube() - freeform cube, 8 vects, 6 rects
 ====================================================== */
//
module freeCube( vects, bevel=0 ){
	// winding order - all clockwise
	polyTriangles = [
			[3,2,1], [3,1,0], 
			[3,0,4], [3,4,7], 
			[3,7,6], [3,6,2], 
			[5,6,7], [5,7,4], 
			[5,1,2], [5,2,6], 
			[5,4,0], [5,0,1]
	];
	// build the poly
	if(bevel>0){
		// with bevel
		union(){
			polyhedron ( points = vects, triangles = polyTriangles );
			// ## BEVEL GOES HERE ##
			//freeCube(); // TOP
		}
	}else{
		// no bevel
		polyhedron ( points = vects, triangles = polyTriangles );
	}
}






/* ======================================================
	roundRectangle() -
		rounding only on x and y (z face is flat), rad is in from corner (0 is no rounding)
 ====================================================== */
//
module roundRectangle( size, rad ){
    union(){
        // 4 corner cylinders
        translate([rad,rad,0]) cylinder(r=rad, h=size[2]);
        translate([size[0]-rad,rad,0]) cylinder(r=rad, h=size[2]);
        translate([size[0]-rad,size[1]-rad,0]) cylinder(r=rad, h=size[2]);
        translate([rad,size[1]-rad,0]) cylinder(r=rad, h=size[2]);
        // 2 fill cubes
        translate([0,rad,0]) cube([size[0], size[1]-(rad*2), size[2]]);
        translate([rad,0,0]) cube([size[0]-(rad*2), size[1], size[2]]);
    }
}




/* ======================================================
	roundCylinder()
		rounding on ends of cylinder
 ====================================================== */
//
module roundCylinder( outerRadius, outerHeight, bevelRadius ){
    union(){
	// 
	cylinder(r=outerRadius-bevelRadius, h=outerHeight);
	translate([0,0,bevelRadius]) cylinder(r=outerRadius, h=outerHeight-(bevelRadius*2));
	translate([0,0,bevelRadius]) rotate_extrude(convexity = 10) translate([outerRadius-bevelRadius, 0, 0]) circle(r = bevelRadius);
	translate([0,0,outerHeight-bevelRadius]) rotate_extrude(convexity = 10) translate([outerRadius-bevelRadius, 0, 0]) circle(r = bevelRadius);
    }
}




/* ======================================================
	roundCube() -
 ====================================================== */
//
module roundCube( size, rad ){
    // corner vectors
    corners = [
        [rad,rad,rad],
        [size[0]-rad,rad,rad],
        [size[0]-rad,rad,size[2]-rad],
        [rad,rad,size[2]-rad],
        [rad,size[1]-rad,rad],
        [size[0]-rad,size[1]-rad,rad],
        [size[0]-rad,size[1]-rad,size[2]-rad],
        [rad,size[1]-rad,size[2]-rad]
    ];
    union(){
        // 8 corner spheres
        translate(corners[0]) sphere(r=rad); // point
        translate(corners[1]) sphere(r=rad);
        translate(corners[2]) sphere(r=rad); // point
        translate(corners[3]) sphere(r=rad);
        translate(corners[4]) sphere(r=rad);
        translate(corners[5]) sphere(r=rad); // point
        translate(corners[6]) sphere(r=rad);
        translate(corners[7]) sphere(r=rad); // point
        
        // 12 edge cylinders done with 4 points
        translate(corners[0]) {
            rotate([0,0,0]) cylinder(r=rad, h=size[2]-(rad*2));
            rotate([-90,0,0]) cylinder(r=rad, h=size[1]-(rad*2));
            rotate([0,90,0]) cylinder(r=rad, h=size[0]-(rad*2));
        }
        translate(corners[2]) {
            rotate([180,0,0]) cylinder(r=rad, h=size[2]-(rad*2));
            rotate([-90,0,0]) cylinder(r=rad, h=size[1]-(rad*2));
            rotate([0,-90,0]) cylinder(r=rad, h=size[0]-(rad*2));
        }
        translate(corners[5]) {
            rotate([0,0,0]) cylinder(r=rad, h=size[2]-(rad*2));
            rotate([90,0,0]) cylinder(r=rad, h=size[1]-(rad*2));
            rotate([0,-90,0]) cylinder(r=rad, h=size[0]-(rad*2));
        }
        translate(corners[7]) {
            rotate([180,0,0]) cylinder(r=rad, h=size[2]-(rad*2));
            rotate([90,0,0]) cylinder(r=rad, h=size[1]-(rad*2));
            rotate([0,90,0]) cylinder(r=rad, h=size[0]-(rad*2));
        }
        // 3 fill cubes
        translate([0,rad,rad]) cube([size[0], size[1]-(rad*2), size[2]-(rad*2)]);
        translate([rad,0,rad]) cube([size[0]-(rad*2), size[1], size[2]-(rad*2)]);
        translate([rad,rad,0]) cube([size[0]-(rad*2), size[1]-(rad*2), size[2]]);
    }
}





/* ======================================================
	pill() - cylinder rounded on both ends
		id: inner diameter, od: outer diameter, height: height
 ====================================================== */
//
module pill(rad, length){
	union(){
		sphere(r=rad);
		translate([0,length,0]) sphere(r=rad);
		rotate([-90,0,0]) cylinder(r=rad, h=length);
	}
}





/* ======================================================
	cam() 
 ====================================================== */
//
module cam(rad1, rad2, length, height){
    tanAngle =  asin( ( rad1 - rad2 ) / length) ;
    hexaX1 = cos(tanAngle) * rad1;
    hexaY1 = sin(tanAngle) * rad1;
    hexaX2 = cos(tanAngle) * rad2;
    hexaY2 = (sin(tanAngle) * rad2) + length;
    //
    union(){
        cylinder(r=rad1, h=height);
        translate([0,length,0]) cylinder(r=rad2, h=height);
        //
        freeCube([
            [0,0,0], [hexaX1,hexaY1,0], [hexaX1,hexaY1,height], [0,0,height],
            [0,hexaY2,0], [hexaX2,hexaY2,0], [hexaX2,hexaY2,height], [0,hexaY2,height]
        ]);
        mirror([1,0,0]) freeCube([
            [0,0,0], [hexaX1,hexaY1,0], [hexaX1,hexaY1,height], [0,0,height],
            [0,hexaY2,0], [hexaX2,hexaY2,0], [hexaX2,hexaY2,height], [0,hexaY2,height]
        ]);
    }
}




/* ======================================================
	ring() - hollow cylinder
		id: inner diameter, od: outer diameter, height: height
 ====================================================== */
//
module ring(od, id, height){
	difference(){
		cylinder(r=od, h=height);
		translate([0,0,-1]) cylinder(r=id, h=height+2);
	}
}





/* ======================================================
	bevelRing() 
		child(0) is the ring to bevel
		bevel1 and bevel2 = [rad, sizeX, sizeZ]
		* does not support cylinders with different radii
		* does not support stacking of multiple calls to get inner and outer - use ring() instead
 ====================================================== */
//
module bevelRing( OD, ID, height, bevel ){

	//bevelRing_full( OD, ID, height, [bevel,bevel], [bevel,bevel], [bevel,bevel], [bevel,bevel] ) child(0);

	bevelInner1 = [ID,bevel,bevel];
	bevelInner2 = [ID,bevel,bevel];
	bevelOuter1 = [OD,bevel,bevel];
	bevelOuter2 = [OD,bevel,bevel];
	
    difference(){
    	// the cylinder to bevel
		if($children==0){
			ring( OD, ID, height );
		}else{
			child(0);
		}
	   	
	   	// inner
	    bevelCircle_die_inner(bevelInner1);
	    translate([0,0,height]) mirror([0,0,1]) bevelCircle_die_inner(bevelInner2);
	   	// outer
	    bevelCircle_die_outer(bevelOuter1);
	    translate([0,0,height]) mirror([0,0,1]) bevelCircle_die_outer(bevelOuter2);
	}
	
}





/* ======================================================
	bevelRing_full() 
		child(0) is the ring to bevel
		bevel1 and bevel2 = [rad, sizeX, sizeZ]
		* does not support cylinders with different radii
		* does not support stacking of multiple calls to get inner and outer - use ring() instead
 ====================================================== */
//
module bevelRing_full( OD, ID, height, ODbevel1, ODbevel2, IDbevel1, IDbevel2 ){
	
	bevelInner1 = [ID,IDbevel1[0],IDbevel1[1]];
	bevelInner2 = [ID,IDbevel2[0],IDbevel2[1]];
	bevelOuter1 = [OD,ODbevel1[0],ODbevel1[1]];
	bevelOuter2 = [OD,ODbevel2[0],ODbevel2[1]];
	
    difference(){
    	// the cylinder to bevel
	   	//ring(id, od, height); 
	   	child(0);
	   	
	   	// inner
	    bevelCircle_die_inner(bevelInner1);
	    translate([0,0,height]) mirror([0,0,1]) bevelCircle_die_inner(bevelInner2);
	   	// outer
	    bevelCircle_die_outer(bevelOuter1);
	    translate([0,0,height]) mirror([0,0,1]) bevelCircle_die_outer(bevelOuter2);
	}
}




/* ======================================================
	rightTriangle() - a right-angle (90 deg.) triangle prism
 ====================================================== */
//
//module rightTriangle(xSize, ySize, zSize){
module rightTriangle(size){
	// build the poly
	polyhedron ( points = [
		[0,0,0], [0,size[1],0], [size[0],0,0], 
		[0,0,size[2]], [0,size[1],size[2]], [size[0],0,size[2]]
	], 
	// winding order - all clockwise
	triangles = [
		[0,1,2], [3,5,4], // the two triangle sides
		[1,0,3], [1,3,4], // the square back
		[0,2,5], [0,5,3], //
		[1,5,2], [1,4,5] 
	]);
}
// wedge() is DEPRICATED - use rightTriangle() instead
module wedge(xSize, ySize, zSize){
	rotate([90,0,0]) mirror([0,0,1]) rightTriangle(xSize, ySize, zSize);
}


// ======================================================
// trapazoid() 
//   
module trapazoid( leg1, leg2, length, height ){
	leg2Offset = (leg1 - leg2) / 2;
	//
	vectsTest = [
		[0,0,0], [0,0,2], [20,0,2], [20,0,0], 
		[5,5,0], [5,5,2], [5+10,5,2], [5+10,5,0]
	];
	vects = [
		[0,0,0], [0,0,height], [leg1,0,height], [leg1,0,0], 
		[leg2Offset,length,0], [leg2Offset,length,height], [leg2Offset+leg2,length,height], [leg2Offset+leg2,length,0]
	];
	//
	freeCube(vects);
}



/* ======================================================
	bevelRightTriangle() - 
		* known bug, this object is invisible unless you use "Compile and Render" (F6)
 ====================================================== */
//
module bevelRightTriangle(xSize, ySize, zSize, bevel){
	
	
	dieRotAngle = atan(xSize/ySize);
	hypotSize = xSize / sin(dieRotAngle);
	
	difference(){
		//
		if($children==0){
			rightTriangle( xSize, ySize, zSize );
		}else{
			child(0);
		}
		// make the bevel model
		// x leg side
		translate([0,0,zSize]) rotate([0,90,0]) bevelRectangle_die( zSize, ySize, bevel, bevel );
		// y leg side
		translate([xSize,0,zSize]) rotate([180,90,-90]) bevelRectangle_die( zSize, xSize, bevel, bevel );
		// hypotenuse
		translate([0,ySize,zSize]) rotate([0,90,-180+dieRotAngle]) bevelRectangle_die( zSize, hypotSize, bevel, bevel );
	}
	
	
	
}



/* ======================================================
	rightTriangle_atAngle()
		auto positions itself off the hypotenuse 1/2 way - just like cone_atAngle()
 ====================================================== */
//
module rightTriangle_atAngle( xSize, height, angle ){
	ySize = xSize * tan(angle);
	translate([-xSize/2,-ySize/2,0]) rightTriangle( xSize, xSize * tan(angle), height );
}



/* ======================================================
	filletRectangle()
		xID and yID - are the fillet Inner Diameter. They define the size of the object you are creating a fillet around.
		width and height - are the size of the fillet itself - x and y size respectively.
		cutCorners - will bevel the corners if set to true
		inner - when set to true, will make the fillet build on the inside of the defined rect
		activeSide - is an array(4) representing the four sides of the rect. This allows you to turn the fillet off for certain sides
		* known bug: if activeSide[0] = 0 and combined with a cube, it will cause non-manifold object. Why?
 ====================================================== */
//
module filletRectangle(xID, yID, xWidth,  yWidth, height, cutCorners=false, inner=false, activeSide=[1,1,1,1]){

	
	
	if(activeSide[0]==1){
		translate([0,0,0]) rotate([0,0,0]) filletRectangle_leg( yID,  yWidth, xWidth, height, cutCorners, activeSide[3]);
	}
	if(activeSide[1]==1){
		translate([0,yID,0]) rotate([0,0,-90]) filletRectangle_leg( xID, xWidth,  yWidth, height, cutCorners, activeSide[0]);
	}
	if(activeSide[2]==1){
		translate([xID,yID,0]) rotate([0,0,180]) filletRectangle_leg( yID,  yWidth, xWidth, height, cutCorners, activeSide[1]);
	}
	if(activeSide[3]==1){
		translate([xID,0,0]) rotate([0,0,90]) filletRectangle_leg( xID, xWidth,  yWidth, height, cutCorners, activeSide[2]);
	}
	
}
// this module is necessary, when I did it in the above function, the model was not manifold
module filletRectangle_leg( legLength, xWidth,  yWidth, height,cutCorners,hasCorner ){
	tetraVects = [ [0,0,0], [xWidth,0,0], [0,yWidth,0], [0,0,height] ];
	pyraVects = [ [0,0,0], [xWidth,0,0], [xWidth,yWidth,0], [0,yWidth,0], [0,0,height] ];
	union(){
		 rotate([90,0,180]) rightTriangle([yWidth,height,legLength]);
		 if(hasCorner==1){
			 if(cutCorners){
				 mirror([1,1,0]) freeTetrahedron(tetraVects);
			}else{
				 mirror([1,1,0]) freePyramid(pyraVects);
			}
		}
	}
}




/* ======================================================
	bevelEdge_die()
DEPRICATED - CRASHES TOO OFTEN
 ====================================================== */
//
module bevelEdge_die( length, xSize, zSize ){
	bevelAngle = atan(zSize/xSize);
	translate([xSize/2,-1,zSize/2]) rotate([90,0,0]) mirror([0,0,1]) rightTriangle_atAngle( xSize+2, length+2, bevelAngle );
}



/* ======================================================
	bevelRectangle_die()
DEPRICATED - CRASHES TOO OFTEN
 ====================================================== */
//
module bevelRectangle_die( xSize, ySize, xBevel, zBevel ){
	bevelAngle = atan(zBevel/xBevel);

	translate([0,0,0]) rotate([0,0,0]) bevelEdge_die( ySize, xBevel, zBevel );
	translate([0,ySize,0]) rotate([0,0,-90]) bevelEdge_die( xSize, xBevel, zBevel );
	translate([xSize,ySize,0]) rotate([0,0,180]) bevelEdge_die( ySize, xBevel, zBevel );
	translate([xSize,0,0]) rotate([0,0,90]) bevelEdge_die( xSize, xBevel, zBevel );
}



/* ======================================================
GRRR, SEEMS LIKE A GOOD IDAE, BUT ON RENDER, SAYS "Simple: no" -- I think that means not manifold
	bevelCube()
		simple bevel done withthree cubes and right-triangles for corners
//
//
module bevelCube( size, bevel ){
	//cubeSizeX = [size[0], size[1]-(bevel*2)];
	union(){
		//
		if($children>0){
			echo("** bevelCube() no longer accepts a child object **");
		}
		// x cube
		translate( [ 0, bevel, bevel ] ) cube( [ size[0], size[1]-(bevel*2), size[2]-(bevel*2) ] );
		// y cube
		translate( [ bevel, 0, bevel ] ) cube( [ size[0]-(bevel*2), size[1], size[2]-(bevel*2) ] );
		// z cube
		translate( [ bevel, bevel, 0 ] ) cube( [ size[0]-(bevel*2), size[1]-(bevel*2), size[2] ] );
		
		//  bevels
		translate([ bevel, bevel, bevel]) rotate([ 0,0,180 ]) rightTriangle([ bevel,bevel,size[2]-(bevel*2) ]);
		// corners
		translate([ 0, 0, 0]) freeTetrahedron([ [0,bevel,bevel], [bevel,0,bevel], [bevel,bevel,0], [bevel,bevel,bevel] ]);
	}
}
 ====================================================== */




/* ======================================================
DELETE - THIS CRASHES A LOT
	bevelCube()
		child(0) is the cube to bevel

//
//
module bevelCube( size, bevel ){
	difference(){
		//
		if($children==0){
			cube([size[0], size[1], size[2]]);
		}else{
			child(0);
		}
		// make the bevel model
		union(){
			// left side
			translate([0,0,0]) rotate([0,0,0]) mirror([0,0,0]) bevelEdge_die( size[1], bevel, bevel );
			translate([0,size[1],0]) rotate([90,0,0]) mirror([0,0,0]) bevelEdge_die( size[2], bevel, bevel );
			translate([0,size[1],size[2]]) rotate([180,0,0]) mirror([0,0,0]) bevelEdge_die( size[1], bevel, bevel );
			translate([0,0,size[2]]) rotate([270,0,0]) mirror([0,0,0]) bevelEdge_die( size[2], bevel, bevel );
			// right side
			translate([size[0],0,0]) rotate([0,0,0]) mirror([1,0,0]) bevelEdge_die( size[1], bevel, bevel );
			translate([size[0],size[1],0]) rotate([90,0,0]) mirror([1,0,0]) bevelEdge_die( size[2], bevel, bevel );
			translate([size[0],size[1],size[2]]) rotate([180,0,0]) mirror([1,0,0]) bevelEdge_die( size[1], bevel, bevel );
			translate([size[0],0,size[2]]) rotate([270,0,0]) mirror([1,0,0]) bevelEdge_die( size[2], bevel, bevel );
			// middle bottom
			translate([size[0],0,0]) rotate([0,0,90]) mirror([0,0,0]) bevelEdge_die( size[0], bevel, bevel );
			translate([0,size[1],0]) rotate([0,0,-90]) mirror([0,0,0]) bevelEdge_die( size[0], bevel, bevel );
			// middle top
			translate([size[0],0,size[2]]) rotate([0,90,90]) mirror([0,0,0]) bevelEdge_die( size[0], bevel, bevel );
			translate([0,size[1],size[2]]) rotate([0,90,-90]) mirror([0,0,0]) bevelEdge_die( size[0], bevel, bevel );
		}
	}
}
 ====================================================== */




/* ======================================================
REDO
	bevelCube_full()
		child(0) is the cube to bevel
		
		12 sides to a cube
		bevelArray = [
			[bevel,bevel], [bevel,bevel], [bevel,bevel], [bevel,bevel],
			[bevel,bevel], [bevel,bevel], [bevel,bevel], [bevel,bevel],
			[bevel,bevel], [bevel,bevel], [bevel,bevel], [bevel,bevel],
		];
 ====================================================== */
//
module bevelCube_full( xSize, ySize, zSize, bevelArray ){
	// 
	echo("bevelCube_full() - NEEDS TO BE BUILT");
}






/* ======================================================
	filletCircle()
 ====================================================== */
//
module filletCircle(rad, fillX, fillZ, inner=false){
	//
	if(inner){
		filletCircle_inner(rad, fillX, fillZ);
	}else{
		filletCircle_outer(rad, fillX, fillZ);
	}
}

module filletCircle_inner(rad, fillX, fillZ){
	//
	cheat = 0.001;
	// inner fillet
	fillBodyRad = rad+fillX; // this is the biggest we need to get
	fillBodyHeight = fillZ;
	fillCutRad1 = rad+fillX;
	fillCutRad2 = rad;
	fillCutHeight = fillZ+(cheat*2);
	
	// same for both inner and outer
	difference(){
		// body shape
		cylinder(r=fillBodyRad, h=fillBodyHeight);
		// punchout
		cylinder(r1=fillCutRad1, r2=fillCutRad2, h=fillCutHeight);
	}
}

module filletCircle_outer(rad, fillX, fillZ){
	//
	// outer fillet
	// same for both inner and outer
	difference(){
		// body shape
		cylinder(r1=rad+fillX, r2=rad, h=fillZ);
		// punchout
		translate([0,0,-1]) cylinder(r=rad, h=fillZ+2);
	}
}




/* ======================================================
	biscuit() - rect rounded on sides, depending on params
		sideConvex[4] are -1 to 1. 0 is flat. 1 is fully convex (same as pill). -1 is fully concave
 ====================================================== */
//
module biscuit(size, sideConvex, bevel=0){
	
	largestRadFactor = 2; // is this okay?
	//
	edge0Rad = pow( size[0]/2, map(asin( 1-abs(sideConvex[0]) ), 0, 90, 1, largestRadFactor) );
	edge1Rad = pow( size[1]/2, map(asin( 1-abs(sideConvex[1]) ), 0, 90, 1, largestRadFactor) );
	edge2Rad = pow( size[0]/2, map(asin( 1-abs(sideConvex[2]) ), 0, 90, 1, largestRadFactor) );
	edge3Rad = pow( size[1]/2, map(asin( 1-abs(sideConvex[3]) ), 0, 90, 1, largestRadFactor) );
	//
	//
	difference(){
		//
		if(bevel>0){
			bevelCube([size[0], size[1], size[2]], bevel) cube([size[0], size[1], size[2]]);
		}else{
			cube([size[0], size[1], size[2]]);
		}
		//
		if(sideConvex[0]>0){
			translate([0,0,0]) rotate([0,0,0]) biscuitEdge( size[0], size[2], edge0Rad, bevel );
		}
		if(sideConvex[1]>0){
			translate([0,size[1],0]) rotate([0,0,-90]) biscuitEdge( size[1], size[2], edge1Rad, bevel );
		}
		if(sideConvex[2]>0){
			translate([size[0],size[1],0]) rotate([0,0,-180]) biscuitEdge( size[0], size[2], edge2Rad, bevel );
		}
		if(sideConvex[3]>0){
			translate([size[0],0,0]) rotate([0,0,-270]) biscuitEdge( size[1], size[2], edge3Rad, bevel );
		}
		//
		//translate([0,0,0]) rotate([0,0,0]) bevelCircle_die_inner([edge0Rad,bevel,bevel]);
	}
}
// this module simply made the above easier
module biscuitEdge( width, height, rad, bevel ){
	// thank you Pythagoras
	c = rad;
	a = width/2;
	b = sqrt( pow(c,2) - pow(a,2) );
	cylinderOffset = b;
	difference(){
		translate([-1,-1,-1]) cube([width+2,rad+1,height+2]);
		//difference(){
		//translate([width/2,rad,0]) bevelCircle_die_outer([rad,bevel,bevel]);
		translate([width/2,rad,0]) cylinder(r=rad, h=height, $fa=5);
		//}
	}
}










/* ======================================================
	bevelCylinder() 
		child(0) is the cylinder to bevel
		bevel1 and bevel2 = [rad, sizeX, sizeZ]
		* does not support cylinders with different radii
		* does not support stacking of multiple calls to get inner and outer - use ring() instead
 ====================================================== */
//
module bevelCylinder( rad, height, bevel ){
    //
    difference(){
    	// the cylinder to bevel
		if($children==0){
			cylinder( r=rad, h=height );
		}else{
			child(0);
		}
	   	// the die that bevels
	    bevelCircle_die_outer([rad,bevel,bevel]);
	    //
	    translate([0,0,height]) mirror([0,0,1]) bevelCircle_die_outer([rad,bevel,bevel]);
	}
}






/* ======================================================
	bevelCylinder_full() 
		child(0) is the cylinder to bevel
		bevel1 and bevel2 = [rad, sizeX, sizeZ]
		* does not support cylinders with different radii
		* does not support stacking of multiple calls to get inner and outer - use ring() instead
 ====================================================== */
//
module bevelCylinder_full( bevel1, bevel2, height ){
    //
    difference(){
    	// the cylinder to bevel
		if($children==0){
			cylinder( r=bevel1, h=height );
		}else{
			child(0);
		}
	   	// the die that bevels
	    bevelCircle_die_outer(bevel1);
	    //
	    translate([0,0,height]) mirror([0,0,1]) bevelCircle_die_outer(bevel2);
	}
}
/* ======================================================
	bevelCircle_die_outer() 
		helper for bevelCylinder()
		child(0) is the cylinder to bevel
		params[3] = [rad, sizeX, sizeZ]
 ====================================================== */
// 
module bevelCircle_die_outer( params ){
	rad = params[0];
	sizeX = params[1];
	sizeZ = params[2];
    punchoutRad = rad-(sizeX/2);
    angle = atan(sizeX/sizeZ);
    
    difference(){
	    // larger shape
	    translate([0,0,-1]) cylinder(r=rad+1, h=sizeZ+2);
	    // punch out
	    translate([0,0,sizeZ/2]) cone_atAngle(punchoutRad, sizeZ+4, angle);
    }
}
/* ======================================================
	bevelCircle_die_inner() 
		helper for bevelCylinder()
		child(0) is the cylinder to bevel
		params[3] = [rad, sizeX, sizeZ]
 ====================================================== */
// 
module bevelCircle_die_inner( params ){
	rad = params[0];
	sizeX = params[1];
	sizeZ = params[2];
    punchoutRad = rad+(sizeX/2);
    angle = -1 * atan(sizeX/sizeZ);
    
    translate([0,0,sizeZ/2]) cone_atAngle(punchoutRad, sizeZ+4, angle);
	
}



/* ======================================================
	cone_atAngle()
		* known bug, if height and angle combination cause rad = 0 or less, then effect is broken - and simply constraining is not enough, you will need to offset height as well
 ====================================================== */
//
module cone_atAngle(rad, height, angle){
	//
	legZ = height;
	legX = height * tan(angle);
	//
	rad1 = rad-legX/2;
	rad2 = rad1 + legX;
	//
	translate([0,0,-(height/2)]) cylinder(r1=rad1, r2=rad2, h=height);
}



