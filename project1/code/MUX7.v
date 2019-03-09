module MUX7(
    data1_i,
    data2_i,
    select_i,
    data_o
);

input [6:0] data1_i, data2_i;
input select_i;
output[6:0] data_o;

assign data_o = select_i ? data2_i : data1_i ;

endmodule