`default_nettype none
`timescale 1ns/1ps

module football_scoreboard_top #(
    parameter CLOCKS_PER_TICK = 50000000
) (
    input wire CLOCK_50,
    input wire reset,
    input wire touchdown,
    input wire extra_point,
    input wire two_point_conversion,
    input wire field_goal,
    input wire safety,
    input wire manual_possession,
    input wire view_play_clock,
    output wire possession,
    output wire possession_other,
    output wire [6:0] HEX5,
    output wire [6:0] HEX4,
    output wire [6:0] HEX3,
    output wire [6:0] HEX2,
    output wire [6:0] HEX1,
    output wire [6:0] HEX0
);
    wire tick_1hz;
    wire [3:0] team1_tens;
    wire [3:0] team1_ones;
    wire [3:0] team2_tens;
    wire [3:0] team2_ones;
    wire [3:0] clock_tens;
    wire [3:0] clock_ones;

    assign possession_other = ~possession;

    timer_module #(
        .CLOCKS_PER_TICK(CLOCKS_PER_TICK)
    ) one_hz_enable (
        .clk(CLOCK_50),
        .rst(reset),
        .tick(tick_1hz)
    );

    scoring_mechanism_DFF score_controller (
        .touchdown(touchdown),
        .extraPoint(extra_point),
        .twoPointConversion(two_point_conversion),
        .fieldGoal(field_goal),
        .safety(safety),
        .manual_possession(manual_possession),
        .clock(CLOCK_50),
        .reset(reset),
        .possession(possession),
        .score1tens(team1_tens),
        .score1ones(team1_ones),
        .score2tens(team2_tens),
        .score2ones(team2_ones)
    );

    countdown_timer game_and_play_clock (
        .clock(CLOCK_50),
        .reset(reset),
        .tick_1hz(tick_1hz),
        .possession(possession),
        .view_play_clock(view_play_clock),
        .display_tens(clock_tens),
        .display_ones(clock_ones)
    );

    hex_decoder team1_tens_display (
        .hex_digit(team1_tens),
        .segments(HEX5)
    );
    hex_decoder team1_ones_display (
        .hex_digit(team1_ones),
        .segments(HEX4)
    );
    hex_decoder team2_tens_display (
        .hex_digit(team2_tens),
        .segments(HEX3)
    );
    hex_decoder team2_ones_display (
        .hex_digit(team2_ones),
        .segments(HEX2)
    );
    hex_decoder clock_tens_display (
        .hex_digit(clock_tens),
        .segments(HEX1)
    );
    hex_decoder clock_ones_display (
        .hex_digit(clock_ones),
        .segments(HEX0)
    );
endmodule

`default_nettype wire
