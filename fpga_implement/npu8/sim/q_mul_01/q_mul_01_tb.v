`timescale 1ns / 1ns

`define SCENARIO "q_mul_01"

module tb_top();

`include "../common/common.v"

   initial
     begin
	hard_reset();
	dram_to_sram("lin.dat", `M1_SEL);
	dram_to_sram("sin.dat", `M2_SEL);
	
	soft_reset();

	SET_INPUT_INV(1, 0);
	SET_OPCODE(`OPCODE_MUL);
	SET_OPERAND(`M1_SEL, `M2_SEL, `M3_SEL);

	//p_gagb = 0.003922(257), p_gaob = 0.000000(0), p_gboa = 0.000000(0)
	//gain = 0.108507(1b), q_param = 0.902114(e6)
	//gain = 0.498827(7f), q_param = 0.667188(aa)
	SET_MUL_GAGB(32'h00000257);
	SET_MUL1_GAIN(16'h001b);
	SET_MUL1_QPARAM(16'h00e6);
	SET_MUL2_GAIN(16'h007F);
	SET_MUL2_QPARAM(16'h00aa);
	
       
	START_OPERATION();
	
	wait_irq(2000);
	
	sram_to_dram("q_mul.dat", `M3_SEL);
	$finish();
     end
   
endmodule // tb_top

