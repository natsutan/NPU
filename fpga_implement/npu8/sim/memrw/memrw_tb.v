`timescale 1ns/1ns

`define SCENARIO "memrw"


module tb_top();
   
   `include "../common/common.v"

   initial begin
      hard_reset();
      dram_to_sram("lin.dat", `M1_SEL);
      
      soft_reset();
      SET_OPERAND(`M1_SEL, `M1_SEL, `M1_SEL);
      START_OPERATION();
      
      wait_irq(2000);
      

      sram_to_dram("lin.dat", `M1_SEL);
     $finish();
   end
   

endmodule // tb_top
 
