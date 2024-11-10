`timescale 1ns / 1ps

module control_ID_EX(
    input  logic       clk_i,
    input  logic       reset_i,
    input  logic       flush_i, 

    input  logic       regwrited_i,
    input  logic [1:0] resultsrcd_i,
    input  logic       memwrited_i,
    input  logic       jumpd_i,
    input  logic       branchd_i,
    input  logic [2:0] alucontrold_i,
    input  logic       alusrcad_i,
    input  logic [1:0] alusrcbd_i,
    input logic [2:0] func3D_i, //Meter abajo
    
    output logic       regwritee_o,
    output logic [1:0] resultsrce_o,
    output logic       memwritee_o,
    output logic       jumpe_o,
    output logic       branche_o,
    output logic [2:0] alucontrole_o,
    output logic       alusrcead_o,
    output logic [1:0] alusrcbd_o,
    output logic [2:0] func3E_o
    );
                    
always_ff @(posedge clk_i) begin
    if (reset_i) begin        
        regwritee_o   <= 0;
        resultsrce_o  <= 0;
        memwritee_o   <= 0;
        jumpe_o       <= 0;
        branche_o      <= 0;
        alucontrole_o <= 0;
        alusrcead_o     <= 0;
        alusrcbd_o     <= 0;
        func3E_o       <= 0;  
    end
    
    else if (flush_i) begin
        regwritee_o   <= 0;
        resultsrce_o  <= 0;
        memwritee_o   <= 0;
        jumpe_o       <= 0;
        branche_o      <= 0;
        alucontrole_o <= 0;
        alusrcead_o     <= 0;
        alusrcbd_o     <= 0;
        func3E_o    <= 0;
    end
        
    else begin                                  
        regwritee_o   <= regwrited_i;
        resultsrce_o  <= resultsrcd_i;
        memwritee_o   <= memwrited_i;
        jumpe_o       <= jumpd_i;
        branche_o      <= branchd_i;
        alucontrole_o <= alucontrold_i;
        alusrcead_o     <= alusrcad_i;
        alusrcbd_o <=   alusrcbd_i;
        func3E_o <=  func3D_i;    
    end
end             
                    
endmodule
