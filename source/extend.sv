`timescale 1ns / 1ps

module extend (
    input logic [31:7] instr_i,
    input logic [2:0] immsrc_i, 
    output logic [31:0] immext_o);


	always_comb
		case(immsrc_i)
		// I-type
		3'b000: immext_o = {{20{instr_i[31]}}, instr_i[31:20]};
		
		// S-type (stores)
		3'b001: immext_o = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
		
		// B-type (branches)
		3'b010: immext_o = {{20{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
		
		// J-type (jal)
		3'b011: immext_o = {{12{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
		
		// U-type
		3'b100: immext_o = {instr_i[31:12], 12'b0};
		
		default: immext_o = 32'bx; // undefined
	endcase
endmodule
