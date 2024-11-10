`timescale 1ns / 1ps

module registro_EX_MEM(
    input  logic        clk_i,
    input  logic        reset_i, 
    //input  logic        enable_i,
    
    input  logic [31:0] alu_i,
    input  logic [31:0] writedatae_i,
    input  logic [4:0]  rde_i,
    input  logic [31:0] pcplus4e_i,
    
    output logic [31:0] aluresultm_o,
    output logic [31:0] writedatam_o,
    output logic [4:0]  rdm_o,
    output logic [31:0] pcplus4m_o             
    );
                       
    always_ff @(posedge clk_i) begin  
        if (reset_i) begin      
            aluresultm_o <= 0;
            writedatam_o <= 0;
            rdm_o        <= 0;
            pcplus4m_o   <= 0;         
        end
        
        else begin        //else if (enable_i) begin You already know      
            aluresultm_o <= alu_i;
            writedatam_o <= writedatae_i;
            rdm_o        <= rde_i;
            pcplus4m_o   <= pcplus4e_i; 
        end
    end                     
endmodule
