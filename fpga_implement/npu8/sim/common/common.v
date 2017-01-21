
`define SIM_PATH "../../../sim/"
   


//registe address
`define REG_CTRL 8'h00
`define REG_STS  8'h04
`define REG_OP   8'h08
`define REG_MSEL 8'h0C
`define REG_INV  8'h10
`define REG_M0VAL    8'h14
`define REG_M0MAX    8'h18
`define REG_M0MIN    8'h1C
`define REG_M1SPOS   8'h20
`define REG_M1SIZE   8'h24
`define REG_M1MAX    8'h28
`define REG_M1MIN    8'h2C
`define REG_M2SPOS   8'h30
`define REG_M2SIZE   8'h34
`define REG_M2MAX    8'h38
`define REG_M2MIN    8'h3C
`define REG_M3SPOS   8'h40
`define REG_M3SIZE   8'h44
`define REG_M3MAX    8'h48
`define REG_M3MIN    8'h4C
`define REG_AD_GAIN  8'h50
`define REG_AD_QPARAM 8'h54
`define REG_MLC_GAGB 8'h60
`define REG_MLC_GAOB 8'h64
`define REG_MLC_GBOA 8'h68
`define REG_ML1_GAIN  8'h70
`define REG_ML1_QPARAM 8'h74
`define REG_ML2_GAIN  8'h78
`define REG_ML2_QPARAM 8'h7C
`define REG_REQ_MID 8'h80
`define REG_REQ_GAIN 8'h84  
`define REG_RMAX 8'hC0
`define REG_RMIN 8'hC4

