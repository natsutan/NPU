module q_mul_core8
  (
   input 	     CLK,
   input 	     RESET_X,
   
   input 	     INPUT_EN,
   input [7:0] 	     A_IN,
   input [7:0] 	     B_IN,

   output 	     OUTPUT_EN,
   output [7:0]      C_OUT,

   input [31:0] MLC_GAGB

   );

   `define MUL_DELAY 7
   
   reg [`ADD_DELAY-1:0] en_r;

   
  // start vector alu
  //  AB = (p_gagb * a_qt * b_qt).astype(np.int)
   wire [15:0] 	mul_1st_out;
   wire [15:0] 	mul_2nd_out;
   
   mul8_8 mul_1st(.CLK(CLK), .A(A_IN), .B(B_IN), .P(mul_1st_out));
   mul16_16 mul_2nd(.CLK(CLK), .A(mul_1st_out), .B(MLC_GAGB[15:0]), .P(mul_2nd_out));
   
   assign C_OUT = mul_2nd_out[7:0];
   
   //delay
   always @ (posedge CLK or negedge RESET_X)begin
      if (RESET_X == 0)begin
	 en_r <= 0;
      end else begin
	 en_r <= { en_r[`MUL_DELAY-2:0], INPUT_EN};
       end
   end
   
   assign OUTPUT_EN = en_r[`MUL_DELAY-1];

   
endmodule // q_mul_core8


