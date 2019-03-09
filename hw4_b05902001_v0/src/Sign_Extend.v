module Sign_Extend
(
	data_i,
	data_o
);

input [31:0] data_i;
output [31:0] data_o;
parameter extend = 32'b11111111111100000000000000000000;
assign data_o = data_i & extend;

endmodule
 