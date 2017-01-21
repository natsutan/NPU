module npu_core
  (
   input 	    CLK,
   input 	    RESET_X,
   input 	    SOFT_RESET,

   input [1:0] 	    OP,
   input 	    INV_ASEL,
   input 	    INV_BSEL,
		       
   input 	    INPUT_EN,
   input [7:0] 	    A_IN,
   input [7:0] 	    B_IN,

   output reg 	    OUTPUT_EN,
   output reg [7:0] C_OUT,

   
   //ADD
   input [31:0]     AD_GAIN,
   input [31:0]     AD_QPARAM,

   //MULL CORE
   input [31:0]     MLC_GAGB, 
   input [31:0]     MLC_GAOB,
   input [31:0]     MLC_GBOA, 
	     
   
   // MULL ADD1
   input [31:0]     ML1_GAIN,
   input [31:0]     ML1_QPARAM,
   input [31:0]     ML2_GAIN,
   input [31:0]     ML2_QPARAM,
		     
   input [7:0] 	    REQ_MID,
   input [31:0]     REQ_GAIN,

   output reg [15:0]    RMAX,
   output reg [15:0]    RMIN

   );


   wire 	    rst_x;
   assign rst_x = RESET_X & ~SOFT_RESET;

   wire 	    op_add_sel, op_mul_sel, op_rqt_sel;
   wire 	    input_en_add, input_en_mul, input_en_rqt;

   wire 	    output_en_add, output_en_mul, output_en_rqt;
   wire [7:0] 	    c_out_add, c_out_mul, c_out_rqt;
   wire [15:0] 	    rmax_add, rmax_mul, rmax_rqt;
   wire [15:0] 	    rmin_add, rmin_mul, rmin_rqt;

   reg 		    input_en_1t;
   reg [7:0] 	    a_in_r;
   reg [7:0] 	    b_in_r;
   
   wire [7:0] 	    a_in_inv;
   wire [7:0] 	    b_in_inv;

   
   assign op_add_sel = (OP == 2'b00);
   assign op_mul_sel = (OP == 2'b01);
   assign op_rqt_sel = (OP == 2'b10);

   assign input_en_add = input_en_1t & op_add_sel;
   assign input_en_mul = input_en_1t & op_mul_sel;
   assign input_en_rqt = input_en_1t & op_rqt_sel;
 
   // invert input
   q_inv8 inv_a(.A(A_IN), .B(a_in_inv));
   q_inv8 inv_b(.A(B_IN), .B(b_in_inv));

   always @ (posedge CLK or negedge rst_x)begin
      if (rst_x == 0) begin
	 a_in_r <= 8'h00;
      end else begin
	 if (INV_ASEL == 1) begin
	    a_in_r <= a_in_inv;
	 end else begin
	    a_in_r <= A_IN;
	 end
      end
   end // always @ (posedge CLK or negedge rst_x)
   
   always @ (posedge CLK or negedge rst_x)begin
      if (rst_x == 0) begin
	 b_in_r <= 8'h00;
      end else begin
	 if (INV_BSEL == 1) begin
	    b_in_r <= b_in_inv;
	 end else begin
	    b_in_r <= B_IN;
	 end
      end
   end // always @ (posedge CLK or negedge rst_x)
  
   
   q_add8 q_add8
  (
   .CLK(CLK),
   .RESET_X(rst_x),
   .OP_SEL(op_add_sel),
   
   .INPUT_EN(input_en_1t),
   .A_IN(a_in_r),
   .B_IN(b_in_r),
   
   .OUTPUT_EN(output_en_add),
   .C_OUT(c_out_add),
   
   .GAIN(AD_GAIN),
   .Q_PARAM(AD_QPARAM),
   
   .MIN(rmax_add),
   .MAX(rmin_add)
   );


   //outut sel
   always @ (posedge CLK or negedge rst_x) begin
      if (rst_x == 0) begin
	 OUTPUT_EN <= 0;
	 C_OUT <= 8'h00;
	 RMAX <= 16'h0000;
	 RMIN <= 16'h0000;
      end else begin
	 if (op_add_sel == 1) begin
	    OUTPUT_EN <= output_en_add;
	    C_OUT <= c_out_add;
	    RMAX <= rmax_add;
	    RMIN <= rmin_add;
	 end else if(op_add_sel == 1) begin
	    OUTPUT_EN <= output_en_mul;
	    C_OUT <= c_out_mul;
	    RMAX <= rmax_mul;
	    RMIN <= rmin_mul;
	 end else if (op_mul_sel == 1) begin
	    OUTPUT_EN <= output_en_rqt;
	    C_OUT <= c_out_rqt;
	    RMAX <= rmax_rqt;
	    RMIN <= rmin_rqt;
	 end else begin
	    OUTPUT_EN <= 0;
	    C_OUT <= 8'h00;
	 end
      end // else: !if(rst_x == 0)
   end // always @ (posedge CLK or negedge rst_x)

   //delay
   always @ (posedge CLK or negedge rst_x) begin
      if (rst_x == 0) begin
	 input_en_1t <= 0;
      end else begin
	 input_en_1t <= INPUT_EN;
      end
   end
   

   //dummy   	 
   assign  output_en_mul = 0;
   assign  output_en_rqt = 0;
   
   assign c_out_mul = 0;
   assign c_out_rqt = 0;

   assign rmax_mul = 0;
   assign rmin_mul = 0;
   
   assign rmax_rqt = 0;
   assign rmin_rqt = 0;

endmodule // npu_core
