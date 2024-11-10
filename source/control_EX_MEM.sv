`timescale 1ns / 1ps

module control_EX_MEM(
    input  logic       clk_i,
    input  logic       reset_i,
    
    input  logic       regwritee_i,
    input  logic [1:0] resultsrce_i,
    input  logic       memwritee_i,
    
    output logic       regwritem_o,
    output logic [1:0] resultsrcm_o,
    output logic       memwritem_o
    );
                      
    always_ff @(posedge clk_i) begin   
        if (reset_i) begin      
            regwritem_o  <= 0;
            resultsrcm_o <= 0;
            memwritem_o  <= 0;     
        end
        
        else begin   //else if (enable_i) begin
            regwritem_o  <= regwritee_i;
            resultsrcm_o <= resultsrce_i;
            memwritem_o  <= memwritee_i;        
        end   
    end                     
endmodule