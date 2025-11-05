// ALU-style operation module

module vpu_op(
  parameter int DATA_W = 32,
  parameter int OP_W = 4
)(
  input logic start,
  input logic [DATA_W-1:0] operand0,
  input logic [DATA_W-1:0] operand1,
  input logic [OP_W-1:0] opcode,
  output logic [DATA_W-1:0] output
);

always_comb begin
  if(start) begin
    case(opcode)
    
    endcase
  end
end

endmodule