`timescale 1ns / 1ps

module controlador_flush_bp(
    input logic [1:0] prediccion_actual_i,
    input logic taken_i,
    
    output logic flush_predictor_o
    );
    
    always_comb begin
        flush_predictor_o = 1'b0;
        
        if (prediccion_actual_i == 2'b11) begin
            if (taken_i == 1'b0) begin
                flush_predictor_o = 1;
            end
        end
        
        else if (prediccion_actual_i == 2'b10) begin
            if (taken_i == 1'b0) begin
                flush_predictor_o = 1;
            end
        end
    end
endmodule
