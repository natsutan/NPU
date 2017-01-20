
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
`define REG_AD_QPARAM 8'54
`define REG_MLC_GAGB 8'60
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
	end else if(msel == `M1_SEL) begin	
	   $readmemh({"../../../sim/memrw/input/", fname} ,  npu8_top.m1.mem);
	   $display("DMA %s to M0", fname);
	end 
     end
   endtask // dram_to_sram
   

     
