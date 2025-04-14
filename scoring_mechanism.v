module scoring_mechanism(touchdown, extraPoint, twoPointConversion, fieldGoal, safety, clock, reset, possession, score1tens, score1ones, score2tens, score2ones);
    input touchdown, extraPoint, twoPointConversion, fieldGoal, safety, reset, clock;
    output reg possession;
	 output [3:0] score1tens;
	 output [3:0] score1ones;
	 output [3:0] score2tens;
	 output [3:0] score2ones;
	 
	 reg [6:0] score1;
	 reg [6:0] score2;
	 
	 assign score1tens = score1 / 10;
	 assign score1ones = score1 % 10;
	 assign score2tens = score2 / 10;
	 assign score2ones = score2 % 10;
	 
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            score1 = 0;
            score2 = 0;
            possession = 1'b0;
        end else begin
            if (touchdown) begin
                if (possession)
                    score2 = score2 + 6;
                else
                    score1 = score1 + 6;
            end else if (extraPoint) begin
                if (possession)
                    score2 = score2 + 1;
                else
                    score1 = score1 + 1;
                possession = ~possession;
            end else if (twoPointConversion) begin
                if (possession)
                    score2 = score2 + 2;
                else
                    score1 = score1 + 2;
                possession = ~possession;
            end else if (fieldGoal) begin
                if (possession)
                    score2 = score2 + 3;
                else
                    score1 = score1 + 3;
                possession = ~possession;
            end else if (safety) begin
                if (possession)
                    score2 = score2 + 2;
                else
                    score1 = score1 + 2;
                possession = ~possession;
            end
        end
    end

endmodule
