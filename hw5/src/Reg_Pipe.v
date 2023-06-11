module Reg_Pipe(clk_i, rst_n, data_i, data_o);

parameter size = 0;

input clk_i;
input rst_n;
input [size-1:0] data_i;
output [size-1:0] data_o;

reg [size-1:0] data = 0;

assign data_o = data;

always @(posedge clk_i) begin
    if(rst_n == 0) begin
        data <= 0;
    end 
    else begin
        data <= data_i;
    end
end

endmodule