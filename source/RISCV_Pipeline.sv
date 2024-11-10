`timescale 1ns / 1ps

module RISCV_Pipeline(
    input logic clk_i,
    input logic reset_i,
    input logic [31:0] ProgIn,
    input logic [31:0] DataIn_i,
    input logic desactivar_bp_i,
    input logic desactivar_fw_i,
    
    output logic [31:0] PCF_o,
    output logic [31:0] ALUResultM_o,
    output logic [31:0] WriteDataM_o,
    output logic MemWriteM_o,
    output logic [31:0] ResultadoW_o,
    output logic [4:0] dirRegfile_o,
    output logic       Stall_o,
    output logic test_control,
    output logic branch_predictor_activo,
    output logic [1:0] prediccion_o,
    output logic flush_o
    );
       
    logic [31:0] InstrD_o;
    logic [2:0] immSrc, ALUControl;
    logic ALUSrcAE, zero, PCSrcE, PCJandL, RegWrite, RegWriteM, ResultSrcE0, StallD, StallF, FlushD, FlushE, signo, RegWriteE;
    logic [1:0] ALUSrcBE, ResultSrcW, ForwardAE, ForwardBE;
    logic [4:0] Rs1E, Rs2E, RdM, RdW, RdE, Rs1D, Rs2D;
    logic branch_taken, branch_predictor_we, bp_activo, flush_pred, test_control_c;
 
       
    datapath datapath_RISCV(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .ProgIn(ProgIn),
        .immSrc_i(immSrc),
        .ALUSrcAE_i(ALUSrcAE),
        .ALUSrcBE_i(ALUSrcBE),
        .ALUControl_i(ALUControl),
        .PCSrcE_i(PCSrcE),
        .branch_taken_i(branch_taken),
        .PCJandL_i(PCJandL),
        .dataIn_i(DataIn_i),
        .RegWrite_i(RegWrite),
        .ResultSrcW_i(ResultSrcW),
        .ForwardAE_i(ForwardAE),
        .ForwardBE_i(ForwardBE),
        .StallD_i(StallD),
        .StallF_i(StallF),
        .FlushD_i(FlushD),
        .FlushE_i(FlushE),
        .branch_predictor_we_i(branch_predictor_we),
        .desactivar_bp_i(desactivar_bp_i),
        //Salidas
        .PCF_o(PCF_o),
        .InstrD_o(InstrD_o),
        .Rs1E_o(Rs1E),
        .Rs2E_o(Rs2E),
        .RdE_o(RdE),
        .zero_o(zero),
        .ALUResultM_o(ALUResultM_o),
        .WriteDataM_o(WriteDataM_o),
        .RdM_o(RdM),
        .RdW_o(RdW),
        .Rs1D_o(Rs1D),
        .Rs2D_o(Rs2D),
        .signo_o(signo),
        .ResultadoW_o(ResultadoW_o),
        .dirRegfile_o(dirRegfile_o),
        .bp_activo_o(bp_activo),
        .prediccion(prediccion_o),
        .flush_pred_o(flush_pred)
    );
    
    controller control_RISCV(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .flush_i(FlushE),
        .op_i(InstrD_o[6:0]),
        .funct3_i(InstrD_o[14:12]),
        .funct7b5_i(InstrD_o[30]),
        .zero_i(zero),
        .signo_i(signo),
        //Salidas
        .immSrc_o(immSrc),
        .ALUSrcAE_o(ALUSrcAE),
        .ALUSrcBE_o(ALUSrcBE),
        .ALUControlE_o(ALUControl),
        .PCSrcE_o(PCSrcE),
        .PCJandL_o(PCJandL),
        .ResultSrcEb0_o(ResultSrcE0),
        .MemWriteM_o(MemWriteM_o),
        .RegWriteW_o(RegWrite),
        .ResultSrcW_o(ResultSrcW),
        .RegWriteM_o(RegWriteM),
        .branch_taken_o(branch_taken),
        .branch_predictor_we_o(branch_predictor_we),
        .RegWriteE_o(RegWriteE),
        .test(test_control_c)
    );
    
    unidad_atascamiento unidad_atascamiento(
        .Rs1D(Rs1D),        
        .Rs2D(Rs2D),        
        .RdE(RdE),
        .RdM_i(RdM),
        .RdW_i(RdW),
        .desactivar_fw_i(desactivar_fw_i),         
        .ResultSrcE0(ResultSrcE0),    
        .PCSrcE(PCSrcE),
        .bp_activo_i(bp_activo),
        .RegWriteE_i(RegWriteE),
        .RegWriteM_i(RegWriteM),
        .RegWriteW_i(RegWrite),
        //Salidas         
        .StallD(StallD),      
        .StallF(StallF),      
        .FlushD(FlushD),      
        .FlushE(FlushE)       
    );
    
    unidad_adelantamiento unidad_adelantamiento(
        .Rs1E(Rs1E),     
        .Rs2E(Rs2E),     
        .RdM(RdM),      
        .RdW(RdW),      
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWrite),
        .desactivar_fw_i(desactivar_fw_i), //.desactivar_fw_i(desactivar_fw_i),
         //Salidas
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );
    
    assign Stall_o = StallD & StallF;
    assign branch_predictor_activo = bp_activo;
    assign flush_o = flush_pred | FlushD | FlushE;
    assign test_control = test_control_c & !bp_activo;
endmodule
