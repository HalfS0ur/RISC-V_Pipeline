`timescale 1ns / 1ps

module regfile(
    input logic clk_i,
    input logic we3_i,
    input logic [4:0] a1_i, a2_i, a3_i,
    input logic [31:0] wd3_i,
    output logic [31:0] rd1_o, rd2_o);
					
	logic [31:0] rf[31:0]; 	// register file
	

	
	// write on falling edge
	// read on rising edge 
	
	// r0 hardwired to 0
	
	
	assign rd1_o = (a1_i != 0 ) ? rf[a1_i] : 0;
	assign rd2_o = (a2_i != 0 ) ? rf[a2_i] : 0;
	
	
	always_ff @(negedge clk_i)
		if (we3_i) rf[a3_i] <= wd3_i;

endmodule
