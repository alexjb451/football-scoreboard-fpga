module edge_detector(clk, rst, signal_in, pulse_out);
	 input clk, rst, signal_in;
	 output pulse_out;
	 
    reg prev;

    always @(posedge clk or posedge rst) begin
        if (rst)
            prev <= 0;
        else
            prev <= signal_in;
    end

    assign pulse_out = signal_in & ~prev;
	 
endmodule
