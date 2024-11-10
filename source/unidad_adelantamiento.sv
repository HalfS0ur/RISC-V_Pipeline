`timescale 1ns / 1ps

module unidad_adelantamiento(
    input logic  [4:0]   Rs1E, 
    input logic  [4:0]   Rs2E,
    input logic  [4:0]   RdM, 
    input logic  [4:0]   RdW,
    input logic          RegWriteM, 
    input logic          RegWriteW,
    input logic          desactivar_fw_i,
    output logic [1:0]   ForwardAE, 
    output logic [1:0]   ForwardBE
    );					 

always_comb 
    begin
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
        
        if (desactivar_fw_i == 1'b1) begin
            ForwardAE = 2'b00;
            ForwardBE = 2'b00;
        end
        
        else if (desactivar_fw_i == 1'b0) begin        
            if ((Rs1E == RdM) & (RegWriteM) & (Rs1E != 0)) begin 
                ForwardAE = 2'b10; 
            end
            
            else begin
                if ((Rs1E == RdW) & (RegWriteW) & (Rs1E != 0)) begin
                    ForwardAE = 2'b01; 
                    end
            end
                        
            if ((Rs2E == RdM) & (RegWriteM) & (Rs2E != 0)) begin
                ForwardBE = 2'b10;
            end
    
            else if ((Rs2E == RdW) & (RegWriteW) & (Rs2E != 0)) begin
                ForwardBE = 2'b01;  
            end
          end
      end

endmodule
