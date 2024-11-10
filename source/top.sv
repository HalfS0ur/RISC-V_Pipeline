`timescale 1ns / 1ps

module top(
    input logic clk_i,
    input logic reset_i,
    input logic desactivar_bp_i,
    input logic desactivar_fw_i,
    
    output logic [31:0] WriteDataM_o,
    output logic [31:0] ResultadoW_o,
    output logic [4:0] dirRegfile_o,
    output logic [31:0] dirPrograma_o,
    output logic [31:0] Instruccion_In,
    output logic Stall_o,
    output logic test_control,
    output logic branch_predictor_activo,
    output logic [1:0] prediccion_o,
    output logic flush_o
    );
    
    logic [31:0] ProgIn, direccion_datos, data_out, datoRAM, ProgAddress;
    logic we_RAM;
    
    RISCV_Pipeline RISCV_Core(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .ProgIn(ProgIn),
        .DataIn_i(datoRAM),
        .desactivar_bp_i(desactivar_bp_i),
        .desactivar_fw_i(desactivar_fw_i),
        //Salidas
        .PCF_o(ProgAddress),
        .ALUResultM_o(direccion_datos), //Va a la RAM
        .WriteDataM_o(data_out), //Va a la RAM
        .MemWriteM_o(we_RAM), //Va a la RAM
        .ResultadoW_o(ResultadoW_o),
        .dirRegfile_o(dirRegfile_o),
        .Stall_o(Stall_o),
        .test_control(test_control),
        .branch_predictor_activo(branch_predictor_activo),
        .prediccion_o(prediccion_o),
        .flush_o(flush_o)
    );
    
    ROM imem (
        .a(ProgAddress >> 2),      // input wire [9 : 0] a
        .spo(ProgIn)  // output wire [31 : 0] spo
    );
    
    RAM dmem (
        .a(direccion_datos),      // input wire [9 : 0] a
        .d(data_out),      // input wire [31 : 0] d
        .clk(clk_i),  // input wire clk
        .we(we_RAM),    // input wire we
        .spo(datoRAM)  // output wire [31 : 0] spo
    );
    
    assign WriteDataM_o = data_out;
    assign dirPrograma_o = ProgAddress >> 2;
    assign Instruccion_In = ProgIn;

endmodule
