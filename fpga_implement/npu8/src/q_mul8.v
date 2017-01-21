module q_mul8
  (
   input 	     CLK,
   input 	     RESET_X,
   
   input 	     INPUT_EN,
   input [7:0] 	     A_IN,
   input [7:0] 	     B_IN,
   input [7:0] 	     A_IN_INV,
   input [7:0] 	     B_IN_INV,
   input 	     A_SEL_INV,
   input             B_SEL_INV,
   
   output 	     OUTPUT_EN,
   output [7:0]      C_OUT,

   input [31:0]      MLC_GAGB, 

   // MULL ADD1
   input [31:0]      ML1_GAIN,
   input [31:0]      ML1_QPARAM,
   input [31:0]      ML2_GAIN,
   input [31:0]      ML2_QPARAM,
   
   output [15:0] MIN,
   output [15:0] MAX

   );


   //    # vector
   // AdBd_qt, AdBd_min, AdBd_max = q_mul_core(a_qt, Adash_min, Adash_max, b_qt, Bdash_min, Bdash_max, debug=debug)
   // C_qt_0, C_qt_0_min, C_qt_0_max = q_add(qt_A_bmin, A_bmin_min, A_bmin_max, qt_B_amin, B_amin_min, B_amin_max, debug=debug)
   // C_qt, c_min, c_max = q_add(AdBd_qt, AdBd_min, AdBd_max, C_qt_0, C_qt_0_min, C_qt_0_max, debug=debug)

   wire [7:0] 	     AdBd_qt;
   wire              mul_core_en;

   wire [7:0] 	     C_qt_0;
   wire [7:0] 	     qt_A_bmin;
   wire [7:0] 	     qt_B_amin;
   wire              add_1st_en;
   
   assign qt_A_bmin = A_SEL_INV ? A_IN_INV : A_IN;
   assign qt_B_amin = B_SEL_INV ? B_IN_INV : B_IN;

   reg [7:0] 	     AdBd_qt_1t;
   
   
   q_mul_core8 mul_core
     (
      .CLK(CLK), 
      .RESET_X(RESET_X),   
      .INPUT_EN(INPUT_EN),
      .A_IN(A_IN),
      .B_IN(B_IN),
      
      .OUTPUT_EN(mul_core_en),
      .C_OUT(AdBd_qt),
      
      .MLC_GAGB(MLC_GAGB)

   );

   q_add8 add_1st 
     (
      .CLK(CLK),
      .RESET_X(RESET_X),
      
      .INPUT_EN(INPUT_EN),
      .A_IN(qt_A_bmin),
      .B_IN(qt_B_amin),
      
      .OUTPUT_EN(add_1st_en),
      .C_OUT(C_qt_0),
      
      .GAIN(ML1_GAIN),
      .Q_PARAM(ML1_QPARAM),
      
      .MIN(),
      .MAX()
   );

   q_add8 add_2nd
     (
      .CLK(CLK),
      .RESET_X(RESET_X),
      
      .INPUT_EN(add_1st_en),
      .A_IN(AdBd_qt_1t),
      .B_IN(C_qt_0),
      
      .OUTPUT_EN(OUTPUT_EN),
      .C_OUT(C_OUT),
      
      .GAIN(ML2_GAIN),
      .Q_PARAM(ML2_QPARAM),
      
      .MIN(MIN),
      .MAX(MAX)
   );


   always @ (posedge CLK or negedge RESET_X)begin
      if (RESET_X == 0)begin
	 AdBd_qt_1t <= 8'h00;
      end else begin
	 AdBd_qt_1t <= AdBd_qt;
      end
   end
   
   
endmodule // q_mul8
