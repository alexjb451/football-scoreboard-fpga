`timescale 1ns/1ps
`default_nettype none

module countdown_timer_tb;
    reg clock = 1'b0;
    reg reset = 1'b0;
    reg tick_1hz = 1'b0;
    reg possession = 1'b0;
    reg view_play_clock = 1'b0;

    wire [3:0] display_tens;
    wire [3:0] display_ones;

    countdown_timer dut (
        .clock(clock),
        .reset(reset),
        .tick_1hz(tick_1hz),
        .possession(possession),
        .view_play_clock(view_play_clock),
        .display_tens(display_tens),
        .display_ones(display_ones)
    );

    always #5 clock = ~clock;

    task tick_once;
        begin
            @(negedge clock);
            tick_1hz = 1'b1;
            @(negedge clock);
            tick_1hz = 1'b0;
            #1;
        end
    endtask

    integer index;

    initial begin
        reset = 1'b1;
        repeat (2) @(posedge clock);
        reset = 1'b0;
        #1;

        if (display_tens !== 1 || display_ones !== 0)
            $fatal(1, "Game clock did not reset to 10 minutes.");

        view_play_clock = 1'b1;
        #1;
        if (display_tens !== 1 || display_ones !== 5)
            $fatal(1, "Play clock did not reset to 15 seconds.");

        for (index = 0; index < 5; index = index + 1)
            tick_once();
        if (display_tens !== 1 || display_ones !== 0)
            $fatal(1, "Play clock did not count down to 10.");

        possession = 1'b1;
        @(posedge clock);
        #1;
        if (display_tens !== 1 || display_ones !== 5)
            $fatal(1, "Play clock did not reset on possession change.");

        view_play_clock = 1'b0;
        for (index = 0; index < 60; index = index + 1)
            tick_once();
        if (display_tens !== 0 || display_ones !== 9)
            $fatal(1, "Game clock did not reach 9 minutes.");

        $display("PASS countdown_timer_tb");
        $finish;
    end
endmodule

`default_nettype wire
