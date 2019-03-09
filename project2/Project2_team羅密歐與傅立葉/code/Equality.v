module Equality
(
    data1_i,
    data2_i,
    data_o
);

//Output 1'b1 if the two inputs are the same. 1'b0 otherwise.
//If the output is 1'b1 and the current state operation is Beq, PC must branch to the specified position.


input   [31:0]  data1_i;
input   [31:0]  data2_i;

output          data_o;

reg             data_o;

always @( data1_i or data2_i ) begin
    
    if ( data1_i == data2_i ) begin
        data_o <= 1'b1;
    end
    else begin
        data_o <= 1'b0;
    end

end

endmodule