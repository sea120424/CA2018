module EX_MEM
(
    clk_i,
    WB_i, M_i,
    ALU_o_i,
    fw2_i,
    Rd_i,

    WB_o,
    Memorywrite_o, Memoryread_o,
    ALU_o_o,
    fw2_o,
    Rd_o,
    stall_i


);

input clk_i;
input [1:0] WB_i; 
input [1:0] M_i;
input [31:0] ALU_o_i, fw2_i;
input [4:0] Rd_i;
input stall_i;

output reg  [1:0] WB_o;
output reg  Memorywrite_o, Memoryread_o;
output reg  [31:0] ALU_o_o, fw2_o;
output reg  [4:0] Rd_o;


always@(posedge clk_i) begin
	if(stall_i == 1'b1) begin
  end
  else begin
   		WB_o<=WB_i;
  		 Memorywrite_o<=M_i[0];
   		Memoryread_o<=M_i[1];
   		ALU_o_o<=ALU_o_i;
   		fw2_o<=fw2_i;
   		Rd_o<=Rd_i;
	end
end

endmodule