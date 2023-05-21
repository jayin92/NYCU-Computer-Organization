module ALU_1bit( result, carryOut, set, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output wire result;
  output wire carryOut;
  output wire set;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  wire w0, w1, neg_a, neg_b;
  
  not n0(neg_a, a);
  not n1(neg_b, b);
  
  assign w0 = (invertA == 1'b1) ? neg_a : a;
  assign w1 = (invertB == 1'b1) ? neg_b : b;
      
  wire y0, y1, y2;
  
  or  o0(y0, w0, w1);
  and a0(y1, w0, w1);
  
  Full_adder fa(.sum(y2), 
                .carryOut(carryOut), 
                .carryIn(carryIn),
                .input1(w0),
                .input2(w1));
  
  assign result = (operation == 2'b00) ? y0 :
                  (operation == 2'b01) ? y1 :
                  (operation == 2'b10) ? y2 :
                  (operation == 2'b11) ? less :
                  0;
    
  assign set = y2;
    
endmodule