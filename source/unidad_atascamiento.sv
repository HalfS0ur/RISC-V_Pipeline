`timescale 1ns / 1ps

module unidad_atascamiento(
    input logic  [4:0]   Rs1D, 
    input logic  [4:0]   Rs2D,
    input logic  [4:0]   RdE,
    input logic [4:0]    RdM_i,
    input logic [4:0]    RdW_i,
    input logic          desactivar_fw_i,
	input logic          ResultSrcE0, 
	input logic          PCSrcE,
	input logic          bp_activo_i,
	input logic          RegWriteE_i,
	input logic          RegWriteM_i,
	input logic          RegWriteW_i,
    output logic         StallD, 
    output logic         StallF, 
    output logic         FlushD, 
    output logic         FlushE
    );
					 
    logic lwStall;
    logic stall_fw_on = 0;
    logic check_exec = 0;
    logic check_mem = 0;
    logic check_wb = 0;
    
    always @(*) begin
        if (desactivar_fw_i == 0) begin
            stall_fw_on = (ResultSrcE0 == 1) & ((RdE == Rs1D) | (RdE == Rs2D));
            check_exec = 0;
            check_mem = 0;
            check_wb = 0;
        end
        
        else if (desactivar_fw_i == 1) begin
            check_exec = (RegWriteE_i == 1) & ((RdE == Rs1D) | (RdE == Rs2D));
            check_mem = (RegWriteM_i == 1) & ((RdM_i == Rs1D) | (RdM_i == Rs2D));
            check_wb = (RegWriteW_i == 1) & ((RdW_i == Rs1D) | (RdW_i == Rs2D));
            stall_fw_on = 0;
            //lwStall = check_exec | check_mem | check_wb;
        end
    end           
    //assign lwStall = (ResultSrcE0 == 1) & ((RdE == Rs1D) | (RdE == Rs2D)); 
    assign lwStall = stall_fw_on | check_exec | check_mem | check_wb;
               
	assign StallF = lwStall;
	assign StallD = lwStall;

//Esto viene todo junto en el H&H y como ocupa el lwStall me da cosita separarlo, se usa para los branches
	assign FlushE = lwStall | (PCSrcE & !bp_activo_i);
	assign FlushD = (PCSrcE & !bp_activo_i);

endmodule
