module ALU( result, zero, overflow, aluSrc1, aluSrc2, invertA, invertB, operation );
   
  output wire[31:0] result;
  output wire zero;
  output wire overflow;

  input wire[31:0] aluSrc1;
  input wire[31:0] aluSrc2;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  
  wire[31:0] carries;
  wire alu31_set;
  wire dummy;
  
  ALU_1bit alu0(
        result[0],
        carries[0],
        dummy,
        aluSrc1[0],
        aluSrc2[0],
        invertA,
        invertB,
        operation,
        invertB,
        alu31_set
  );        
  
  genvar i;
  generate
      for(i=1;i<=30;i=i+1) begin: alu_inst
        ALU_1bit alu(
            result[i],
            carries[i],
            dummy,
            aluSrc1[i],
            aluSrc2[i],
            invertA,
            invertB,
            operation,
            carries[i-1],
            1'b0
        );
       end
   endgenerate
   
   ALU_1bit alu31(
        result[31],
        carries[31],
        alu31_set,
        aluSrc1[31],
        aluSrc2[31],
        invertA,
        invertB,
        operation,
        carries[30],
        1'b0
    );
   
   assign overflow = (operation[1] == 1'b1 ? carries[30] ^ carries[31] : 1'b0);
   assign zero = ~(|result[31:0]);
	  
endmodule