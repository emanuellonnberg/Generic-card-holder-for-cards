// TODO
// 1. Extra trays for otkens or dice at along one side
// 2. Text in front of slots / cards
// 3. extra slots to on the left and right sides for storing several cards

// Parameters

number_of_rows_y    = 6;            // Number of rows of cuts
number_of_rows_x    = 0;            // Number of rows of cuts
board_width       = 206;          // Width of the board (X-axis)
board_length      = 120;          // Length of the board (Y-axis)
board_thickness   = 10;            // Thickness of the board (Z-axis)
cut_opening_x       = 2;
cut_opening_y       = 5;
cut_depth         = 7;            // Depth of the cut into the board
cut_width_x       = 11;  // Width of the cut
cut_width_y       = 6;
cut_angle_x       = 45;  // Width of the cut
cut_angle_y       = 40;

corner_radius     = 4;            // Radius for the rounded corners and edges
cut_board_length = board_length;// + corner_radius * 2;
cut_board_width = board_width; // + corner_radius * 2;
    
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

/* [Extra vertical cuts left and right] */
cut_extra_left    = 2;
cut_extra_left_offset    = 3;
cut_extra_left_interval    = 10;
cut_extra_right   = 2;
cut_extra_right_offset    = 3;
cut_extra_right_interval    = 10;

/* [Card insets] */
card_width = 73;
card_height = 120;
card_thickness = 3;
card_number_of = 2;
card_offset_width = 25;
card_offset_height = 10;
card_spacing = 10;

/* [Card top texts] */
card_top_text_enabled = true;
card_top_text_1 = "Active Ploys";
card_top_text_2 = "Active Ploys";
card_top_text_3 = "Active Ploys";
card_top_text_4 = "Active Ploys";
card_top_texts = [card_top_text_1, card_top_text_2, card_top_text_3, card_top_text_4]; 
card_top_offset_length = 3; 
card_top_text_size = 5; 
card_top_text_thickness = 1;
card_top_text_extruded = true;
card_top_text_font="Impact:style=Regular";

/* [Card image] */
card_images_enabled=true;
card_image_1="Kill-Team.svg";
card_image_2="Kill-Team.svg";
card_image_3="Kill-Team.svg";
card_image_4="Kill-Team.svg";
card_images=[card_image_1, card_image_2, card_image_3, card_image_4];
card_images_offset_y=62;
card_images_scale_x=0.18;
card_images_scale_y=0.18;
card_images_scale_z=7;
card_images_thickness=4.5;

/* [Board texts] */
board_text_enabled = true;
board_text_offset_length = 30; 
board_text = "KILL TEAM";
board_text_size = 30; 
board_text_thickness = 4;
board_text_font="Impact:style=Regular";

/* [Board image (svg)] */
board_image_enabled=true;
board_image="Kill-Team.svg";
board_image_offset_y=17;
board_image_scale_x=0.4;
board_image_scale_y=0.4;
board_image_scale_z=1;
board_image_thickness=.5;

