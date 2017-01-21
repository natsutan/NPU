`timescale 1ns / 1ns

`define SCENARIO "q_add_01"

module tb_top();

`include "../common/common.v"

   initial
     begin
	hard_reset();
	dram_to_sram("lin2.dat", `M1_SEL);
	dram_to_sram("lin2.dat", `M2_SEL);
	
	soft_reset();

	SET_INPUT_INV(0, 0);
	SET_OPCODE(`OPCODE_ADD);
	SET_OPERAND(`M1_SEL, `M2_SEL, `M3_SEL);
	SET_ADD_GAIN(16'h0100);
	SET_ADD_Q_PARAM(16'h0100);
       
	START_OPERATION();
	
	wait_irq(2000);
	
	sram_to_dram("lin2.dat", `M3_SEL);
	$finish();
     end
   
endmodule // tb_top

