// ChillCore Demo Cup (V0.1) — OpenSCAD
// Author: ChatGPT (for Jason S.)
// License: CC BY-SA 4.0
//
// PURPOSE
// - Print-friendly demo cup to validate UX: ice chamber packing, cap motion, seal fit.
// - Not for food contact or real thermal testing.
// - Uses coarse 3-start trapezoidal threads sized for FDM.
//
// HOW TO USE
// 1) Set which_part = "shell" / "cap" / "both"
// 2) Render (F6), then File → Export → STL for each part.
//    Print with PETG/PLA; add a silicone O-ring per spec below.
//
// MAIN DIMENSIONS (demo size ~120 mm tall)
which_part = "both";        // "shell", "cap", "both"
demo_scale = 1.0;           // scale 1.0 = demo size (~120 mm tall)

// --------- Key Parameters ---------
cup_height        = 120 * demo_scale;   // total body height w/o lid
outer_od          = 86  * demo_scale;   // outer diameter at grip
outer_wall        = 2.4;                // outer shell wall thickness
liner_wall        = 1.2;                // inner liner (printed) wall thickness
fin_count         = 6;                  // number of internal fins
fin_depth         = 5;                  // radial depth of fins
fin_thickness     = 1.2;                // printable fin thickness
ice_gap           = 8;                  // clearance from fin tips to outer shell
rim_bead_h        = 3;                  // cosmetic thickened rim
base_ring_h       = 6;                  // reinforcement ring above threads

// Thread & Seal
thread_pitch      = 3.0;                // coarse for FDM
thread_turns      = 5;                  // number of thread turns
thread_starts     = 3;                  // multi-start for quick on/off
thread_height     = 1.6;                // trapezoid thread height
thread_clearance  = 0.6;                // diametral clearance for FDM fit
o_ring_cs         = 3.0;                // silicone O-ring cross-section (buy part)
o_ring_squeeze    = 0.6;                // radial squeeze (~20% of CS)

// Computed
cap_engage_h      = thread_turns * thread_pitch;
body_id_at_thread = (outer_od - 2*outer_wall) - 2*ice_gap - 2*fin_depth - 2*liner_wall;
outer_thread_dm   = outer_od - 2*outer_wall;
female_major_dm   = outer_thread_dm - thread_clearance;
male_major_dm     = female_major_dm - 0.6;
male_minor_dm     = male_major_dm - 2*thread_height;

assert(body_id_at_thread > 40, "Body inner diameter too small; adjust params");

// ---------- Helpers ----------
module trapezoid_thread(d_major, d_minor, pitch, turns, starts=3, right_handed=true){
    for(i=[0:starts-1]){
        rotate([0,0,360*(i/starts)])
            single_start_trap(d_major, d_minor, pitch, turns, right_handed);
    }
}
module single_start_trap(d_major, d_minor, pitch, turns, right_handed=true){
    h = (d_major - d_minor)/2;
    pts = [
        [0,0],
        [pitch*0.45,0],
        [pitch*0.55,h],
        [0,h]
    ];
    dir = right_handed ? 1 : -1;
    linear_extrude(height=turns*pitch, twist=dir*360*turns, slices=turns*50, convexity=10)
        translate([d_minor/2,0,0])
            polygon(points=pts);
}

// ---------- Parts ----------
// BODY/SHELL with integral printed liner+fins and female thread
module body_shell(){
    r_outer   = outer_od/2;
    h_total   = cup_height + base_ring_h + cap_engage_h + 2;
    difference(){
        union(){
            cylinder(h=h_total, r=r_outer, $fn=180);
            translate([0,0,h_total-rim_bead_h])
                cylinder(h=rim_bead_h, r=r_outer+0.8, $fn=180);
        }
        translate([0,0,outer_wall])
            cylinder(h=h_total, r=r_outer-outer_wall, $fn=180);
        translate([0,0,0])
            cylinder(h=cap_engage_h+0.1, r=female_major_dm/2, $fn=140);
        inner_id = body_id_at_thread;
        translate([0,0,cap_engage_h+base_ring_h])
            cylinder(h=cup_height, r=inner_id/2, $fn=180);
    }
    fin_h = cup_height - 5;
    for(k=[0:fin_count-1]){
        ang = 360/fin_count * k;
        rotate([0,0,ang])
            translate([ (body_id_at_thread/2)+0.01, 0, cap_engage_h+base_ring_h ])
                cube([fin_depth, fin_thickness, fin_h], center=false);
    }
}

// BOTTOM CAP with external male thread + O-ring groove
module bottom_cap(){
    h_cap = cap_engage_h + 8;
    od_cap = male_major_dm + 6;
    difference(){
        cylinder(h=h_cap, r=od_cap/2, $fn=140);
        cylinder(h=h_cap, r=male_minor_dm/2 - 0.2, $fn=140);
        translate([0,0,h_cap-4])
            cylinder(h=3, r=od_cap/2 - 2.0, $fn=140);
        translate([0,0,h_cap-4.5])
            cylinder(h=1.6, r=(male_major_dm/2) - (o_ring_cs/2 - o_ring_squeeze), $fn=140);
    }
    color([0.7,0.7,0.7])
        translate([0,0,1])
            trapezoid_thread(d_major=male_major_dm,
                             d_minor=male_minor_dm,
                             pitch=thread_pitch,
                             turns=thread_turns,
                             starts=thread_starts,
                             right_handed=true);
}

// ---------- Assembly Preview ----------
if (which_part == "both"){
    body_shell();
    translate([0,0, -2]) bottom_cap();
} else if (which_part == "shell"){
    body_shell();
} else if (which_part == "cap"){
    bottom_cap();
}