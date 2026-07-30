`default_nettype none
`timescale 1ns/1ps

module countdown_timer (
    input wire clock,
    input wire reset,
    input wire tick_1hz,
    input wire possession,
    input wire view_play_clock,
    output wire [3:0] display_tens,
    output wire [3:0] display_ones
);
    reg [9:0] game_seconds;
    reg [4:0] play_seconds;
    reg previous_possession;

    wire [4:0] displayed_value;
    wire [4:0] game_minutes_remaining;

    // With only two clock digits available, the game-clock view shows the
    // remaining whole minute rounded up: 10, 09, ..., 01, 00.
    assign game_minutes_remaining =
        (game_seconds == 0) ? 0 : ((game_seconds + 59) / 60);
    assign displayed_value =
        view_play_clock ? play_seconds : game_minutes_remaining;
    assign display_tens = displayed_value / 10;
    assign display_ones = displayed_value % 10;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            game_seconds <= 10'd600;
            play_seconds <= 5'd15;
            previous_possession <= 1'b0;
        end else begin
            previous_possession <= possession;

            if (possession != previous_possession) begin
                play_seconds <= 5'd15;
            end else if (tick_1hz && play_seconds > 0) begin
                play_seconds <= play_seconds - 1'b1;
            end

            if (tick_1hz && game_seconds > 0)
                game_seconds <= game_seconds - 1'b1;
        end
    end
endmodule

`default_nettype wire
