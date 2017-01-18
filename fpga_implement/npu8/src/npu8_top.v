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




   
   //mem




   

   //NPU8


   //dummy
   assign FINISH = START;
   assign RMAX = 8'h00;
   assign RMIN = 8'h00;
   
   

endmodule // npu8_top
