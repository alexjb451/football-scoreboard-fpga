`default_nettype none
`timescale 1ns/1ps

module edge_detector (
    input wire clk,
    input wire rst,
    input wire signal_in,
    output wire pulse_out
);
    reg prev;

    always @(posedge clk or posedge rst) begin
        if (rst)
            prev <= 1'b0;
        else
            prev <= signal_in;
    end

    assign pulse_out = signal_in & ~prev;
endmodule

`default_nettype wire
