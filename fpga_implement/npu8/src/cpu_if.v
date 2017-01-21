// cpu interface
module cpu_if
  (
   input 	     CLK,
   input 	     RESET_X,

   // CPU
   input [7:0] 	     ADR,
   output reg [31:0]      RDATA,
   input 	     RD,
   input 	     WR,
   input [31:0]     WDATA,
   output reg 	     INT,

   //REGISTERS
   output reg 	     SOFT_RESET,
   output reg 	     START,
   input 	     FINISH,
   //input RUNNING
   output reg [1:0]  OP, // 0:ADD 1:MUL 2:RQT
   output reg [1:0]  MSEL_INPUTA_SEL,
   output reg [1:0]  MSEL_INPUTB_SEL,
   output reg [1:0]  MSEL_OUTPUTC_SEL,
   output reg 	     INV_ASEL,
   output reg 	     INV_BSEL,
		    
   output reg [31:0] M0VAL,

   output reg [9:0]  M1POS,
   output reg [9:0]  M1SIZE,

   output reg [9:0]  M2POS,
   output reg [9:0]  M2SIZE,
   
   output reg [9:0]  M3POS,
   output reg [9:0]  M3SIZE,
	
   //ADD	    
   output reg [31:0] AD_GAIN,
   output reg [31:0] AD_QPARAM,

   //MULL CORE
   output reg [31:0] MLC_GAGB, 
   output reg [31:0] MLC_GAOB,
   output reg [31:0] MLC_GBOA, 
   
   // MULL ADD1
   output reg [31:0] ML1_GAIN,
   output reg [31:0] ML1_QPARAM,
   output reg [31:0] ML2_GAIN,
   output reg [31:0] ML2_QPARAM,
		     
   output reg [7:0]  REQ_MID,
   output reg [31:0] REQ_GAIN,
   
   input [15:0] 	     RMAX,
   input [15:0] 	     RMIN
   );

   reg 		     run_r;
   
   
   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 INT <= 0;
      end else begin
	 INT <= FINISH;
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 START <= 0;
	 SOFT_RESET <= 0;
      end else begin
	 if((ADR==8'h00) && WR)begin
	    START <= WDATA[1];
	    SOFT_RESET <= WDATA[0];
	 end else begin
	    START <= 0;
	    SOFT_RESET <= 0;
	 end
      end
   end
   
   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 run_r <= 0;
      end else begin
	 if(START)begin
	    run_r <= 1;
	 end else if(FINISH)begin
	    run_r <= 0;
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 OP <= 0;
      end else begin
	 if((ADR==8'h08) && WR)begin
	    OP <= WDATA[1:0];
	 end
      end
   end
   
   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 MSEL_INPUTA_SEL <= 0;
	 MSEL_INPUTB_SEL <= 0;
	 MSEL_OUTPUTC_SEL <= 0;
      end else begin
	 if((ADR==8'h0C) && WR)begin
	    MSEL_INPUTA_SEL <= WDATA[1:0];
	    MSEL_INPUTB_SEL <= WDATA[3:2];
	    MSEL_OUTPUTC_SEL <= WDATA[5:4];
	 end
      end
   end
   
   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 INV_ASEL <= 0;
	 INV_BSEL <= 0;
      end else begin
	 if((ADR==8'h10) && WR)begin
	    INV_ASEL <= WDATA[0];
	    INV_BSEL <= WDATA[1];
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 M0VAL <= 0;
      end else begin
	 if((ADR==8'h14) && WR)begin
	    M0VAL <= 0;
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 M1POS <= 0;
      end else begin
	 if((ADR==8'h20) && WR)begin
	    M1POS <= WDATA[9:0];
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 M1SIZE <= 0;
      end else begin
	 if((ADR==8'h24) && WR)begin
	    M1SIZE <= WDATA[9:0];
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 M2POS <= 0;
      end else begin
	 if((ADR==8'h30) && WR)begin
	    M2POS <= WDATA[9:0];
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 M2SIZE <= 0;
      end else begin
	 if((ADR==8'h34) && WR)begin
	    M2SIZE <= WDATA[9:0];
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 M3POS <= 0;
      end else begin
	 if((ADR==8'h40) && WR)begin
	    M2POS <= WDATA[9:0];
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 M3SIZE <= 0;
      end else begin
	 if((ADR==8'h44) && WR)begin
	    M3SIZE <= WDATA[9:0];
	 end
      end
   end

  always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 AD_GAIN <= 0;
      end else begin
	 if((ADR==8'h50) && WR)begin
	    AD_GAIN <= WDATA;
	 end
      end
   end

  always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 AD_QPARAM <= 0;
      end else begin
	 if((ADR==8'h54) && WR)begin
	    AD_QPARAM <= WDATA;
	 end
      end
   end

  always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 MLC_GAGB <= 0;
      end else begin
	 if((ADR==8'h60) && WR)begin
	    MLC_GAGB <= WDATA;
	 end
      end
   end
   
  always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 MLC_GAOB <= 0;
      end else begin
	 if((ADR==8'h64) && WR)begin
	    MLC_GAOB <= WDATA;
	 end
      end
   end
   
  always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 MLC_GBOA <= 0;
      end else begin
	 if((ADR==8'h68) && WR)begin
	    MLC_GBOA <= WDATA;
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 ML1_GAIN <= 0;
      end else begin
	 if((ADR==8'h70) && WR)begin
	    ML1_GAIN <= WDATA;
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 ML1_QPARAM <= 0;
      end else begin
	 if((ADR==8'h74) && WR)begin
	    ML1_QPARAM <= WDATA;
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 ML2_GAIN <= 0;
      end else begin
	 if((ADR==8'h78) && WR)begin
	    ML2_GAIN <= WDATA;
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 ML2_QPARAM <= 0;
      end else begin
	 if((ADR==8'h7C) && WR)begin
	    ML2_QPARAM <= WDATA;
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 REQ_MID <= 0;
      end else begin
	 if((ADR==8'h80) && WR)begin
	    REQ_MID <= WDATA[7:0];
	 end
      end
   end

   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 REQ_GAIN <= 0;
      end else begin
	 if((ADR==8'h84) && WR)begin
	    REQ_GAIN <= WDATA;
	 end
      end
   end

   // RDATA
   always @ (posedge CLK or negedge RESET_X) begin
      if (RESET_X==0)begin
	 RDATA <= 0;
      end else begin
	 if(RD)begin
	    case (ADR)
	      8'h04:begin
		 RDATA[31:2] <= 30'h00000000;
		 RDATA[1] <= run_r;
		 RDATA[0] <= FINISH;
	      end
	      8'hC0: begin
		 RDATA[31:16] <= 24'h000000;
		 RDATA[15:0] <= RMAX;
	      end
	      8'hC4: begin
		 RDATA[31:16] <= 24'h000000;
		 RDATA[15:0] <= RMIN;
	      end
	      default: RDATA <= 0;
	      
	    endcase // case ADR
	 end
      end
   end
   
endmodule // cpu_if
