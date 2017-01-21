module q_add8 
  (
   input 	     CLK,
   input 	     RESET_X,
   
   input 	     INPUT_EN,
   input [7:0] 	     A_IN,
   input [7:0] 	     B_IN,

   output 	     OUTPUT_EN,
   output [7:0]      C_OUT,

   input [31:0]      GAIN,
   input [31:0]      Q_PARAM,

   output reg [15:0] MIN,
   output reg [15:0] MAX
   );

   `define ADD_DELAY 8
   
   //# start vector
   // c_qt = b_qt * gain + a_qt
   // c_qt *= q_param
   wire [15:0] 	 mul_1st_zp8;  //int 1: mul_1st_zp8[8] = 1
   reg [16:0] 	 mul_add_zp8_r;
   wire [24:0] 	 mul_2nd_out;
   reg [7:0] 	 a_in_1t, a_in_2t, a_in_3t;
   
   
   reg [`ADD_DELAY-1:0] 	 en_r;
   
   mul8_16 mul_1st(.CLK, .A(B_IN), .B(GAIN[15:0]), .P(mul_1st_zp8));
   
   always @ (posedge CLK or negedge RESET_X)begin
      if (RESET_X == 0) begin
	 mul_add_zp8_r <= 25'h000000;
      end else begin
	 mul_add_zp8_r <= mul_1st_zp8 + a_in_3t[7:0];
      end
   end

   mul17_16 mul_2nd(.CLK(CLK), .A(mul_add_zp8_r[16:0]), .B(Q_PARAM), .P(mul_2nd_out));
   
   assign C_OUT = mul_2nd_out[7:0];
   
   always @ (posedge CLK or negedge RESET_X) begin
      if(RESET_X)begin
	 MIN <= 16'h7FFF;
	 MAX <= 0;
      end else begin
	 if(OUTPUT_EN)begin
	    if (MAX > C_OUT) begin
	       MAX <= C_OUT;
	    end
	    if (MIN < C_OUT) begin
	       MIN <= C_OUT;
	    end
	 end
      end // else: !if(RESET_X)
   end // always @ (posedge CLK or negedge RESET_X)

   //delay
   always @ (posedge CLK or negedge RESET_X)begin
      if (RESET_X == 0)begin
	 en_r <= 0;
    	 a_in_1t <= 0;
	 a_in_2t <= 0;
	 a_in_3t <= 0;	 
      end else begin
	 en_r <= { en_r[`ADD_DELAY-2:0], INPUT_EN};
   	 a_in_1t <= A_IN;
	 a_in_2t <= a_in_1t;
	 a_in_3t <= a_in_2t;	 
       end
   end
   
   assign OUTPUT_EN = en_r[`ADD_DELAY-1];
   
endmodule // q_add8
