// OpenSCAD 2019.05
// Yeti Drain Knob, REV-001
// Joe Haas, KE0FF, 01/06/2022
// This is an enclosure for the Tiva 1294 LP eval-board.
//
// Rev-1.1, 9/03/2024
//	Cleanup and comments
//	Added chams to the USB and PGM openings
//	PGM opening now has a parameter switch to disable
//	Added multiple "cham" variables for the different chamfer sites
//
// Rev-001, 1/9/2022
//	Initial project...
//

//use <threads.scad>

//----------------------------------------------------------------------------------------------------------------------
// User defined parameters.  Modify these to suit a particular application
// NOTE: All data in this file is in mm
//----------------------------------------------------------------------------------------------------------------------
// parametric variables:

tlip = 4;					// lid side-wall thickness (overall lid thick is tlip+ttop)
twid = 57;
tlen = 125;
tht1 = 10.1;
tht = 19-tlip;
twall = 4;
tbot = 5;
ttop = 2;					// lid top-wall thickness
mtgdia = .09*25.4/2;
thrudia = .1*25.4/2;		// mtg holes.  0.1" is for #2 self-threadding type
csinkdia = 4.5;
csinkht = 2.25;
cham = 3;					// edge/corner chams
chamo = 1.5;				// opening chams
chame = 2;					// end-cap chams

/////////////////////////////////////////////////////
// main STL rendering struct  To generate parts for 3D print, comment-off all parts except the one desired.
//	print-ready orientation simplifies the slicer import.  Don't enable print-ready for a mock-up view
// The LID module has text which can be customized if desired (my main use-case was to use the LP as a
//	programmer POD for non LP Tiva designs... a lot cheaper than a commercial programming pod).
//


// print ready orientation
//translate([0,0,tht+tlip+tbot+ttop]) rotate([0,180,0]) lid();
//translate([0,-tlen,tht+(2*tlip)+ttop+twall]) rotate([0,180,0]) end_cover();

///////////////////////////

translate([0,0,.03]) lid();

end_cover();

box();

///////////////////////////////////////////////////////////////////////////////////////////////
// MODULES... /////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////
// This is an exaggerated/simplified model of the LP PCB used as a cut-frame for PCB artifacts
//	such as the Ethernet connector, USB connector, switches, etc...
//	Set "pgm = 0" when instantiating the module to remove the PGMR cable opening (noted below)
//
module tiva_lp_1294(pgm=1, lower=1){
	translate([0,0,8.3]){
		// PCB
		cube([twid,tlen,1.6]);
		// pgmr USB
		translate([42.4,0,1.6]) cube([15,20,10], center=true);
		if(lower == 1){
			translate([42.4,-twall-.01+chamo,1.6+(5/2)]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r1=(20)/2, r2=((20+1.5)/2)+chamo, h=chamo, $fn=4);
		}else{
			translate([42.4,-twall-.01+chamo,1.6-(5/2)]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r1=(20)/2, r2=((20+1.5)/2)+chamo, h=chamo, $fn=4);
		}
		// targ USB
		translate([24.3,tlen,1.6]) cube([15,20,10], center=true);
		if(lower == 1){
			translate([24.3,tlen+twall+.01,1.6+(5/2)]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r2=(20)/2, r1=((20+1.5)/2)+chamo, h=chamo, $fn=4);
		}else{
			translate([24.3,tlen+twall+.01,1.6-(5/2)]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r2=(20)/2, r1=((20+1.5)/2)+chamo, h=chamo, $fn=4);
		}
		// Ethernet
		translate([36.5,110,1.6]) cube([20,16+(2*twall),15], center=false);
		if(pgm){
			// pgmr cable exit - this opening is to break-out the programmer signals.  It may be omitted if not needed
			translate([-2*twall,56,1.6]) cube([20,14,5], center=false);
			// opening chams
			if(lower == 1){
				translate([-twall-.01,56+7,1.6+7]) rotate([0,90,0]) rotate([0,0,45]) cylinder(r2=(19)/2, r1=((20+1.5)/2)+chamo, h=chamo, $fn=4);
			}else{
				translate([-twall-.01,56+7,1.6-7+5]) rotate([0,90,0]) rotate([0,0,45]) cylinder(r2=(19)/2, r1=((20+1.5)/2)+chamo, h=chamo, $fn=4);
			}
		}
		// PWR LED (ortho + VERT) - these openings expose the power LED present on the LP PCB
		translate([twid-1, 35.2,2.5]) rotate([0,90,0]) cylinder(r=2, h=15, $fn=20);
		translate([twid-1+twall, 35.2,2.5]) rotate([0,90,0]) cylinder(r1=2, r2=4, h=3, $fn=20);
		translate([twid-1, 35.2,2.5]) rotate([0,0,0]) cylinder(r=2, h=15, $fn=20);
		translate([twid-1, 35.2,tht+tbot+ttop-csinkht+.05-8.3-1.7]) cylinder(r1=2, r2=4, h=3, $fn=20);
	}
	// holes for mtg-boss screws
	translate([21.9,29.5,1]) cylinder(r=.1*25.4/2, h=10, $fn=16);
	translate([52.3,41.9,1]) cylinder(r=.1*25.4/2, h=10, $fn=16);
	translate([16.9,103,1]) cylinder(r=.1*25.4/2, h=10, $fn=16);
}

