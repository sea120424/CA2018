module IF_ID
(
 	send_i, 		// from hazrd_detect ( IF_ID_o )
	clk_i,
	inst_i,
	pc_i,
	flush_i,
	inst_o,
	pc_o,
);

input send_i, clk_i, flush_i;
input[31:0] inst_i, pc_i;
output reg[31:0] inst_o, pc_o;

always@(posedge clk_i ) begin
	if(flush_i == 1) begin
		inst_o <= 32'b0;
		pc_o <= 32'b0;
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

 