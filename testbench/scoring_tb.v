`timescale 1ns/1ps
`default_nettype none

module scoring_tb;
    reg clock = 1'b0;
    reg reset = 1'b0;
    reg touchdown = 1'b0;
    reg extra_point = 1'b0;
    reg two_point_conversion = 1'b0;
    reg field_goal = 1'b0;
    reg safety = 1'b0;
    reg manual_possession = 1'b0;

    wire possession;
    wire [3:0] team1_tens;
    wire [3:0] team1_ones;
    wire [3:0] team2_tens;
    wire [3:0] team2_ones;

    scoring_mechanism_DFF dut (
        .touchdown(touchdown),
        .extraPoint(extra_point),
        .twoPointConversion(two_point_conversion),
        .fieldGoal(field_goal),
        .safety(safety),
        .manual_possession(manual_possession),
        .clock(clock),
        .reset(reset),
        .possession(possession),
        .score1tens(team1_tens),
        .score1ones(team1_ones),
        .score2tens(team2_tens),
        .score2ones(team2_ones)
    );

    always #5 clock = ~clock;

    task pulse_extra_point;
        begin
            @(negedge clock);
            extra_point = 1'b1;
            @(negedge clock);
            extra_point = 1'b0;
            #1;
        end
    endtask

    task pulse_touchdown;
        begin
            @(negedge clock);
            touchdown = 1'b1;
            @(negedge clock);
            touchdown = 1'b0;
            #1;
        end
    endtask

    task pulse_field_goal;
        begin
            @(negedge clock);
            field_goal = 1'b1;
            @(negedge clock);
            field_goal = 1'b0;
            #1;
        end
    endtask

    initial begin
        reset = 1'b1;
        repeat (2) @(posedge clock);
        reset = 1'b0;

        pulse_extra_point();
        if (team1_tens !== 0 || team1_ones !== 0)
            $fatal(1, "Conversion scored without a touchdown.");

        pulse_touchdown();
        if (team1_tens !== 0 || team1_ones !== 6)
            $fatal(1, "Team 1 touchdown did not score six points.");
        if (possession !== 1'b0)
            $fatal(1, "Possession changed before the conversion.");

        pulse_extra_point();
        if (team1_tens !== 0 || team1_ones !== 7)
            $fatal(1, "Extra point did not produce a 7-point total.");
        if (possession !== 1'b1)
            $fatal(1, "Possession did not change after the conversion.");

        pulse_field_goal();
        if (team2_tens !== 0 || team2_ones !== 3)
            $fatal(1, "Team 2 field goal did not score three points.");
        if (possession !== 1'b0)
            $fatal(1, "Possession did not change after the field goal.");

        $display("PASS scoring_tb");
        $finish;
    end
endmodule

`default_nettype wire
