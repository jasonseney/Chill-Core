# ChillCore Demo Cup (V0.1) — 3D Print Pack

**Purpose:** Print a *demo-size* cup (~120 mm tall) to validate ergonomics, ice packing, and cap action.  
**Not food safe. Not leak-rated.** For concept only.

## Files
- `chillcore_demo.scad` — OpenSCAD source (parametric)
  - Set `which_part` to `"shell"` or `"cap"` to export each STL.

## Print Settings (FDM)
- **Material:** PETG recommended (outer and cap). PLA also ok.
- **Nozzle:** 0.4 mm (0.6 mm even better for strength; adjust walls).
- **Layer height:** 0.20–0.28 mm
- **Walls:** 4 perimeters
- **Top/bottom:** 5–6 layers
- **Infill:** 20–30%
- **Supports:** Off (model avoids overhangs)
- **Cooling:** On for PLA, moderate for PETG

## Assembly
1. Export STLs for **shell** and **cap** from OpenSCAD (Render F6, then Export STL).
2. Print both parts.
3. Insert a silicone O-ring (3.0 mm cross-section).
4. Lightly lubricate O-ring (petroleum jelly works for demo).
5. Screw cap on — ~1.5 turns (3-start thread). Expect some play.

## Roadmap (logged, not in this demo)
- Optional AirTag bay
- Kids “play pod” bottom
- Vacuum valve test
- Copper / Aluminum / Titanium liners
- Integrated mini-crusher

