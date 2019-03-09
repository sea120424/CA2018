module ID_EX
(
	clk_i,
	inst_i,
	pc_i,
	rd1_i,
	rd2_i,
	sign_extend_i,
	mux_i,			// input from MUX(included WB, M, EX)	
	ALU_op_o,
	WB_o,			// output to EX/MEM
	M_o,			// output to EX/MEM
	mux_upper_o,
	mux_middle_o,
	ALU_src_o,		// mux on the right
	forwarding_rs1_o,	// output to forwarding	
	forwarding_rs2_o,	// output to forwarding
	inst_o,			// output to EX/MEM
	pc_o,			// output to EX/MEM
	hazard_MEM_Read_o,	// output to hazard unit 
	hazard_rd_o,
	mux_EX_MEM_Rd_o,
    	sign_extend_o,
	stall_i
);

input clk_i;
input[31:0] inst_i, pc_i, sign_extend_i;
input[6:0] mux_i;
input[31:0] rd1_i, rd2_i;
input stall_i;

output reg[31:0] inst_o, pc_o, sign_extend_o, mux_upper_o, mux_middle_o;
output reg[4:0] forwarding_rs1_o, forwarding_rs2_o, hazard_rd_o;
output reg[4:0] mux_EX_MEM_Rd_o;
output reg[1:0] M_o;
output reg[1:0] WB_o,  ALU_op_o ;
output reg ALU_src_o, hazard_MEM_Read_o ;


always@(posedge clk_i ) begin
	if(stall_i == 1'b1) begin
	end
	else begin
		WB_o <= mux_i[1:0];
		M_o <= mux_i[3:2];
		ALU_src_o <= mux_i[4];
		ALU_op_o <= mux_i[6:5];
		mux_upper_o <= rd1_i;
		mux_middle_o <= rd2_i;
		forwarding_rs1_o <= inst_i[19:15];
		forwarding_rs2_o <= inst_i[24:20];
		inst_o <= inst_i;
		pc_o <= pc_i;
		hazard_MEM_Read_o <= mux_i[3];
		hazard_rd_o <= inst_i[11:7];
		mux_EX_MEM_Rd_o <= inst_i[11:7];
    	sign_extend_o <= sign_extend_i;
	end

end

endmodule

 
