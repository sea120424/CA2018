module Forwarding(
	mux_forwardA_o,	
	mux_forwardB_o,	
	ex_mem_control_i,	
	mem_wb_control_i,	
	ex_mem_rd_i,
	mem_wb_rd_i,
	id_ex_rs1_i,	
	id_ex_rs2_i		
);

input	ex_mem_control_i, mem_wb_control_i;
input[4:0] ex_mem_rd_i, mem_wb_rd_i, id_ex_rs1_i, id_ex_rs2_i;
output reg[1:0] mux_forwardA_o, mux_forwardB_o;


always @(*) begin
mux_forwardA_o = ( (ex_mem_control_i == 1) 
		    && (ex_mem_rd_i != 0) 
		    && (ex_mem_rd_i == id_ex_rs1_i ) )
		    ? 2'b10 : 
		    ( (mem_wb_control_i == 1) 
		    && (mem_wb_rd_i != 0) 
		    && (mem_wb_rd_i == id_ex_rs1_i) )
		    ? 2'b01 : 2'b00 ;

mux_forwardB_o = ( (ex_mem_control_i == 1) 
		    && (ex_mem_rd_i != 0) 
		    && (ex_mem_rd_i == id_ex_rs2_i ) )
		    ? 2'b10 : 
		    ( (mem_wb_control_i == 1) 
		    && (mem_wb_rd_i != 0) 
		    && (mem_wb_rd_i == id_ex_rs2_i) )
		    ? 2'b01 : 2'b00 ;
end

endmodule
 
