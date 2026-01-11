module Seq_Detector_1011(
    input clk, rst_n,
    input btn_one, btn_zero,  // KEY1 for '1', KEY2 for '0'
    output Y,                 // LEDG0 - sequence detected
    output [6:0] HEX0, HEX1, HEX2, HEX3  // 7-segment displays
);
    reg [2:0] current_state, next_state;
    
    parameter   s0 = 3'b000,  // No bits matched
                s1 = 3'b001,  // "1"
                s2 = 3'b010,  // "10"
                s3 = 3'b011,  // "101"
                s4 = 3'b100;  // "1011" - detection state
    
    // Button synchronization and edge detection
    reg [1:0] btn_one_sync, btn_zero_sync;
    reg btn_one_prev, btn_zero_prev;
    wire btn_one_pressed, btn_zero_pressed;
    
    // Synchronize buttons
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_one_sync <= 2'b11;
            btn_zero_sync <= 2'b11;
            btn_one_prev <= 1'b1;
            btn_zero_prev <= 1'b1;
        end else begin
            btn_one_sync <= {btn_one_sync[0], btn_one};
            btn_zero_sync <= {btn_zero_sync[0], btn_zero};
            btn_one_prev <= btn_one_sync[1];
            btn_zero_prev <= btn_zero_sync[1];
        end
    end
    
    // Detect button presses (falling edge)
    assign btn_one_pressed = (btn_one_prev == 1'b1) && (btn_one_sync[1] == 1'b0);
    assign btn_zero_pressed = (btn_zero_prev == 1'b1) && (btn_zero_sync[1] == 1'b0);
    
    // Input handling
    reg In;
    reg input_valid;
    reg [3:0] current_input_display;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            input_valid <= 1'b0;
            In <= 1'b0;
            current_input_display <= 4'd15; // Display '-' when no input
        end else begin
            input_valid <= 1'b0;
            
            if (btn_one_pressed && !btn_zero_pressed) begin
                input_valid <= 1'b1;
                In <= 1'b1;
                current_input_display <= 4'd1; // Display '1'
            end else if (btn_zero_pressed && !btn_one_pressed) begin
                input_valid <= 1'b1;
                In <= 1'b0;
                current_input_display <= 4'd0; // Display '0'
            end
        end
    end
    
    // LED control - make it stay on for 1 second
    reg [25:0] led_counter;
    reg led_trigger;
    reg detection_flag;
    
    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= s0;
            led_trigger <= 1'b0;
            led_counter <= 26'b0;
            detection_flag <= 1'b0;
        end else begin
            // State transition on valid input
            if (input_valid) begin
                current_state <= next_state;
                // Set detection flag when sequence is detected
                if (Y_value) begin
                    detection_flag <= 1'b1;
                end
            end
            
            // Handle LED timing
            if (detection_flag) begin
                led_trigger <= 1'b1;
                detection_flag <= 1'b0; // Clear flag
                led_counter <= 26'b0;   // Reset counter
            end else if (led_trigger) begin
                // LED timer - keep LED on for 1 second (50 million cycles at 50MHz)
                if (led_counter == 26'd50_000_000) begin
                    led_trigger <= 1'b0;
                    led_counter <= 26'b0;
                end else begin
                    led_counter <= led_counter + 1'b1;
                end
            end
        end
    end
    
    // Next state and output logic - 5-State Mealy Machine
    reg Y_value;
    
    always @(*) begin
        Y_value = 1'b0;
        case(current_state)
            s0: begin    // No bits matched
                if (In == 1'b1)
                    next_state = s1;  // Got first '1'
                else
                    next_state = s0;  // Stay in s0
            end
            
            s1: begin    // "1"
                if (In == 1'b0)
                    next_state = s2;  // "10"
                else
                    next_state = s1;  // "11" - stay in s1
            end
            
            s2: begin    // "10"
                if (In == 1'b1)
                    next_state = s3;  // "101"
                else
                    next_state = s0;  // "100" - back to start
            end
            
            s3: begin    // "101"
                if (In == 1'b1) begin
                    next_state = s4;  // "1011" - GO TO DETECTION STATE
                    Y_value = 1'b1;   // OUTPUT 1 when detecting "1011"
                end else
                    next_state = s2;  // "1010" - back to "10" state
            end
            
            s4: begin    // "1011" - Detection state
                if (In == 1'b1)
                    next_state = s1;  // Start new sequence with '1'
                else
                    next_state = s2;  // Start new sequence with "10"
            end
            
            default: begin
                next_state = s0;
            end
        endcase    
    end
    
    // LED output - stays on for 1 second when triggered
    assign Y = led_trigger;
    
    // 7-Segment Display Drivers
    
    // HEX3: Current Input (Rightmost display)
    seg7_lut display_input(.hex_digit(current_input_display), .segments(HEX3));
    
    // HEX2: Blank (not used)
    assign HEX2 = 7'b1111111; // Turn off
    
    // HEX1 & HEX0: Current State in decimal (0, 1, 2, 3, 4)
    // Convert 3-bit state to 4-bit for display (0-4 only)
    wire [3:0] state_display = (current_state == 3'b100) ? 4'd4 : 
                              (current_state == 3'b011) ? 4'd3 :
                              (current_state == 3'b010) ? 4'd2 :
                              (current_state == 3'b001) ? 4'd1 : 4'd0;
    
    seg7_lut display_tens(.hex_digit(4'b0), .segments(HEX1)); // Always show 0 in tens
    seg7_lut display_ones(.hex_digit(state_display), .segments(HEX0));
    
endmodule

// 7-Segment Display Lookup Table
module seg7_lut(
    input [3:0] hex_digit,
    output reg [6:0] segments
);
    always @(*)
        case(hex_digit)
            4'h0: segments = 7'b1000000; // 0
            4'h1: segments = 7'b1111001; // 1
            4'h2: segments = 7'b0100100; // 2
            4'h3: segments = 7'b0110000; // 3
            4'h4: segments = 7'b0011001; // 4
            4'h5: segments = 7'b0010010; // 5
            4'h6: segments = 7'b0000010; // 6
            4'h7: segments = 7'b1111000; // 7
            4'h8: segments = 7'b0000000; // 8
            4'h9: segments = 7'b0010000; // 9
            4'ha: segments = 7'b0001000; // A
            4'hb: segments = 7'b0000011; // B
            4'hc: segments = 7'b1000110; // C
            4'hd: segments = 7'b0100001; // D
            4'he: segments = 7'b0000110; // E
            4'hf: segments = 7'b0111111; // - (dash for no input)
            default: segments = 7'b1111111; // Off
        endcase
endmodule