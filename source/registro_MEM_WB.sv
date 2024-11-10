`timescale 1ns / 1ps

module registro_MEM_WB(
    input  logic        clk_i,
    input  logic        reset_i,
    //input  logic        enable_i, ya se la saben mi gente, sigan viendo

    input  logic [31:0] rd_i,
    input  logic [31:0] aluresultm_i,
    input  logic [4:0]  rdm_i,
    input  logic [31:0] pcplus4m_i,
     
    output logic [31:0] readdataw_o,
    output logic [31:0] aluresultw_o,
    output logic [4:0]  rdw_o,
    output logic [31:0] pcplus4w_o
    );
                     
    always_ff @(posedge clk_i) begin   
        if(reset_i) begin       
            readdataw_o  <= 0;
            aluresultw_o <= 0;
            rdw_o        <= 0;
            pcplus4w_o   <= 0;   
        end
        
        else begin        //else if (enable_i) begin      
            readdataw_o  <= rd_i;
            aluresultw_o <= aluresultm_i;
            rdw_o        <= rdm_i;
            pcplus4w_o   <= pcplus4m_i;      
        end  
    end
endmodule
