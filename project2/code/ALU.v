module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o,
);

input   [31:0]  data1_i;
input   [31:0]  data2_i;
input   [3:0]   ALUCtrl_i;
output  [31:0]  data_o;
output  [31:0]  Zero_o;

reg     [31:0]  temp;
reg     [31:0]  Zero_o;

assign  data_o = temp;

always@(data1_i or data2_i or ALUCtrl_i) begin
    case (ALUCtrl_i)
        4'b0110: temp <= data1_i - data2_i;
        4'b0010: temp <= data1_i + data2_i;
        4'b0000: temp <= data1_i & data2_i;
        4'b0001: temp <= data1_i | data2_i;
        4'b0100: temp <= data1_i * data2_i;
    endcase
    Zero_o <= 32'b0;
end

endmodule