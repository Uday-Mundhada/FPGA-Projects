// Modulo counter with configurable maximum value
module mod_counter (
    input wire clk,
    input wire reset,
    input wire [1:0] mod_select,  // KEY[2:1] for modulo selection
    input wire [13:0] max_value,  // Maximum count value
    output reg [13:0] count       // Current count
);
    
    reg [13:0] mod_limit;
    
    always @(*) begin
        case(mod_select)
            2'b00: mod_limit = max_value;    // Normal (0-9999)
            2'b01: mod_limit = 14'd99;       // 0-99
            2'b10: mod_limit = 14'd999;      // 0-999
            2'b11: mod_limit = 14'd1999;     // 0-1999
        endcase
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 14'd0;
        else if (count >= mod_limit)
            count <= 14'd0;
        else
            count <= count + 1;
    end
    
endmodule