`default_nettype none
`timescale 1ns/1ps

module timer_module #(
    parameter CLOCKS_PER_TICK = 50000000
) (
    input wire clk,
    input wire rst,
    output reg tick
);
    reg [31:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 32'd0;
            tick <= 1'b0;
        end else if (counter == CLOCKS_PER_TICK - 1) begin
            counter <= 32'd0;
            tick <= 1'b1;
        end else begin
            counter <= counter + 1'b1;
            tick <= 1'b0;
        end
    end
endmodule

`default_nettype wire
