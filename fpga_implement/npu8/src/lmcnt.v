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

   output 	    M1_WR,
   output [9:0]     M1_WADR,
   output [7:0]     M1_WDATA,
   output [9:0]     M1_RADR,
   input [7:0] 	    M1_RDATA,

   output 	    M2_WR,
   output [9:0]     M2_WADR,
   output [7:0]     M2_WDATA,
   output [9:0]     M2_RADR,
   input [7:0] 	    M2_RDATA,

   output 	    M3_WR,
   output [9:0]     M3_WADR,
   output [7:0]     M3_WDATA,
   output [9:0]     M3_RADR,
   input [7:0] 	    M3_RDATA,

   
   //npu
   output reg 	    NPU_EN,
   output reg [7:0] A_RDATA,
   output reg [7:0] B_RDATA,

   input 	    LM_EN,
   input [7:0] 	    C_WDATA
   );

   wire 	    rst_x;


   assign rst_x = RESET_X & ~SOFT_RESET;
   
   
   reg [9:0] 	    rcnt;
   reg [9:0] 	    wcnt;

   always @ (posedge CLK or negedge rst_x)begin
      if (rst_x == 0)begin
	 rcnt <= 0;
      end else begin
	 if ((rcnt == 0) && (START == 1))begin
	    rcnt <= 1;
	 end else if((rcnt != 0) && (rcnt != 10'h3FF))begin
	    rcnt <= rcnt + 1;
	 end
      end
   end 

   always @ (posedge CLK or negedge rst_x)begin
      if (rst_x == 0)begin
	 NPU_EN <= 0;
      end else begin
	 if (START == 1)begin
	    NPU_EN <= 1;
	 end else if(rcnt == 10'h3FF)begin
	    NPU_EN <= 0;
	 end
      end
   end 

   always @ (posedge CLK or negedge rst_x)begin
      if (rst_x == 0)begin
	 wcnt <= 0;
      end else begin
	 if(LM_EN)begin
	    wcnt <= wcnt + 1;
	 end
      end
   end 

   always @ (posedge CLK or negedge rst_x)begin
      if (rst_x == 0)begin
	 FINISH <= 0;
      end else begin
	 if(wcnt == 10'h3FF)begin
	    FINISH <= 1;
	 end
      end
   end 

   //read
   assign M1_RADR = rcnt;
   assign M2_RADR = rcnt;
   assign M3_RADR = rcnt;

   always @ (posedge CLK or negedge rst_x)begin
      if (rst_x == 0)begin
	 A_RDATA <= 0;
      end else begin
	 case (MSEL_INPUTA_SEL)
	   2'b00: A_RDATA <= M0_RDATA;
	   2'b01: A_RDATA <= M1_RDATA;
	   2'b10: A_RDATA <= M2_RDATA;
	   2'b11: A_RDATA <= M3_RDATA;
	 endcase // case (MSEL_INPUTA_SEL)
      end
   end 

   always @ (posedge CLK or negedge rst_x)begin
      if (rst_x == 0)begin
	 B_RDATA <= 0;
      end else begin
	 case (MSEL_INPUTB_SEL)
	   2'b00: B_RDATA <= M0_RDATA;
	   2'b01: B_RDATA <= M1_RDATA;
	   2'b10: B_RDATA <= M2_RDATA;
	   2'b11: B_RDATA <= M3_RDATA;
	 endcase // case (MSEL_INPUTB_SEL)
      end
   end 

   //write
   assign M1_WR = (MSEL_OUTPUTC_SEL == 2'b01) ? LM_EN : 0;
   assign M2_WR = (MSEL_OUTPUTC_SEL == 2'b10) ? LM_EN : 0;   
   assign M3_WR = (MSEL_OUTPUTC_SEL == 2'b11) ? LM_EN : 0;

   assign M1_WADR = wcnt;
   assign M2_WADR = wcnt;
   assign M3_WADR = wcnt;

   assign M1_WDATA = C_WDATA;
   assign M2_WDATA = C_WDATA;
   assign M3_WDATA = C_WDATA;
   
endmodule // lmcnt
