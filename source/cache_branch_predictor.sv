`timescale 1ns / 1ps

module cache_branch_predictor(
    input logic clk_i,
    input logic reset_i, // Add reset input
    input logic we_i,
    input logic [4:0] indexE_i,
    input logic [26:0] tagE_i,
    input logic [4:0] indexF_i,
    input logic [31:0] dirsaltoE_i,
    input logic [1:0] prediccionDir_i,
    
    output logic [26:0] tag_o,
    output logic [31:0] dirobjetivoF_o,
    output logic [1:0] prediccion_o
    );
    
    logic [26:0] tag [31:0];
    logic [31:0] dir_salto [31:0];
    logic [1:0] prediccion [31:0];
    
    assign tag_o = tag[indexF_i];
    assign dirobjetivoF_o = dir_salto[indexF_i];
    assign prediccion_o = prediccion[indexF_i];
    
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            // Reset the cache content when reset_i is asserted
            for (int i = 0; i < 32; i = i + 1) begin
                tag[i] <= 0;
                dir_salto[i] <= 0;
                prediccion[i] <= 2'b01; // Reset the prediction to 01
            end
        end else if (we_i) begin
            tag[indexE_i] <= tagE_i;
            dir_salto[indexE_i] <= dirsaltoE_i;
            prediccion[indexE_i] <= prediccionDir_i;
        end
    end
endmodule
