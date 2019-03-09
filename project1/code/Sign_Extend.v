module Sign_Extend
(
	data_i,
    ctrl_i,
	data_o
);

input   [31:0]  data_i;
input   [1:0]   ctrl_i;
output  [31:0]  data_o;

reg     [31:0]  temp;
integer         i;

assign data_o = temp;

always@( data_i or ctrl_i ) begin
    if ( ctrl_i == 2'b00 ) begin                            //I-format
        temp = {{20{data_i[31]}}, data_i[31:20]};
    end
    else if ( ctrl_i == 2'b01 ) begin                       //S-format
        temp = {{20{data_i[31]}}, data_i[31:25], data_i[11:7]};
    end
    else if ( ctrl_i == 2'b10 ) begin                       //SB-format
        temp = {{20{data_i[31]}}, data_i[31], data_i[7], data_i[30:25], data_i[11:8]};
    end
end

endmodule
 