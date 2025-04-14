module timer_module(clk,rst,toggle);
    input clk;         
    input rst;          
    output reg toggle;
   
    parameter LOWCOUNT = 25000000;
   
    reg [31:0] counter;
   
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 32'd0;  
            toggle <= 1'b0;    
        end else begin
            if (counter == LOWCOUNT - 1) begin
                counter <= 32'd0; 
                toggle <= ~toggle;
            end else begin
                counter <= counter + 1;
        end
    end
	 end

endmodule