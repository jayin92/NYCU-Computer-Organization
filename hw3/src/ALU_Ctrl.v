module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [5:0] funct_i;
input      [2:0] ALUOp_i;

output     [3:0] ALU_operation_o;  
output     [1:0] FURslt_o;
     
//Internal Signals
wire		[3:0] ALU_operation_o;
wire		[1:0] FURslt_o;

//Main function
/*your code here*/
assign {ALU_operation_o, FURslt_o} = (ALUOp_i == 3'b000) ? {4'b0010, 2'b00} : // lw sw addi*
                         (ALUOp_i == 3'b001) ?  {4'b0010, 2'b00} : // beq
                         (ALUOp_i == 3'b010) ? ( // R-type
                            (funct_i == 6'b010010) ? {4'b0010, 2'b00} : // add
                            (funct_i == 6'b010000) ? {4'b0110, 2'b00} : // sub
                            (funct_i == 6'b010100) ? {4'b0001, 2'b00} : // and
                            (funct_i == 6'b010110) ? {4'b0000, 2'b00} : // or
                            (funct_i == 6'b010101) ? {4'b1101, 2'b00} : // nor
                            (funct_i == 6'b100000) ? {4'b0111, 2'b00} : // slt
                            (funct_i == 6'b000000) ? {4'b1000, 2'b01} : // sll
                            (funct_i == 6'b000010) ? {4'b0000, 2'b01} : 0// srl
                         ) : 0;

endmodule     