//////////////////////////////
// Main LP enclosure "box"
//
module box(){
	difference(){
		union(){
			difference(){
				// main body and hog-out
				cube([twid+(2*twall),tlen+(2*twall),tht+tbot]);
				translate([twall,twall,tbot]) cube([twid,tlen,tht+tlip]);
				// lid mtg holes
				translate([twall/2,10,tbot+.1]) cylinder(r=mtgdia, h=15, $fn=16);
				translate([twid+(3*twall/2),10,tbot+.1]) cylinder(r=mtgdia, h=15, $fn=16);
	
				translate([twall/2,tlen-10,tbot+.1]) cylinder(r=mtgdia, h=15, $fn=16);
				translate([twid+(3*twall/2),tlen-10,tbot+.1]) cylinder(r=mtgdia, h=15, $fn=16);
	
				translate([twall/2,(tlen/2)-8,tbot+.1]) cylinder(r=mtgdia, h=15, $fn=16);
				translate([twid+(3*twall/2),tlen/2,tbot+.1]) cylinder(r=mtgdia, h=15, $fn=16);
				// debug-section
//				cube([150,60,100], center=true);
			}
			// LP mounting bosses
			translate([twall+21.9,twall+29.5,.1]) cylinder(r=8/2, h=14, $fn=16);
			translate([twall+21.9,twall+29.5,twall-.1]) cylinder(r2=8/2, r1 = 14/2, h=5, $fn=16);
			translate([twall+52.3,twall+41.9,.1]) cylinder(r=8/2, h=14, $fn=16);
			translate([twall+52.3,twall+41.9,twall-.1]) cylinder(r2=8/2, r1 = 14/2, h=5, $fn=16);
			translate([twall+16.9,twall+103,.1]) cylinder(r=8/2, h=14, $fn=16);
			translate([twall+16.9,twall+103,twall-.1]) cylinder(r2=8/2, r1 = 14/2, h=5, $fn=16);
			// signature/rev
			translate([45,14,twall+.9]) rotate([0,0,90]) linear_extrude(.8) text("by KE0FF V1.1", size=5);					// 3D version & PN text
		}
		// LP artifacts
		translate([twall,twall,tbot+.5]) tiva_lp_1294();
		// edge chams
		rotate([45,0,0]) cube([160,cham,cham], center=true);
		translate([0,tlen+(2*twall),0]) rotate([45,0,0]) cube([160,cham,cham], center=true);
		rotate([0,45,0]) cube([cham,280,cham], center=true);
		translate([twid+(2*twall),0,0]) rotate([0,45,0]) cube([cham,280,cham], center=true);
		// corner chams
		rotate([0,0,45]) cube([cham,cham,80], center=true);
		translate([twid+(2*twall),0,0]) rotate([0,0,45]) cube([cham,cham,80], center=true);
		translate([0,tlen+(2*twall),0]) rotate([0,0,45]) cube([cham,cham,80], center=true);
		translate([twid+(2*twall),tlen+(2*twall),0]) rotate([0,0,45]) cube([cham,cham,80], center=true);
		// end-cover mtg
		translate([twall/2,tlen-3,15]) cylinder(r=mtgdia, h=15, $fn=16);
		translate([twid+(3*twall/2),tlen-3,15]) cylinder(r=mtgdia, h=15, $fn=16);
	}
}



