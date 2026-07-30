`default_nettype none
`timescale 1ns/1ps

module my_dff (
    input wire clk,
    input wire rst,
    input wire d,
    output reg q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

`default_nettype wire
