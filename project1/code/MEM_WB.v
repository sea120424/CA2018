module MEM_WB
(
	clk_i,
	WB_i,
	read_data_i, ALU_o_i,
	Rd_i,

	WB_o,
	read_data_o, ALU_o_o,
	Rd_o
);

input clk_i;
input [1:0] WB_i;
input [31:0] read_data_i, ALU_o_i;
input [4:0] Rd_i;

output reg [1:0] WB_o;
output reg [31:0] read_data_o, ALU_o_o;
output reg [4:0] Rd_o;

always @(posedge clk_i) begin
	WB_o<=WB_i;
	Rd_o<=Rd_i;
	read_data_o <= read_data_i;
	ALU_o_o<=ALU_o_i;
end

endmodule