//////////////////////////////
// Main LP enclosure "LID"
//
module lid(){
	difference(){
		union(){
			difference(){
				// main lid "body"
				translate([0,0,tht+tbot]) cube([twid+(2*twall),tlen+(2*twall),ttop+tlip]);
				translate([twall,twall,tbot]) cube([twid,tlen,tht+tlip]);
				// lid mtg
				translate([twall/2,10,tbot+.1]) cylinder(r=thrudia, h=25, $fn=16);
				translate([twid+(3*twall/2),10,tbot+.1]) cylinder(r=thrudia, h=25, $fn=16);
	
				translate([twall/2,tlen-10,tbot+.1]) cylinder(r=thrudia, h=25, $fn=16);
				translate([twid+(3*twall/2),tlen-10,tbot+.1]) cylinder(r=thrudia, h=25, $fn=16);
	
				translate([twall/2,(tlen/2)-8,tbot+.1]) cylinder(r=thrudia, h=25, $fn=16);
				translate([twid+(3*twall/2),tlen/2,tbot+.1]) cylinder(r=thrudia, h=25, $fn=16);
				// lid csink
				translate([twall/2,10,tht+tlip+tbot+ttop-csinkht+.05]) cylinder(r1=0, r2=csinkdia/2, h=csinkht, $fn=16);
				translate([twid+(3*twall/2),10,tht+tlip+tbot+ttop-csinkht+.05]) cylinder(r1=0, r2=csinkdia/2, h=csinkht, $fn=16);
	
				translate([twall/2,tlen-10,tht+tlip+tbot+ttop-csinkht+.05]) cylinder(r1=0, r2=csinkdia/2, h=csinkht, $fn=16);
				translate([twid+(3*twall/2),tlen-10,tht+tlip+tbot+ttop-csinkht+.05]) cylinder(r1=0, r2=csinkdia/2, h=csinkht, $fn=16);
	
				translate([twall/2,(tlen/2)-8,tht+tlip+tbot+ttop-csinkht+.05]) cylinder(r1=0, r2=csinkdia/2, h=csinkht, $fn=16);
				translate([twid+(3*twall/2),tlen/2,tht+tlip+tbot+ttop-csinkht+.05]) cylinder(r1=0, r2=csinkdia/2, h=csinkht, $fn=16);

				// end-cover mtg
				translate([twall/2,tlen-3,15]) cylinder(r=mtgdia, h=15, $fn=16);
				translate([twid+(3*twall/2),tlen-3,15]) cylinder(r=mtgdia, h=15, $fn=16);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// customize the following text to match the desired application
				translate([25,10,25.1]) rotate([0,0,90]) linear_extrude(1) text("Tiva PGMR", size=10);
				translate([40,12,25.1]) rotate([0,0,90]) linear_extrude(1) text("de KE0FF", size=7);					// model# texts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			}
		}
		// LP artifacts
		translate([twall,twall, tbot]) tiva_lp_1294(lower = 0);
		// corner chams
		rotate([0,0,45]) cube([cham,cham,80], center=true);
		translate([twid+(2*twall),0,0]) rotate([0,0,45]) cube([cham,cham,80], center=true);
		translate([0,tlen+(2*twall),0]) rotate([0,0,45]) cube([cham,cham,80], center=true);
		translate([twid+(2*twall),tlen+(2*twall),0]) rotate([0,0,45]) cube([cham,cham,80], center=true);
	}
}


///////////////////////////////////////////////////////////////////////////////////////////
// Main LP enclosure end-cover.  Used to cover the Ethernet connector if it is not needed.
//
module end_cover(){
ec_ztop = tht+tbot+(2*(ttop+tlip));
ec_ytop = 23+twall;
ecx = twid+(2*twall);

