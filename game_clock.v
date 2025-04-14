module game_clock(toggle, reset, viewToggle, possession, timer, timer2);
    input toggle, reset, possession, viewToggle;
    output reg [6:0] timer;
    output reg [6:0] timer2;

    reg [9:0] counter;
    reg [9:0] game_clock;
    reg prev_possession;

    initial begin
        game_clock = 15;
        counter = 600;
        prev_possession = 1'b0;
    end

    always @(posedge toggle or posedge reset) begin
        if (reset) begin
            game_clock = 15;
            counter = 600;
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

    always @(*) begin
        if (viewToggle) begin
            if (reset) begin
                timer = 7'b1000000;
                timer2 = 7'b1111001;
            end else begin
                if (counter == 0)
                    timer = 7'b1000000;
                else if (counter <= 60)
                    timer = 7'b1111001;
                else if (counter <= 120)
                    timer = 7'b0100100;
                else if (counter <= 180)
                    timer = 7'b0110000;
                else if (counter <= 240)
                    timer = 7'b0011001;
                else if (counter <= 300)
                    timer = 7'b0010010;
                else if (counter <= 360)
                    timer = 7'b0000010;
                else if (counter <= 420)
                    timer = 7'b1111000;
                else if (counter <= 480)
                    timer = 7'b0000000;
                else if (counter <= 540)
                    timer = 7'b0011000;
                else if (counter <= 600)
                    timer = 7'b1000000;

                if (counter <= 540)
                    timer2 = 7'b1000000;
                else if (counter <= 600)
                    timer2 = 7'b1111001;
            end
        end else begin
            if (reset) begin
                timer = 7'b0010010;
                timer2 = 7'b1111001;
            end else begin
                if (game_clock == 15 || game_clock == 5)
                    timer = 7'b0010010;
                else if (game_clock == 14 || game_clock == 4)
                    timer = 7'b0011001;
                else if (game_clock == 13 || game_clock == 3)
                    timer = 7'b0110000;
                else if (game_clock == 12 || game_clock == 2)
                    timer = 7'b0100100;
                else if (game_clock == 11 || game_clock == 1)
                    timer = 7'b1111001;
                else if (game_clock == 10 || game_clock == 0)
                    timer = 7'b1000000;
                else if (game_clock == 9)
                    timer = 7'b0011000;
                else if (game_clock == 8)
                    timer = 7'b0000000;
                else if (game_clock == 7)
                    timer = 7'b1111000;
                else if (game_clock == 6)
                    timer = 7'b0000010;

                if (game_clock < 10)
                    timer2 = 7'b1000000;
                else if (game_clock >= 10)
                    timer2 = 7'b1111001;
            end
        end
    end
endmodule
