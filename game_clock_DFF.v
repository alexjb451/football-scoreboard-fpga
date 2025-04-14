module game_clock_DFF(toggle, reset, viewToggle, possession, display_tens, display_ones);
    input toggle, reset, possession, viewToggle;
    output [3:0] display_tens;
	 output [3:0] display_ones;
	 
	 wire [3:0] timer_tens;
    wire [3:0] timer_ones;
    wire [3:0] timer2_tens;
    wire [3:0] timer2_ones;

    reg [9:0] counter;
    reg [9:0] game_clock;
    reg prev_possession;

    wire [9:0] counter_dff_out;
    wire [9:0] game_clock_dff_out;

    initial begin
        counter = 600;
        game_clock = 15;
        prev_possession = 0;
    end

    always @(posedge toggle or posedge reset) begin
        if (reset) begin
            counter = 600;
            game_clock = 15;
            prev_possession = 0;
        end else begin
            if (counter > 0)
                counter = counter - 1;

            if (game_clock > 0)
                game_clock = game_clock - 1;

            if (possession && !prev_possession)
                game_clock = 15;

            prev_possession = possession;
        end
    end

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin: counter_dffs
            my_dff d_counter(toggle, reset, counter[i], counter_dff_out[i]);
        end
        for (i = 0; i < 10; i = i + 1) begin: gameclock_dffs
            my_dff d_game_clock(toggle, reset, game_clock[i], game_clock_dff_out[i]);
        end
    endgenerate

    assign timer_ones = counter_dff_out % 10;
    assign timer_tens = counter_dff_out / 10;

    assign timer2_ones = game_clock_dff_out % 10;
    assign timer2_tens = game_clock_dff_out / 10;
	 
	 assign display_tens = (viewToggle) ? timer2_tens : timer_tens;
	 assign display_ones = (viewToggle) ? timer2_ones : timer_ones;

endmodule
