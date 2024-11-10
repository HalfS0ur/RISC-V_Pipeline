`timescale 1ns / 1ps

module riscv_tb_primo();
    logic clk_i;               
    logic reset_i;   
    logic desactivar_bp_i;
    logic desactivar_fw_i;                              
    logic [31:0] WriteDataM_o;
    logic [31:0] ResultadoW_o;
    logic [4:0] dirRegfile_o;
    logic [31:0] dirPrograma_o;
    logic Fuente_PC;
    logic [1:0] prediccion_o;
    logic Stall_o;
    logic branch_predictor_activo;
    logic flush_o;
    logic [31:0] Instruccion_In;
    
    int ciclos_de_reloj = 0;
    int instrucciones_ejecutadas = 0;
    real CPI = 0;
    int tiempo_inicio = 0;
    int tiempo_final = 0;
    int tiempo_total = 0;
    
    top dut(
    .clk_i(clk_i),
    .reset_i(reset_i),
    .desactivar_bp_i(desactivar_bp_i),
    .desactivar_fw_i(desactivar_fw_i),
    .WriteDataM_o(WriteDataM_o),
    .ResultadoW_o(ResultadoW_o),
    .dirRegfile_o(dirRegfile_o),
    .dirPrograma_o(dirPrograma_o),
    .Instruccion_In(Instruccion_In),
    .Stall_o(Stall_o),
    .test_control(Fuente_PC),
    .branch_predictor_activo(branch_predictor_activo),
    .prediccion_o(prediccion_o),
    .flush_o(flush_o)
    );
    
    always #20 clk_i = !clk_i;
    
    initial begin
    clk_i = 1;
    reset_i = 1;
    desactivar_bp_i = 1;
    desactivar_fw_i = 1;
    #50;
    reset_i = 0;
    tiempo_inicio = $realtime;
    
    while ((Instruccion_In != 32'b0 && reset_i != 1) || (ResultadoW_o != 16'h1 && dirRegfile_o !== 32'h0A)) begin
            #40;
            ciclos_de_reloj = ciclos_de_reloj + 1;
            
            if (Instruccion_In != 32'b0 && Stall_o != 0 && desactivar_fw_i == 1) begin
                instrucciones_ejecutadas = instrucciones_ejecutadas + 1;
            end
            
            else if (Instruccion_In != 32'b0 && Stall_o == 0 && desactivar_fw_i == 0) begin
                instrucciones_ejecutadas = instrucciones_ejecutadas + 1;
            end
            
            else begin
                instrucciones_ejecutadas = instrucciones_ejecutadas;
            end
        end
        
    tiempo_final = $realtime;
    tiempo_total = (tiempo_final - tiempo_inicio);
        
    $display("Número de ciclos de reloj: %d", ciclos_de_reloj);
    $display("Número de instrucciones ejecutadas: %d", instrucciones_ejecutadas);
    $display("Tiempo de ejecución: %d", tiempo_total, "ns");
        
        // Calculate CPI with decimals
    if (instrucciones_ejecutadas > 0) begin
        CPI = real(ciclos_de_reloj) / real(instrucciones_ejecutadas);
    end
        
    $display("CPI: %.4f", CPI);  // Display CPI with 2 decimal places
    $finish;
    end 
endmodule
