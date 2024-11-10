`timescale 1ns / 1ps

module mux2 #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] d0_i, d1_i,
    input  logic             s_i,
    output logic [WIDTH-1:0] y_o
    );
    
    always @*
    case (s_i)
      1'b0: y_o = d0_i;
      1'b1: y_o = d1_i;
      default: y_o = 1'b0; // Default value if none of the above cases match
    endcase
endmodule
