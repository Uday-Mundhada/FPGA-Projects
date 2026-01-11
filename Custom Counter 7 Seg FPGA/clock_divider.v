// Clock divider module with speed control
module clock_divider (
    input wire clk_50MHz,
    input wire reset,
    input wire [1:0] speed_select,  // SW[3:2] for speed selection
    output reg clk_slow
);
    reg [23:0] counter;
    reg [23:0] speed_val;
    
    always @(*) begin
        case(speed_select)
            2'b00: speed_val = 24'd500000;   // 100Hz - Fast
            2'b01: speed_val = 24'd2500000;  // 20Hz  - Medium
            2'b10: speed_val = 24'd5000000;  // 10Hz  - Slow  
            2'b11: speed_val = 24'd25000000; // 2Hz   - Very Slow
        endcase
    end
    
    always @(posedge clk_50MHz or posedge reset) begin
        if (reset) begin
            counter <= 24'd0;
            clk_slow <= 1'b0;
        end 
		  else begin
            if (counter >= speed_val) begin
                counter <= 24'd0;
                clk_slow <= ~clk_slow;
            end 
				else begin
                counter <= counter + 1;
            end
        end
    end
endmodule