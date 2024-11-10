`timescale 1ns / 1ps


module registro_IF_ID(
    input  logic        clk_i,
    input  logic        reset_i,
    input  logic        enable_i,
    input  logic        flush_i,   
    input  logic [31:0] rd_i,
    input  logic [31:0] pcf_i,
    input  logic [31:0] pcplus4f_i,
    input logic hitF_i,
    input logic [1:0] prediccionF_i,
    input logic selbpF_i,
    
    output logic [31:0] instrd_o,
    output logic [31:0] pcd_o, 
    output logic [31:0] pcplus4d_o,
    output logic hitD_o,
    output logic [1:0] prediccionD_o,
    output logic selbpD_o  
    );
                      
    always_ff @(posedge clk_i) begin 
        if (reset_i) begin
            pcd_o      <= 0;
            instrd_o   <= 0;
            pcplus4d_o <= 0;
            hitD_o     <= 0;
            prediccionD_o <= 0;
            selbpD_o <= 0;     
        end
        
        else if (enable_i) begin
            if (flush_i) begin
                pcd_o      <= 0;
                instrd_o   <= 0;
                pcplus4d_o <= 0;
                hitD_o     <= 0;
                prediccionD_o <= 0;
                selbpD_o <= 0;  
            end
            
            else begin  
                pcd_o      <= pcf_i;
                instrd_o   <= rd_i;
                pcplus4d_o <= pcplus4f_i;
                hitD_o     <= hitF_i;
                prediccionD_o <= prediccionF_i;
                selbpD_o <= selbpF_i;
            end
        end
    end           
endmodule
