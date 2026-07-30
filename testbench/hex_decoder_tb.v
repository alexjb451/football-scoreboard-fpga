`timescale 1ns/1ps
`default_nettype none

module hex_decoder_tb;
    reg [3:0] digit;
    wire [6:0] segments;

    hex_decoder dut (
        .hex_digit(digit),
        .segments(segments)
    );

    initial begin
        digit = 4'd0;
        #1;
        if (segments !== 7'b1000000)
            $fatal(1, "Digit 0 pattern is incorrect.");

        digit = 4'd5;
        #1;
        if (segments !== 7'b0010010)
            $fatal(1, "Digit 5 pattern is incorrect.");

        digit = 4'd9;
        #1;
        if (segments !== 7'b0011000)
            $fatal(1, "Digit 9 pattern is incorrect.");

        $display("PASS hex_decoder_tb");
        $finish;
    end
endmodule

`default_nettype wire
