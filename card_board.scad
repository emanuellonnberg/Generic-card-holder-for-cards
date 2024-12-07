// Parameters

number_of_rows_y    = 6;            // Number of rows of cuts
number_of_rows_x    = 4;            // Number of rows of cuts
board_width       = 276;          // Width of the board (X-axis)
board_length      = 110;          // Length of the board (Y-axis)
board_thickness   = 10;            // Thickness of the board (Z-axis)
cut_opening_x       = 2;
cut_opening_y       = 4;
cut_depth         = 7;            // Depth of the cut into the board
cut_width_x       = 11;  // Width of the cut
cut_width_y       = 6;
cut_angle_x       = 45;  // Width of the cut
cut_angle_y       = 40;

corner_radius     = 1;            // Radius for the rounded corners and edges
cut_board_length = board_length + corner_radius * 2;
cut_board_width = board_width + corner_radius * 2;
    
// Calculate cut lengths and spacing
// Length of cuts along X-axis
cut_length_x      = board_width;     
// Length of cuts along Y-axis
cut_length_y      = board_length;    
// Spacing between cuts along X-axis
cut_spacing_x     = cut_length_x / (number_of_rows_x) + 13;  
// Spacing between cuts along Y-axis
cut_spacing_y     = cut_length_y / (number_of_rows_y) -1;  
cut_offset_x      = -26;
cut_offset_y      = 4;

// Card insets

card_width = 73;
card_height = 120;
card_thickness = 1;
card_number_of = 3;
card_offset_width = 17.5;
card_offset_height = 4;
card_spacing = 10;


// Main code
difference() {
    // Base board centered at the origin
    union() {
        difference () {
            minkowski() {
            translate([-board_width / 2, -board_length / 2, 0])
                cube([board_width, board_length, board_thickness-corner_radius]);
                sphere(corner_radius, $fn=32);
            }
            
           translate([-(board_width+corner_radius*2) / 2, -(board_length+corner_radius*2) / 2,-board_thickness/2])
                cube([(board_width+corner_radius*2), (board_length+corner_radius*2), board_thickness/2]);
        }
        //translate([-board_width / 2, -board_length / 2, 0])
        //    cube([board_width+2, board_length+2, board_thickness], radius=corner_rad, $fn=32);
        // Base board with rounded corners and edges
        //rounded_board(board_width, board_length, board_thickness, corner_radius);
    }
        
    // Base board with rounded corners and edges
    //rounded_board(board_width, board_length, board_thickness, corner_radius);
        
    // Base board with rounded corners and edges
    //rounded_board_minkowski(board_width, board_length, board_thickness, corner_radius);
    
    //rounded_top_board(board_width, board_length, board_thickness, corner_radius);
    if(card_number_of > 0) {
        for (i = [0 : card_number_of - 1]) {
            translate([-board_width / 2 + ((card_width + card_spacing) * i) + card_offset_width, -card_offset_height + (board_length-card_height) + -board_length / 2, board_thickness - card_thickness])
                cube([card_width, card_height, card_thickness]);
        }
    }
    
    
    // Cuts along the Y-axis (extruded along X-axis)
    for (i = [0 : number_of_rows_y - 1]) {
        x_pos = -cut_board_width / 2;
        y_pos = -cut_board_length / 2 + cut_spacing_y * (i + 0.5) + cut_offset_y;
        z_pos = board_thickness - cut_depth;
        make_cut_angle([x_pos, y_pos, z_pos], [90, 180, 90], cut_angle_x, cut_depth, board_width + 2, cut_opening_x);
    }

    // Cuts along the X-axis (extruded along Y-axis)
    for (i = [0 : number_of_rows_x - 1]) {
        x_pos = -cut_board_width / 2 + cut_spacing_x * (i + 0.5) + cut_offset_x;
        y_pos = cut_board_length / 2;
        z_pos = board_thickness - cut_depth;
        make_cut_angle([x_pos, y_pos, z_pos], [90, 180, 0], cut_angle_y, cut_depth, board_length + 2, cut_opening_y);
    }
}

// Module to create the rounded board using cube with radius
module rounded_board(width, length, thickness, corner_rad) {
    cube([width, length, thickness], center=true, radius=corner_rad, $fn=32);
}

// Module to create the rounded board using minkowski()
module rounded_board_minkowski(width, length, thickness, corner_rad) {
    minkowski() {
        cube([width - 2*corner_rad, length - 2*corner_rad, thickness], center=true);
        sphere(r=corner_rad, $fn=32);
    }
}

// Module to create the rounded board using minkowski()
module rounded_top_board(width, length, thickness, radius) {
    difference() {
        // Base shape with rounded edges
        minkowski() {
            cube([width - 2*radius, length - 2*radius, thickness], center=true);
            cylinder(r=radius, h=0, $fn=32);
        }
        // Subtract the bottom to keep edges sharp
        translate([-width/2, -length/2, 0])
            cube([width, length, radius], center=false);
    }
}

module make_cut_angle(position, rotation, angle, depth, length, opening) {
    // Convert angle from degrees to radians, since OpenSCAD uses radians for trigonometric functions
    //angle_radians = angle * 3.141592653589793 / 180;

    // Calculate the width based on the angle, depth, and trigonometry
    width = (tan(angle) * depth * 2) - opening;

    // Create the cut shape using the calculated width
    make_cut(position, rotation, width, depth, length, opening);
}

module make_cut(position, rotation, width, depth, length, opening) {
    translate(position)
        rotate(rotation)
            linear_extrude(length)
                polygon(points=[
                    [ -width / 2, 0 ],
                    [ -opening/2, -depth ],
                    [ opening/2, -depth ],
                    [ width / 2, 0 ]
                ]);
}