// Main code
difference() {
    // Base board centered at the origin
    union() {
        board_width_without_corners = board_width-corner_radius*2;
        board_length_without_corners = board_length-corner_radius*2;
        difference () {
            //create a sum of a cube and asphere to get rounded corners
            // we add the corner_radius to handle the minowski sum alignment
            translate([-board_width / 2 + corner_radius, 
                -board_length / 2 + corner_radius, 0])
                minkowski() {
                    cube([board_width_without_corners, 
                            board_length_without_corners, 
                            board_thickness-corner_radius], center = false);
                    sphere(corner_radius, $fn=64);
                }
            
           translate([-board_width / 2, -board_length / 2,-board_thickness])
                cube([(board_width), (board_length), board_thickness]);
        }

        if(card_top_text_enabled && card_top_text_extruded) {
            if(card_number_of > 0) {
                for (i = [0 : card_number_of - 1]) {
                
                    card_position = [
                        -board_width / 2 + 
                            ((card_width + card_spacing) * i) + 
                            card_offset_width, 
                        -card_offset_height + 
                            (board_length-card_height) + 
                            -board_length / 2,
                        board_thickness - card_thickness];
                 
                    card_text_position = [
                        card_position.x +
                            card_width / 2, 
                        board_length / 2 - card_top_text_size + -card_top_offset_length,
                        board_thickness];
                        
                    add_text_at(card_top_texts[i], 
                    card_text_position,
                    card_top_text_size, card_top_text_thickness, card_top_text_font);
                
                }
            }
        }
    

       
    }
        
    if(card_number_of > 0) {
        for (i = [0 : card_number_of - 1]) {
        
            card_position = [
                -board_width / 2 + ((card_width + card_spacing) * i) + card_offset_width, 
                -card_offset_height + (board_length-card_height) + -board_length / 2,
                board_thickness - card_thickness];
        
            translate(card_position)
                cube([card_width, card_height, card_thickness]);
                

            if(card_top_text_enabled && !card_top_text_extruded) {    
                card_text_position = [
                    card_position.x +
                        card_width / 2, 
                    board_length / 2 - card_top_text_size + -card_top_offset_length,
                    board_thickness - card_top_text_thickness];
                      
                add_text_at(card_top_texts[i], 
                    card_text_position,
                    card_top_text_size, card_top_text_thickness, card_top_text_font);
            }
            
            if(card_images_enabled) {
                card_image_position = [
                    card_position.x +
                        card_width / 2, 
                    board_length / 2 - card_images_offset_y,
                    board_thickness - card_images_thickness];
                    
                translate(card_image_position)
                    scale([card_images_scale_x, card_images_scale_y, card_images_scale_z])
                        linear_extrude(board_image_thickness)    
                            import(card_images[i], center = true);
            }

        }
    }
    
    // Cuts along the Y-axis (extruded along X-axis)
    if(number_of_rows_y > 0) {
        for (i = [0 : number_of_rows_y - 1]) {
            x_pos = -cut_board_width / 2;
            y_pos = -cut_board_length / 2 + cut_spacing_y * (i + 0.5) + cut_offset_y;
            z_pos = board_thickness - cut_depth;
            make_cut_angle([x_pos, y_pos, z_pos], [90, 180, 90], cut_angle_x, cut_depth, board_width + 2, cut_opening_x);
        }
    }
                
    if(number_of_rows_x > 0) {
        // Cuts along the X-axis (extruded along Y-axis)
        for (i = [0 : number_of_rows_x - 1]) {
            x_pos = -cut_board_width / 2 + cut_spacing_x * (i + 0.5) + cut_offset_x;
            y_pos = cut_board_length / 2;
            z_pos = board_thickness - cut_depth;
            make_cut_angle([x_pos, y_pos, z_pos], [90, 180, 0], cut_angle_y, cut_depth, board_length + 2, cut_opening_y);
        }
    }
    
     // Extra cuts along the X-axis left (extruded along Y-axis)
    if(cut_extra_left > 0) {
        for (i = [0 : cut_extra_left - 1]) {
            x_pos = -cut_board_width / 2 + cut_extra_left_interval * (i + 0.5) + cut_extra_left_offset;
            y_pos = cut_board_length / 2;
            z_pos = board_thickness - cut_depth;
            make_cut_angle([x_pos, y_pos, z_pos], [90, 180, 0], cut_angle_y, cut_depth, board_length + 2, cut_opening_y);
        }
    }
    
    // Extra cuts along the X-axis left (extruded along Y-axis)
    if(cut_extra_right > 0) {
        for (i = [0 : cut_extra_right - 1]) {
            x_pos = cut_board_width / 2 - cut_extra_right_interval * (i + 0.5) - cut_extra_right_offset;
            y_pos = cut_board_length / 2;
            z_pos = board_thickness - cut_depth;
            make_cut_angle([x_pos, y_pos, z_pos], [90, 180, 0], cut_angle_y, cut_depth, board_length + 2, cut_opening_y);
        }
    }
    
    if(board_text_enabled) {
        add_text_at(board_text, 
            [0,-board_text_offset_length, board_thickness - board_text_thickness],
                board_text_size, board_text_thickness, board_text_font);

    }
    
   if(board_image_enabled) {  
        translate([0,
            -board_text_offset_length+board_image_offset_y, 
            board_thickness-board_image_thickness])
            scale([board_image_scale_x, board_image_scale_y, board_image_scale_z])
                linear_extrude(board_image_thickness)    
                    import(board_image, center = true);
    }

}

module add_text_at(text, position, size, size_z, font = "Impact:style=Regular") {
    translate(position) 
        linear_extrude(size_z)
            text( text, font=font , size = size, halign = "center");
}

// Module to create the rounded board using cube with radius
module rounded_cube(
    width, 
    length, 
    thickness, 
    corner_radius
) {
    width_without_corners = width - 2 * corner_radius;
    length_without_corners = length - 2 * corner_radius;

    translate([
        -width / 2 + corner_radius, 
        -length / 2 + corner_radius, 
        0
    ])
    minkowski() {
        cube([
            width_without_corners, 
            length_without_corners, 
            thickness - corner_radius
        ], center = false);
        sphere(corner_radius, $fn=32);
    }
}

module make_cut_angle(position, rotation, angle, depth, length, opening) {
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

