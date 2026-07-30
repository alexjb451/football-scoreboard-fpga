`default_nettype none
`timescale 1ns/1ps

module scoring_mechanism_DFF (
    input wire touchdown,
    input wire extraPoint,
    input wire twoPointConversion,
    input wire fieldGoal,
    input wire safety,
    input wire manual_possession,
    input wire clock,
    input wire reset,
    output reg possession,
    output wire [3:0] score1tens,
    output wire [3:0] score1ones,
    output wire [3:0] score2tens,
    output wire [3:0] score2ones
);

    wire [6:0] score1;
    wire [6:0] score2;
    reg [6:0] score1_next;
    reg [6:0] score2_next;

    wire touchdown_edge, extraPoint_edge, twoPointConversion_edge, fieldGoal_edge, safety_edge, manual_possession_edge;

    reg waiting_for_conversion;

    edge_detector ed1(clock, reset, touchdown, touchdown_edge);
    edge_detector ed2(clock, reset, extraPoint, extraPoint_edge);
    edge_detector ed3(clock, reset, twoPointConversion, twoPointConversion_edge);
    edge_detector ed4(clock, reset, fieldGoal, fieldGoal_edge);
    edge_detector ed5(clock, reset, safety, safety_edge);
    edge_detector ed6(clock, reset, manual_possession, manual_possession_edge);

    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin: score1_dffs
            my_dff d1(clock, reset, score1_next[i], score1[i]);
        end
        for (i = 0; i < 7; i = i + 1) begin: score2_dffs
            my_dff d2(clock, reset, score2_next[i], score2[i]);
        end
    endgenerate

    always @(*) begin
        score1_next = score1;
        score2_next = score2;

        if (touchdown_edge && !waiting_for_conversion) begin
            if (possession)
                score2_next = score2 + 6;
            else
                score1_next = score1 + 6;
        end else if (extraPoint_edge && waiting_for_conversion) begin
            if (possession)
                score2_next = score2 + 1;
            else
                score1_next = score1 + 1;
        end else if (twoPointConversion_edge && waiting_for_conversion) begin
            if (possession)
                score2_next = score2 + 2;
            else
                score1_next = score1 + 2;
        end else if (fieldGoal_edge && !waiting_for_conversion) begin
            if (possession)
                score2_next = score2 + 3;
            else
                score1_next = score1 + 3;
        end else if (safety_edge && !waiting_for_conversion) begin
            if (possession)
                score2_next = score2 + 2;
            else
                score1_next = score1 + 2;
        end
    end

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            possession <= 1'b0;
            waiting_for_conversion <= 1'b0;
        end else begin
            if (manual_possession_edge) begin
                possession <= ~possession;
                waiting_for_conversion <= 1'b0;
            end else if (
                (extraPoint_edge || twoPointConversion_edge)
                && waiting_for_conversion
            ) begin
                possession <= ~possession;
                waiting_for_conversion <= 1'b0;
            end else if (
                (fieldGoal_edge || safety_edge)
                && !waiting_for_conversion
            ) begin
                possession <= ~possession;
            end else if (touchdown_edge && !waiting_for_conversion) begin
                waiting_for_conversion <= 1'b1;
            end
        end
    end

    assign score1tens = score1 / 10;
    assign score1ones = score1 % 10;
    assign score2tens = score2 / 10;
    assign score2ones = score2 % 10;

endmodule

`default_nettype wire
