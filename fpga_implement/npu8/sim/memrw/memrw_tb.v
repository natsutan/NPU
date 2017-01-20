`timescale 1ns/1ns
module tb_top();
   `include "../common/common.v"

   

   initial begin
      hard_reset();
      
      $finish();
   end
   

endmodule // tb_top
