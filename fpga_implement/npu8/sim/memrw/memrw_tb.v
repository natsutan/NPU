`timescale 1ns/1ns
module tb_top();
   `include "../common/common.v"

   

   initial begin
      hard_reset();
      dram_to_sram("lin.dat", `M1_SEL);
      $finish();
   end
   

endmodule // tb_top
