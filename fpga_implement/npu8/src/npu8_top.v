// NPU top
// run sim only
module npu8_top
  (
   input 	 CLK,
   input 	 RESET_X,

   input [7:0] 	 ADR,
   input 	 WR,
   input 	 RD,
   output [31:0]  RDATA,
   input [31:0] WDATA,
   output INT 	 
   );

   wire 	 SOFT_RESET;
   wire 	 START;
   wire 	 FINISH;

   wire [1:0] 	 OP; // 0:ADD 1:MUL 2:RQT
   wire [1:0] 	 MSEL_INPUTA_SEL;
   wire [1:0] 	 MSEL_INPUTB_SEL;
   wire [1:0] 	 MSEL_OUTPUTC_SEL;
   wire 	 INV_ASEL;
   wire 	 INV_BSEL;
   
   wire [31:0] 	 M0VAL;

   wire [9:0] 	 M1POS;
   wire [9:0] 	 M1SIZE;

   wire [9:0] 	 M2POS;
   wire [9:0] 	 M2SIZE;
   
   wire [9:0] 	 M3POS;
   wire [9:0] 	 M3SIZE;
   
   wire [31:0] 	 AD_GAIN;
   wire [31:0] 	 AD_QPARAM;

   wire [31:0] 	 MLC_GAGB; 
   wire [31:0] 	 MLC_GAOB;
   wire [31:0] 	 MLC_GBOA; 

   wire [31:0] 	 ML1_GAIN;
   wire [31:0] 	 ML1_QPARAM;
   wire [31:0] 	 ML2_GAIN;
   wire [31:0] 	 ML2_QPARAM;
   
   wire [7:0] 	 REQ_MID;
   wire [31:0] 	 REQ_GAIN;

   wire [7:0] 	 RMAX;
   wire [7:0] 	 RMIN;

   wire [7:0] 	 M0_RDATA;

   wire 	 M1_WR;
   wire [9:0]	 M1_WADR;
   wire [9:0]	 M1_RADR;
   wire [7:0]	 M1_WDATA;
   wire [7:0]	 M1_RDATA;

   wire 	 M2_WR;
   wire [9:0]	 M2_WADR;
   wire [9:0]	 M2_RADR;
   wire [7:0]	 M2_WDATA;
   wire [7:0]	 M2_RDATA;

   wire 	 M3_WR;
   wire [9:0]	 M3_WADR;
   wire [9:0]	 M3_RADR;
   wire [7:0]	 M3_WDATA;
   wire [7:0]	 M3_RDATA;

   wire 	 NPU_EN;
   wire [7:0] 	 A_RDATA;
   wire [7:0] 	 B_RDATA;
   wire 	 LM_EN;
   wire [7:0]	 C_WDATA;
   

   //cpu if
   cpu_if cpu_if
  (
   .CLK(CLK),
   .RESET_X(RESET_X),

   // CPU
   .ADR(ADR),
   .RDATA(RDATA),
   .RD(RD),
   .WR(WR),
   .WDATA(WDATA),
   .INT(INT),

   //REGISTERS
   .SOFT_RESET(SOFT_RESET),
   .START(START),
   .FINISH(FINISH),

   .OP(OP), // 0:ADD 1:MUL 2:RQT
   .MSEL_INPUTA_SEL(MSEL_INPUTA_SEL),
   .MSEL_INPUTB_SEL(MSEL_INPUTB_SEL),
   .MSEL_OUTPUTC_SEL(MSEL_OUTPUTC_SEL),
   .INV_ASEL(INV_ASEL),
   .INV_BSEL(INV_BSEL),

   .M0VAL(M0VAL),

   .M1POS(M1POS),
   .M1SIZE(M1SIZE),

   .M2POS(M2POS),
   .M2SIZE(M2SIZE),

   .M3POS(M3POS),
   .M3SIZE(M3SIZE),

   .AD_GAIN(AD_GAIN),
   .AD_QPARAM(AD_QPARAM),

   .MLC_GAGB(MLC_GAGB), 
   .MLC_GAOB(MLC_GAOB),
   .MLC_GBOA(MLC_GBOA), 

   .ML1_GAIN(ML1_GAIN),
   .ML1_QPARAM(ML1_QPARAM),
   .ML2_GAIN(ML2_GAIN),
   .ML2_QPARAM(ML2_QPARAM),

   .REQ_MID(REQ_MID),
   .REQ_GAIN(REQ_GAIN),

   .RMAX(RMAX),
   .RMIN(RMIN)
   );


   
   //local memory
   M0 m0(.M0VAL(M0VAL), .RDATA(M0_RDATA));
   local_mem m1( .CLK(CLK), .WR(M1_WR), .WADR(M1_WADR), .RADR(M1_RADR), .WDATA(M1_WDATA), .RDATA(M1_RDATA));
   local_mem m2( .CLK(CLK), .WR(M2_WR), .WADR(M2_WADR), .RADR(M2_RADR), .WDATA(M2_WDATA), .RDATA(M2_RDATA));
   local_mem m3( .CLK(CLK), .WR(M3_WR), .WADR(M3_WADR), .RADR(M3_RADR), .WDATA(M3_WDATA), .RDATA(M3_RDATA));

   //local memory controller
   lmcnt lmcnt
  (
   .CLK(CLK),
   .RESET_X(RESET_X),
   
   .SOFT_RESET(SOFT_RESET),
   .START(START),
   .FINISH(FINISH),
   .MSEL_INPUTA_SEL(MSEL_INPUTA_SEL),
   .MSEL_INPUTB_SEL(MSEL_INPUTB_SEL),
   .MSEL_OUTPUTC_SEL(MSEL_OUTPUTC_SEL),
   .M1POS(M1POS),
   .M1SIZE(M1SIZE),
   .M2POS(M2POS),
   .M3POS(M3POS),
   
   .M0_RDATA(M0_RDATA),
   
   .M1_WR(M1_WR),
   .M1_WADR(M1_WADR),
   .M1_WDATA(M1_WDATA),
   .M1_RADR(M1_RADR),
   .M1_RDATA(M1_RDATA),

   .M2_WR(M2_WR),
   .M2_WADR(M2_WADR),
   .M2_WDATA(M2_WDATA),
   .M2_RADR(M2_RADR),
   .M2_RDATA(M2_RDATA),
   
   .M3_WR(M3_WR),
   .M3_WADR(M3_WADR),
   .M3_WDATA(M3_WDATA),
   .M3_RADR(M3_RADR),
   .M3_RDATA(M3_RDATA),

   .NPU_EN(NPU_EN),
   .A_RDATA(A_RDATA),
   .B_RDATA(B_RDATA),
   
   .LM_EN(LM_EN),
   .C_WDATA(C_WDATA)
   );
   

   //NPU8
   npu_core npu_core
     (
      .CLK(CLK),
      .RESET_X(RESET_X),
      .SOFT_RESET(SOFT_RESET),

      .OP(OP),
      .INV_ASEL(INV_ASEL),
      .INV_BSEL(INV_BSEL),
      
      .INPUT_EN(NPU_EN),
      .A_IN(A_RDATA),
      .B_IN(B_RDATA),

      .OUTPUT_EN(LM_EN),
      .C_OUT(C_WDATA),

      .AD_GAIN(AD_GAIN),
      .AD_QPARAM(AD_QPARAM),

      .MLC_GAGB(MLC_GAGB), 
      .MLC_GAOB(MLC_GAOB),
      .MLC_GBOA(MLC_GBOA), 

      .ML1_GAIN(ML1_GAIN),
      .ML1_QPARAM(ML1_QPARAM),
      .ML2_GAIN(ML2_GAIN),
      .ML2_QPARAM(ML2_QPARAM),
      
      .REQ_MID(REQ_MID),
      .REQ_GAIN(REQ_GAIN),

      .RMAX(RMAX),
      .RMIN(RMIN)

   );

   
   

endmodule // npu8_top
