`timescale 1ns / 1ns

`define SCENARIO "q_add_02"

module tb_top();

`include "../common/common.v"

   initial
     begin
	hard_reset();
	dram_to_sram("lin.dat", `M1_SEL);
	dram_to_sram("sin.dat", `M2_SEL);
	
	soft_reset();

	SET_INPUT_INV(0, 0);
	SET_OPCODE(`OPCODE_ADD);
	SET_OPERAND(`M1_SEL, `M2_SEL, `M3_SEL);

	// gain = 0.195312(31), q_param = 0.836602(d6)
	SET_ADD_GAIN(16'h0031);
	SET_ADD_Q_PARAM(16'h00d6);
       
	START_OPERATION();
	
	wait_irq(2000);
	
	sram_to_dram("q_add.dat", `M3_SEL);
	$finish();
     end
   
endmodule // tb_top

