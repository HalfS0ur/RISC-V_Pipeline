`timescale 1ns / 1ps

module controller(
    input logic clk_i,
    input logic reset_i,
    input logic flush_i,
    input logic [6:0] op_i,
    input logic [2:0] funct3_i,
    input logic funct7b5_i,
    input logic zero_i,
    input logic signo_i,
    
    output logic [2:0] immSrc_o,
    output logic ALUSrcAE_o,
    output logic [1:0] ALUSrcBE_o,
    output logic [2:0] ALUControlE_o,
    output logic PCSrcE_o,
    output logic PCJandL_o,
    output logic ResultSrcEb0_o,
    output logic MemWriteM_o,
    output logic RegWriteW_o,
    output logic [1:0] ResultSrcW_o,
    output logic RegWriteM_o,
    output logic branch_taken_o,
    output logic branch_predictor_we_o,
    output logic RegWriteE_o,
    
    output logic test
    );
    
    //Decodificador
    logic memWrite, branch, ALUSrcA, regWrite, jump;
    logic [1:0] resultSrc, ALUSrcB, ALUOp;
    logic [2:0] ALUControlD;
    
    //Decode-Execute
    logic memWriteE, branchE, regWriteE, jumpE;
    logic [1:0] resultSrcE;
    logic [2:0] func3E;
    
    //Execute-Memory
    logic [1:0] resultSrcM;
    
    //Señales internas
    logic compcero, compsigno, determina_branch, aiuda, complemento;
    
    decoder decodificador_instrucciones(
        .op_i(op_i),
        .resultSrc_o(resultSrc), 
        .memWrite_o(memWrite),        
        .branch_o(branch),          
        .ALUSrcA_o(ALUSrcA),         
        .ALUSrcB_o(ALUSrcB),   
        .regWrite_o(regWrite),        
        .jump_o(jump),            
        .immSrc_o(immSrc_o),    
        .ALUOp_o(ALUOp)      
    );
    
    aludec decodificador_alu( //revisar si fasha
        .opb5_i(op_i[5]),
        .funct3_i(funct3_i),
        .funct7b5_i(funct7b5_i),
        .ALUOp_i(ALUOp),
        .ALUControl_o(ALUControlD)
    );
    
    control_ID_EX registro_control_ID_EX(
        .clk_i(clk_i),        
        .reset_i(reset_i),      
        .flush_i(flush_i),                    
        .regwrited_i(regWrite),  
        .resultsrcd_i(resultSrc), 
        .memwrited_i(memWrite),  
        .jumpd_i(jump),      
        .branchd_i(branch),    
        .alucontrold_i(ALUControlD),
        .alusrcad_i(ALUSrcA),   
        .alusrcbd_i(ALUSrcB), 
        .func3D_i(funct3_i),    
        .regwritee_o(regWriteE),  
        .resultsrce_o(resultSrcE), 
        .memwritee_o(memWriteE),  
        .jumpe_o(jumpE),      
        .branche_o(branchE),    
        .alucontrole_o(ALUControlE_o),
        .alusrcead_o(ALUSrcAE_o),  
        .alusrcbd_o(ALUSrcBE_o),
        .func3E_o(func3E) //usar en el mux y complemento   
    );
    
    mux2 #(1) muxbranch(
        .d0_i(zero_i),
        .d1_i(signo_i),
        .s_i(func3E[2]),
        .y_o(aiuda)
    );
    
    assign complemento = aiuda ^ func3E[0];
           
    assign PCSrcE_o = ((complemento & branchE) | jumpE); //Revisar despues
    assign PCJandL_o = (op_i == 7'b1100111) ? 1 : 0; //jalr
    assign branch_taken_o = (complemento & branchE);
    assign branch_predictor_we_o = branchE;
    
    control_EX_MEM registro_control_EX_MEM(
        .clk_i(clk_i),       
        .reset_i(reset_i),                 
        .regwritee_i(regWriteE), 
        .resultsrce_i(resultSrcE),
        .memwritee_i(memWriteE), 
         //Salidas     
        .regwritem_o(RegWriteM_o), 
        .resultsrcm_o(resultSrcM),
        .memwritem_o(MemWriteM_o)  
    );
    
    assign ResultSrcEb0_o = resultSrcE[0];
    
    control_MEM_WB registro_control_MEM_WB(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .regwritem_i(RegWriteM_o),  
        .resultsrcm_i(resultSrcM), 
        //Salidas      
        .regwritew_o(RegWriteW_o),  
        .resultsrcw_o(ResultSrcW_o)  
    );
    
    assign test = PCSrcE_o;
    assign RegWriteE_o = regWriteE;
    
endmodule
