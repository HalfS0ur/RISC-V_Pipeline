`timescale 1ns / 1ps

module datapath(
    input logic clk_i,
    input logic reset_i,
    input logic [31:0] ProgIn,
    input logic [2:0] immSrc_i,
    input logic ALUSrcAE_i,
    input logic [1:0] ALUSrcBE_i,
    input logic [2:0] ALUControl_i,
    input logic PCSrcE_i,
    input logic branch_taken_i,
    input logic PCJandL_i,
    input logic [31:0] dataIn_i,
    input logic RegWrite_i,
    input logic [1:0] ResultSrcW_i,
    input logic [1:0] ForwardAE_i,
    input logic [1:0] ForwardBE_i,
    input logic StallD_i,
    input logic StallF_i,
    input logic FlushD_i,
    input logic FlushE_i,
    input logic branch_predictor_we_i,
    input logic desactivar_bp_i,
    //Salidas
    output logic [31:0] PCF_o,
    output logic [31:0] InstrD_o,
    output logic [4:0] Rs1E_o,
    output logic [4:0] Rs2E_o,
    output logic [4:0] RdE_o,
    output logic zero_o,
    output logic [31:0] ALUResultM_o,
    output logic [31:0] WriteDataM_o,
    output logic [4:0] RdM_o,
    output logic [4:0] RdW_o,
    output logic [4:0] Rs1D_o,
    output logic [4:0] Rs2D_o,
    output logic signo_o,
    //Señales de prueba para el testbench
    output logic [31:0] ResultadoW_o,
    output logic [4:0] dirRegfile_o,
    output logic bp_activo_o,
    output logic [1:0] prediccion,
    output logic flush_pred_o
    );
    
    //Conexiones internas
    //Fetch
    logic [31:0] PCNext, PCPlus4, JumpTarget, DirObjetivoBP, PCPredicho, PCmispredict;
    logic [1:0] prediccionF;
    logic sel_mux_bp, hitF, bp_flush;
    //Decode
    logic [31:0] PCD, PCPlus4D, RD1D, RD2D, ImmExtD;
    logic [1:0] prediccionD;
    logic hitD, selbpD;
    //Execute
    logic [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E, SrcAEAdelantada, SrcAE, WriteDataE, 
    SrcBE, PCTargetE, ALUResult;
    logic [1:0] prediccionE;
    logic hitE, selbpE, flush_predictor;
    //Memory
    logic [31:0] PCPlus4M;
    //WirteBack
    logic [31:0] ALUResultW, ReadDataW, PCPlus4W, ResultadoW;
    
    //-------------------------------------Fetch-------------------------------------
    flopenr #(32) pcreg(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .en_i(~StallF_i),
        .d_i(PCNext),
        .q_o(PCF_o)
    );
    
    adder sumaPCmas4(
        .a_i(PCF_o),
        .b_i(32'd4),
        .y_o(PCPlus4)
    );
    
    mux2 #(32) muxJandL(
        .d0_i(PCTargetE),
        .d1_i(ALUResult),
        .s_i(PCJandL_i),
        .y_o(JumpTarget)
    );
    
    mux2 #(32) pcmux(
        .d0_i(PCPredicho), //antes era PCPlus4
        .d1_i(JumpTarget),
        .s_i(PCSrcE_i & !selbpE), //PCSrcE & !hitE antes no tenia el !hit
        .y_o(PCNext)
    );
    
    //Predictor de saltos
    last_time_predictor predictor_de_saltos(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .we_i(branch_predictor_we_i), //Se puede hacer un or de la senal branche y jumpe en el controlador
        .pcE_i(PCE),
        .pcF_i(PCF_o),
        .dirsaltoE_i(PCTargetE),
        .branch_taken_i(branch_taken_i),
        .old_prediction_i(prediccionE),
        .desactivar_bp_i(desactivar_bp_i),
        //salidas
        .dirobjetivoF_o(DirObjetivoBP), //va al nuevo mux
        .prediccion_o(prediccionF), //2 bits de prediccion de la FSM
        .sel_mux_pred_o(sel_mux_bp),
        .hit_o(hitF)
    );
    
    mux2 #(32) muxprediccion(
        .d0_i(PCPlus4),
        .d1_i(PCmispredict),
        .s_i(sel_mux_bp),
        .y_o(PCPredicho)
    );
    
    mux2 #(32) muxmispredict(
        .d0_i(DirObjetivoBP),
        .d1_i(PCPlus4E),
        .s_i(flush_predictor),
        .y_o(PCmispredict)
    );
        
    //-------------------------------------IF/ID-------------------------------------
    registro_IF_ID registro_IF_ID(
        .clk_i(clk_i),      
        .reset_i(reset_i),    
        .enable_i(~StallD_i),   
        .flush_i(FlushD_i | flush_predictor),    
        .rd_i(ProgIn),       
        .pcf_i(PCF_o),      
        .pcplus4f_i(PCPlus4), 
        .hitF_i(hitF),
        .prediccionF_i(prediccionF),
        .selbpF_i(sel_mux_bp),
        //Salidas            
        .instrd_o(InstrD_o),   
        .pcd_o(PCD),      
        .pcplus4d_o(PCPlus4D),
        .hitD_o(hitD),
        .prediccionD_o(prediccionD),
        .selbpD_o(selbpD)  
    );
    
    //-------------------------------------Decode-------------------------------------
    regfile archivo_de_registros(
        .clk_i(clk_i),
        .we3_i(RegWrite_i),
        .a1_i(InstrD_o[19:15]),
        .a2_i(InstrD_o[24:20]),
        .a3_i(RdW_o),
        .wd3_i(ResultadoW),
        .rd1_o(RD1D),
        .rd2_o(RD2D)
    );
    
    extend extension_de_inmediato(
        .instr_i(InstrD_o[31:7]),
        .immsrc_i(immSrc_i),
        .immext_o(ImmExtD)
    );
    
    assign Rs1D_o = InstrD_o[19:15];
    assign Rs2D_o = InstrD_o[24:20];
    
    //-------------------------------------ID/EX-------------------------------------
    registro_ID_EX registro_ID_EX(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .flush_i(FlushE_i | flush_predictor),
        .rd1_i(RD1D),     
        .rd2_i(RD2D),     
        .pcd_i(PCD),     
        .rs1d_i(InstrD_o[19:15]),    
        .rd2d_i(InstrD_o[24:20]),    
        .rdd_i(InstrD_o[11:7]),     
        .immextd_i(ImmExtD), 
        .pcplus4d_i(PCPlus4D),
        .hitD_i(hitD),
        .prediccionD_i(prediccionD),
        .selbpD_i(selbpD),
         //Salidas    
        .rd1e_o(RD1E),   
        .rd2e_o(RD2E),   
        .pce_o(PCE),    
        .rs1e_o(Rs1E_o),   
        .rs2e_o(Rs2E_o),   
        .rde_o(RdE_o),    
        .immexte_o(ImmExtE),
        .pcplus4e_o(PCPlus4E),
        .hitE_o(hitE),
        .prediccionE_o(prediccionE),
        .selbpE_o(selbpE)
    );
    
    //-------------------------------------Execute-------------------------------------
    mux3 #(32) adelantaA(
        .d0_i(RD1E),
        .d1_i(ResultadoW),
        .d2_i(ALUResultM_o),
        .s_i(ForwardAE_i),
        .y_o(SrcAEAdelantada)
    );
    
    mux2 #(32) ALUSrcA(
        .d0_i(SrcAEAdelantada),
        .d1_i(32'b0),
        .s_i(ALUSrcAE_i),
        .y_o(SrcAE)
    );
    
    mux3 #(32) adelantaB(
        .d0_i(RD2E),
        .d1_i(ResultadoW),
        .d2_i(ALUResultM_o),
        .s_i(ForwardBE_i),
        .y_o(WriteDataE)
    );
    
    mux3 #(32) ALUSrcB(
        .d0_i(WriteDataE),
        .d1_i(ImmExtE),
        .d2_i(PCTargetE),
        .s_i(ALUSrcBE_i),
        .y_o(SrcBE)
    );
    
    alu alu( //checkear si no funciona viteh
        .dato1_i(SrcAE),
        .dato2_i(SrcBE),
        .alucontrol_i(ALUControl_i),
        .aluout_o(ALUResult),
        .zero_o(zero_o),
        .signo_o(signo_o)
    );
    
    adder dir_branch(
        .a_i(PCE),
        .b_i(ImmExtE),
        .y_o(PCTargetE)
    );
    
    controlador_flush_bp controlador_flush_bp(
        .prediccion_actual_i(prediccionE),
        .taken_i(branch_taken_i),
        .flush_predictor_o(flush_predictor)
    );         
    
    //-------------------------------------EX/MEM-------------------------------------
    registro_EX_MEM registro_EX_MEM(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .alu_i(ALUResult),
        .writedatae_i(WriteDataE), 
        .rde_i(RdE_o),        
        .pcplus4e_i(PCPlus4E),   
         //Salidas    
        .aluresultm_o(ALUResultM_o), 
        .writedatam_o(WriteDataM_o), 
        .rdm_o(RdM_o),        
        .pcplus4m_o(PCPlus4M)    
    );
    
    //-------------------------------------MEM/WB-------------------------------------
    registro_MEM_WB registro_MEM_WB(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .rd_i(dataIn_i),         
        .aluresultm_i(ALUResultM_o), 
        .rdm_i(RdM_o),        
        .pcplus4m_i(PCPlus4M),   
         //salidas        
        .readdataw_o(ReadDataW),  
        .aluresultw_o(ALUResultW), 
        .rdw_o(RdW_o),        
        .pcplus4w_o(PCPlus4W)    
    );
    
    //-------------------------------------WriteBack-------------------------------------
    mux3 #(32) MUXResultado(
        .d0_i(ALUResultW),
        .d1_i(ReadDataW),
        .d2_i(PCPlus4W),
        .s_i(ResultSrcW_i),
        .y_o(ResultadoW)
    );
    
    assign ResultadoW_o = ResultadoW;
    assign dirRegfile_o = RdW_o;
    assign bp_activo_o = selbpE;
    assign prediccion = prediccionF;
    assign flush_pred_o = flush_predictor;
endmodule
