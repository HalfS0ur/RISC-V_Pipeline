`timescale 1ns / 1ps

module last_time_predictor(
    input logic clk_i,
    input logic reset_i,
    input logic we_i,
    input logic [31:0] pcE_i,
    input logic [31:0] pcF_i,
    input logic [31:0] dirsaltoE_i,
    input logic branch_taken_i,
    input logic [1:0] old_prediction_i, //meter a los puertos en el datapath
    input logic desactivar_bp_i,
    
    output logic [31:0] dirobjetivoF_o,
    output logic [1:0] prediccion_o,
    output logic sel_mux_pred_o,
    output logic hit_o
    );
    
    logic [26:0] tag_cache;
    logic [1:0] old_prediction, new_prediction;
    
    cache_branch_predictor CBP(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .we_i(we_i),
        .indexE_i(pcE_i[4:0]),
        .tagE_i(pcE_i[31:5]),
        .indexF_i(pcF_i[4:0]), //Los demás bits de pcF se usan para comparar con el tag (ocupo un módulo o algo para hacer eso)
        .dirsaltoE_i(dirsaltoE_i),
        .prediccionDir_i(new_prediction),
        .tag_o(tag_cache),
        .dirobjetivoF_o(dirobjetivoF_o),
        .prediccion_o(prediccion_o)
    );
    
    two_bit_predictor TBP(
    .old_prediction_i(old_prediction_i),   // Last Prediction
    .taken_i(branch_taken_i),                  // Branch taken?
    .desactivar_bp_i(desactivar_bp_i),
    .new_prediction_o(new_prediction)
    );
    
    assign hit_o = (tag_cache == pcF_i[31:5]) ? 1 : 0;
    
    assign sel_mux_pred_o = prediccion_o [1] & hit_o;
    
    //assign prediccion_o = old_prediction;
    
endmodule
