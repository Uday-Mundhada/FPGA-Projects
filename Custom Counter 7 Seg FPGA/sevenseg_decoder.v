// 7-segment decoder for common-anode displays
// Converts 4-bit BCD digit to 7-segment pattern
module sevenseg_decoder (
    input  wire [3:0] digit,
    output reg  [6:0] segments
);

    always @(*) begin
        case (digit)
            4'd0: segments = 7'b1000000; // 0
            4'd1: segments = 7'b1111001; // 1
            4'd2: segments = 7'b0100100; // 2
            4'd3: segments = 7'b0110000; // 3
            4'd4: segments = 7'b0011001; // 4
            4'd5: segments = 7'b0010010; // 5
            4'd6: segments = 7'b0000010; // 6
            4'd7: segments = 7'b1111000; // 7
            4'd8: segments = 7'b0000000; // 8
            4'd9: segments = 7'b0010000; // 9
            default: segments = 7'b1111111; // blank
        endcase
    end
endmodule