	difference(){
		translate([0,tlen+(2*twall),tht+tbot+(2*(ttop+tlip))-20]) cube([ecx,twall,20]);
		// corner chams
		translate([0,tlen+(3*twall),0]) rotate([0,0,45]) cube([chame,chame,80], center=true);
		translate([twid+(2*twall),tlen+(3*twall),0]) rotate([0,0,45]) cube([chame,chame,80], center=true);
		// end chams
		translate([(twid+(2*twall))/2,tlen+(1.25*twall)-20+ec_ytop,ec_ztop]) rotate([0,90,0]) rotate([0,0,45]) cube([chame,chame,80], center=true);
		translate([(twid+(2*twall))/2,tlen+(1.25*twall)-20+ec_ytop,ec_ztop-20]) rotate([0,90,0]) rotate([0,0,45]) cube([chame,chame,80], center=true);
		// bottom chams
		translate([0,tlen+(1.25*twall)-20+ec_ytop,ec_ztop-20]) rotate([90,0,0]) rotate([0,0,45]) cube([chame,chame,80], center=true);
		translate([twid+(2*twall),tlen+(1.25*twall)-20+ec_ytop,ec_ztop-20]) rotate([90,0,0]) rotate([0,0,45]) cube([chame,chame,80], center=true);
		// inside chams
		translate([0,tlen+(2*twall),0]) rotate([0,0,45]) cube([chame,chame,(ec_ztop-ttop-tlip)*2], center=true);
		translate([twid+(2*twall),tlen+(2*twall),0]) rotate([0,0,45]) cube([chame,chame,(ec_ztop-ttop-tlip)*2], center=true);
	}
	difference(){
		union(){
			difference(){
				translate([0,tlen+(2*twall)-23,tht+tbot+ttop+tlip]) cube([ecx,23,ttop+tlip]);
				translate([twall,twall,tbot]) cube([twid,tlen,tht+tlip]);

				// end-cover mtg
				translate([twall/2,tlen-3,20]) cylinder(r=mtgdia, h=15, $fn=16);
				translate([twid+(3*twall/2),tlen-3,20]) cylinder(r=mtgdia, h=15, $fn=16);
				// end-cover csink
				translate([twall/2,tlen-3,tht+tlip+(2*(tbot+ttop))-(1.4*csinkht)+.05]) cylinder(r1=0, r2=csinkdia/2, h=csinkht, $fn=16);
				translate([twid+(3*twall/2),tlen-3,tht+tlip+(2*(tbot+ttop))-(1.4*csinkht)+.05]) cylinder(r1=0, r2=csinkdia/2, h=csinkht, $fn=16);

			}
		}
		// LP artifacts
		translate([twall,twall, tbot]) tiva_lp_1294();
		// corner chams
		translate([0,tlen+(1.25*twall)-20,0]) rotate([0,0,45]) cube([chame,chame,80], center=true);
		translate([twid+(2*twall),tlen+(1.25*twall)-20,0]) rotate([0,0,45]) cube([chame,chame,80], center=true);
		// end chams
		translate([(twid+(2*twall))/2,tlen+(1.25*twall)-20,ec_ztop]) rotate([0,90,0]) rotate([0,0,45]) cube([chame,chame,80], center=true);
	}
}

/////////////////////////
// debug artifacts
//
// X-rulers
//#translate([-.69,0,0]) cube([0.01,30,50]);	// ruler
//#translate([175.41,0,0]) cube([0.01,30,50]);	// inside main void ruler 1
//#translate([1.67,0,0]) cube([0.01,30,50]);	// inside main void ruler 2
//#translate([175.34,0,0]) cube([0.01,30,50]);	// outside shroud ruler 2
// Y-rulers
//#translate([0,23.81,0]) cube([180,0.01,50]);	// ruler
//#translate([0,22.36 ,0]) cube([180,0.01,50]);	// ruler
// Z-rulers
//#translate([0,0,0]) cube([10,40,.01]);	// ruler
//#translate([0,0,2.04]) cube([9,40,.01]);	// ruler

// EOF
