//local memory controller
module lmcnt
  (
   input 	    CLK,
   input 	    RESET_X,

   //cpu
   input 	    SOFT_RESET,
   input 	    START,
   output reg 	    FINISH,
   input [1:0] 	    MSEL_INPUTA_SEL,
   input [1:0] 	    MSEL_INPUTB_SEL,
   input [1:0] 	    MSEL_OUTPUTC_SEL,
   input [9:0] 	    M1POS,
   input [9:0] 	    M1SIZE,
   input [9:0] 	    M2POS,
   input [9:0] 	    M3POS,
  
   //local mem
   input [7:0] 	    M0_RDATA,

   output reg 	    M1_WR,
   output [7:0]     M1_WDATA,
   output [9:0]     M1_RADR,
   input [7:0] 	    M1_RDATA,

   output reg 	    M2_WR,
   output [7:0]     M2_WDATA,
   output [9:0]     M2_RADR,
   input [7:0] 	    M2_RDATA,

   output reg 	    M2_WR,
   output [7:0]     M2_WDATA,
   output [9:0]     M2_RADR,
   input [7:0] 	    M2_RDATA,

   
   //npu
   output reg 	    NPU_EN,
   output reg [7:0] A_RDATA,
   output reg [7:0] B_RDATA,

   input 	    LM_EN,
   input [7:0] 	    C_WDATA
   );

   wire 	    rst_x;


   assign rst_x = RESET_X & SOFT_RESET;
   
   

endmodule // lmcnt
