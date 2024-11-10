`timescale 1ns / 1ps

module control_MEM_WB(
    input  logic       clk_i,
    input  logic       reset_i,
    //input  logic       enable_i, prank 'em Shinji
    
    input  logic       regwritem_i,
    input  logic [1:0] resultsrcm_i,
    
    output logic       regwritew_o,
    output logic [1:0] resultsrcw_o                     
    );
    
    always_ff @(posedge clk_i) begin
        if (reset_i) begin       
            regwritew_o  <= 0;
            resultsrcw_o <= 0;       
        end
        
        else begin //else if (enable_i) begin
            regwritew_o  <= regwritem_i;
            resultsrcw_o <= resultsrcm_i;   
        end    
    end    
endmodule
