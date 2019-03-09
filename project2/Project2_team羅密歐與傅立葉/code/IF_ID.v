module IF_ID
(
 	send_i, 		// from hazrd_detect ( IF_ID_o )
	clk_i,
	inst_i,
	pc_i,
	flush_i,
	inst_o,
	pc_o,
	stall_i
);

input send_i, clk_i, flush_i;
input[31:0] inst_i, pc_i;
input stall_i;

output reg[31:0] inst_o, pc_o;

always@(posedge clk_i ) begin
	if(flush_i == 1) begin
		inst_o <= 32'b0;
		pc_o <= 32'b0;
	end
	if(stall_i == 1'b1) begin
	end

	else if(send_i == 0) begin
		inst_o <= inst_o;
		pc_o <= pc_o;
	end
	else begin
		inst_o <= inst_i;
		pc_o <= pc_i;
	end
	
end

endmodule

 