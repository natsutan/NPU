//inverter
module q_inv8
  (
   input [7:0] A,
   output [7:0] B
   );

   assign B = 255 - a;
   
endmodule // q_inv8
