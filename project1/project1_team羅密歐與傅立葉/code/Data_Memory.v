module Data_Memory
(
    clk_i,
    addr_d,
    write_data,
    read_data,
    mem_read,
    mem_write
);
input clk_i;
input [31:0] addr_d;
input [31:0] write_data;
output [31:0] read_data;
input mem_read, mem_write;

reg [31:0] data;
// total 32: 8bit reg
reg [7:0] memory  [31:0];
assign read_data = data;
always@(posedge clk_i) begin
    if(mem_write==1) begin
        memory[addr_d] <= write_data[7:0];
        memory[addr_d+1] <= write_data[15:8];
        memory[addr_d+2] <= write_data[23:16];
        memory[addr_d+3] <= write_data[31:24];
    end
end
always@(addr_d or mem_read ) begin
    if(mem_read==1) begin
        data[7:0] = memory[addr_d];
        data[15:8] = memory[addr_d+1];
        data[23:16] = memory[addr_d+2];
        data[31:24] = memory[addr_d+3];
    end    
end

endmodule