`define OPCODE_ADD 2'b00
`define OPCODE_MUL 2'b01
`define OPCODE_RQT 2'b10


`define M0_SEL (0)
`define M1_SEL (1)
`define M2_SEL (2)
`define M3_SEL (3)


reg 	 CLK;
reg 	 RESET_X;
reg [7:0] 	 ADR;
reg 	 WR;
reg 	 RD;
wire [31:0]  RDATA;
reg [31:0] WDATA;
wire INT;



parameter PERIOD = 10.0; 
always # (PERIOD/2) CLK = ~CLK;
   

   initial begin
      #1 CLK = 1; 
      RESET_X = 1;
      ADR = 8'h00;
      WR = 0;
      RD = 0;
      WDATA = 32'h0000000;
   end


npu8_top npu8_top
  (
   .CLK(CLK),
   .RESET_X(RESET_X),
   
   .ADR(ADR),
   .WR(WR),
   .RD(RD),
   .RDATA(RDATA),
   .WDATA(WDATA),
   .INT(INT)	 
   );

   //HARDWARE API
   task hard_reset();
   begin
      # (PERIOD * 10)
      @(posedge CLK);
      RESET_X = 0;
      ADR = 8'h00;
      WR = 0;
      RD = 0;
      WDATA = 32'h00000000;
      # (PERIOD * 5)
      RESET_X = 1;
      # (PERIOD * 5)
      $display("hard reset");
   end
   endtask // hard_reset
   
   

   task dram_to_sram; 
      input [80*8:1] fname;
      input [1:0] msel;     
     begin
	if(msel == `M0_SEL)begin
	   $display("WARNING:DMA to M0");
	end else if (msel == `M1_SEL) begin	
	   $readmemh({`SIM_PATH, `SCENARIO, "/input/", fname} ,  npu8_top.m1.mem);
	   $display("DMA %s to M1", fname);
	end else if (msel == `M2_SEL) begin
	   $readmemh({`SIM_PATH, `SCENARIO, "/input/", fname} ,  npu8_top.m2.mem);
	   $display("DMA %s to M2", fname);
	end else if (msel == `M3_SEL) begin
	   $readmemh({`SIM_PATH, `SCENARIO, "/input/", fname} ,  npu8_top.m3.mem);
	   $display("DMA %s to M3", fname);
	end else begin
	   $display("DMA %s to %d", fname, msel);
	end
     end
   endtask // dram_to_sram
   

   task sram_to_dram; 
      input [80*8:1] fname;
      input [1:0] msel;     
     begin
	if(msel == `M0_SEL)begin
	   $display("WARNING:DMA from M0");
	end else if (msel == `M1_SEL) begin	
	   $writememh({`SIM_PATH, `SCENARIO, "/output/", fname},   npu8_top.m1.mem);
	   $display("DMA M1 to %s ", fname);
	end else if (msel == `M2_SEL) begin
	   $writememh({`SIM_PATH, `SCENARIO, "/output/", fname},   npu8_top.m2.mem);
	   $display("DMA M2 to %s", fname);
	end else if (msel == `M3_SEL) begin
	   $writememh({`SIM_PATH, `SCENARIO, "/output/", fname},   npu8_top.m3.mem);
	   $display("DMA M3 to %s", fname);
	end else begin
	   $display("WARNING DMA %s from %d", fname, msel);
	end
     end
   endtask // sram to dram
   
   //-------------------------------------------------------------
   // LOW LEVEL API
   task WRITE_REG;
      input [7:0] adr;
      input [31:0] data;
      begin
	 @(posedge CLK);
         ADR = adr;
	 WR = 1;
	 WDATA = data;
	 @(posedge CLK);
         ADR = 0;
	 WR = 0;
	 WDATA = 0;
	 @(posedge CLK);
      end
   endtask //

   task READ_REG;
      input [7:0] adr;
      output [31:0] rdata;
      
      begin
	 @(posedge CLK);
         ADR = adr;
	 RD = 1;
	 @(posedge CLK);
	 rdata = RDATA;
	 @(posedge CLK);
         ADR = 0;
	 RD = 0;
	 @(posedge CLK);
      end
   endtask //

   

   //-------------------------------------------------------------
   // MIDDLE LEVEL API
   task START_OPERATION;
      begin
	 WRITE_REG(`REG_CTRL, 32'h00000002);
      end
   endtask // WRITE_REG

   task SET_OPERAND;
      input [1:0] OP1;
      input [1:0] OP2;
      input [1:0] OP3;
      begin
	 WRITE_REG(`REG_MSEL, {26'h00000000, OP3, OP2, OP1});
      end
   endtask // WRITE_REG

   task SET_INPUT_INV;
      input A_INV;
      input B_INV;
      begin
	 WRITE_REG(`REG_INV, {30'h00000000, B_INV, A_INV });
      end
   endtask // WRITE_REG

   task SET_OPCODE;
      input [1:0] OP;
      begin
	 WRITE_REG(`REG_OP, {30'h00000000, OP });
      end
   endtask // WRITE_REG

   task SET_ADD_GAIN;
     input [15:0] GAIN;
      begin
	 WRITE_REG(`REG_AD_GAIN, {16'h0000, GAIN});
      end
   endtask // WRITE_REG

   task SET_ADD_Q_PARAM;
      input [15:0] Q_PARAM;
      begin
	 WRITE_REG(`REG_AD_QPARAM, {16'h0000, Q_PARAM});
      end
   endtask // WRITE_REG
   
   task SET_MUL_GAGB;
     input [15:0] GAGB;
      begin
	 WRITE_REG(`REG_MLC_GAGB, {16'h0000, GAGB});
      end
   endtask // WRITE_REG
   
   task SET_MUL1_GAIN;
      input [15:0] GAIN;
      begin
	 WRITE_REG(`REG_ML1_GAIN, {16'h0000, GAIN});
      end
   endtask // WRITE_REG

   task SET_MUL2_GAIN;
      input [15:0] GAIN;
      begin
	 WRITE_REG(`REG_ML2_GAIN, {16'h0000, GAIN});
      end
   endtask // WRITE_REG

   task SET_MUL1_QPARAM;
      input [15:0] QPARAM;
      begin
	 WRITE_REG(`REG_ML1_QPARAM, {16'h0000, QPARAM});
      end
   endtask // WRITE_REG

   task SET_MUL2_QPARAM;
      input [15:0] QPARAM;
      begin
	 WRITE_REG(`REG_ML2_QPARAM, {16'h0000, QPARAM});
      end
   endtask // WRITE_REG


   //-------------------------------------------------------------
   // APPLICATION API
   task soft_reset;
      begin
	 WRITE_REG(`REG_CTRL, 32'h00000001);
	 $display("soft reset");
      end
   endtask // WRITE_REG
   
   
   task wait_irq;
     input [31:0] timeout;
      reg [31:0]  cnt;
      reg 	  err;      
      begin
	 cnt = 0;
	 err = 0;
	 begin : BREAK
	    while (INT == 0) begin
	       @(posedge CLK);
	       cnt = cnt + 1;
	       if (cnt >=  timeout) begin
		  err = 1;
		  disable BREAK;
		  
	       end
	    end
	 end

	 if (err == 1) begin
	    $display("ERROR timeout");
	 end else begin
	    $display("Interrupt");
	 end
	 
      end
   endtask //
   
	
