`timescale 1ns / 1ps

module registro_ID_EX(
    input logic clk_i,
    input logic reset_i,
    input logic flush_i,    
    input logic [31:0] rd1_i,
    input logic [31:0] rd2_i,
    input logic [31:0] pcd_i,
    input logic [4:0]  rs1d_i,
    input logic [4:0]  rd2d_i,
    input logic [4:0]  rdd_i,
    input logic [31:0] immextd_i,
    input logic [31:0] pcplus4d_i,
    input logic hitD_i,
    input logic [1:0] prediccionD_i,
    input logic selbpD_i,
    
    output logic [31:0] rd1e_o,
    output logic [31:0] rd2e_o,
    output logic [31:0] pce_o,
    output logic [4:0]  rs1e_o,
    output logic [4:0]  rs2e_o,
    output logic [4:0]  rde_o,
    output logic [31:0] immexte_o,
    output logic [31:0] pcplus4e_o,
    output logic hitE_o,
    output logic [1:0] prediccionE_o,
    output logic selbpE_o  
    );
                      
    always_ff @(posedge clk_i) begin   
        if (reset_i) begin       
            rd1e_o     <= 0;
            rd2e_o     <= 0;
            pce_o      <= 0;
            rs1e_o     <= 0;
            rs2e_o     <= 0;
            rde_o      <= 0;
            immexte_o  <= 0;
            pcplus4e_o <= 0;
            hitE_o     <= 0;
            prediccionE_o <= 0;
            selbpE_o <= 0;     
        end
        
        else if (flush_i) begin
            rd1e_o     <= 0;
            rd2e_o     <= 0;
            pce_o      <= 0;
            rs1e_o     <= 0;
            rs2e_o     <= 0;
            rde_o      <= 0;
            immexte_o  <= 0;
            pcplus4e_o <= 0;
            hitE_o     <= 0;
            prediccionE_o <= 0;
            selbpE_o <= 0; 
        end
        
        else begin    
            rd1e_o     <= rd1_i;
            rd2e_o     <= rd2_i;
            pce_o      <= pcd_i;
            rs1e_o     <= rs1d_i;
            rs2e_o     <= rd2d_i;
            rde_o      <= rdd_i;
            immexte_o  <= immextd_i;
            pcplus4e_o <= pcplus4d_i;
            hitE_o     <= hitD_i;
            prediccionE_o <= prediccionD_i;
            selbpE_o <= selbpD_i;       
        end
    end                      
endmodule
