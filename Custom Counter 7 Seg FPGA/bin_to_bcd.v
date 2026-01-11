// Binary to BCD converter using Double Dabble algorithm
// Converts 14-bit binary (0-9999) to 4 BCD digits
module bin_to_bcd (
    input  wire [13:0] bin_in,  // up to 9999
    output reg  [3:0] bcd3,     // thousands
    output reg  [3:0] bcd2,     // hundreds
    output reg  [3:0] bcd1,     // tens
    output reg  [3:0] bcd0      // ones
);
    integer i;
    reg [29:0] shift_reg; // 30 bits: 16 for BCD + 14 for binary

    always @(*) begin
        // initialize
        shift_reg = {16'd0, bin_in};
        bcd3 = 4'd0;
        bcd2 = 4'd0;
        bcd1 = 4'd0;
        bcd0 = 4'd0;

        // double dabble: 14 iterations (for 14-bit input)
        for (i=0; i<14; i=i+1) begin
            // check each BCD digit >= 5
            if (shift_reg[17:14] >= 5) shift_reg[17:14] = shift_reg[17:14] + 3;
            if (shift_reg[21:18] >= 5) shift_reg[21:18] = shift_reg[21:18] + 3;
            if (shift_reg[25:22] >= 5) shift_reg[25:22] = shift_reg[25:22] + 3;
            if (shift_reg[29:26] >= 5) shift_reg[29:26] = shift_reg[29:26] + 3;

            // shift left
            shift_reg = shift_reg << 1;
        end

        // assign outputs
        bcd3 = shift_reg[29:26];
        bcd2 = shift_reg[25:22];
        bcd1 = shift_reg[21:18];
        bcd0 = shift_reg[17:14];
    end
endmodule