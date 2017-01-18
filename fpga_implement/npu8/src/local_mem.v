//local memory
module local_mem
  (
   input CLK,
   input WR,
   input [9:0] WADR,
   input [9:0] RADR,

   input [7:0] WDATA,
   output [7:0] RDATA
   );

   reg [7:0] 	mem [1023:0];

   always @ (posedge CLK) begin
      if(WR)begin
	 mem[WADR] <= WDATA;
      end
   end
   
   assign RDATA = mem[RADR];
   
endmodule // local_mem
