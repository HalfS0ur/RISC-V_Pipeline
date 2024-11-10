
module two_bit_predictor(
    input logic [1:0] old_prediction_i,   // Last Prediction
    input logic taken_i,                  // Branch taken?
    input logic desactivar_bp_i,
    output logic [1:0] new_prediction_o   // New Prediction
);

logic [1:0] new_state;

always @(*) begin
    if (desactivar_bp_i == 1) begin
        new_state = 2'b00;
    end
    
    else if (desactivar_bp_i == 0) begin
        case (old_prediction_i)
            2'b00: new_state = (taken_i) ? 2'b01 : 2'b00;
            2'b01: new_state = (taken_i) ? 2'b10 : 2'b00;
            2'b10: new_state = (taken_i) ? 2'b11 : 2'b01;
            2'b11: new_state = (taken_i) ? 2'b11 : 2'b10;
        endcase
    end
  end
  
assign new_prediction_o = new_state;
endmodule