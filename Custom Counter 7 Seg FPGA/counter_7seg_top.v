// Enhanced top module with speed control and modulo counters
// MODULO CONTROL CHANGED FROM KEY TO SW
module counter_7seg_top (
    input  wire clk_50MHz,
    input  wire KEY0,           // Reset (active-low)
    input  wire [9:0] SW,       // Switches for speed AND modulo control
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [9:0] LEDR      // LEDs to show current settings
);

    // Internal signals
    wire slow_clk;
    wire [13:0] count_value;
    wire [1:0] speed_select;
    wire [1:0] mod_select;
    
    // Assign control signals - BOTH speed and modulo on switches now
    assign speed_select = SW[3:2];  // Speed control on SW[3:2]
    assign mod_select = SW[5:4];    // MODULO CONTROL MOVED TO SW[5:4]
    
    // Clock divider with speed control
    clock_divider u_clk_div (
        .clk_50MHz(clk_50MHz),
        .reset(~KEY0),
        .speed_select(speed_select),
        .clk_slow(slow_clk)
    );

    // Modulo counter
    mod_counter u_mod_counter (
        .clk(slow_clk),
        .reset(~KEY0),
        .mod_select(mod_select),
        .max_value(14'd9999),  // Maximum possible value
        .count(count_value)
    );

    // BCD conversion
    wire [3:0] d3, d2, d1, d0;
    bin_to_bcd u_b2b (
        .bin_in(count_value),
        .bcd3(d3),
        .bcd2(d2), 
        .bcd1(d1), 
        .bcd0(d0)
    );

    // 7-segment decoding
    wire [6:0] seg0, seg1, seg2, seg3;

    sevenseg_decoder u0 (.digit(d0), .segments(seg0)); // ones
    sevenseg_decoder u1 (.digit(d1), .segments(seg1)); // tens
    sevenseg_decoder u2 (.digit(d2), .segments(seg2)); // hundreds
    sevenseg_decoder u3 (.digit(d3), .segments(seg3)); // thousands

    // Drive HEX displays
    assign HEX0 = seg0;
    assign HEX1 = seg1;
    assign HEX2 = seg2;
    assign HEX3 = seg3;
    
    // LED indicators for current settings
    assign LEDR[3:2] = speed_select;  // Show speed setting on LEDR[3:2]
    assign LEDR[5:4] = mod_select;    // Show modulo setting on LEDR[5:4]
    assign LEDR[1:0] = 2'b00;         // Turn off unused LEDs
    assign LEDR[9:6] = 4'b0000;       // Turn off unused LEDs

endmodule