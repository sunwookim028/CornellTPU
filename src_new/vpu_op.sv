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

localparam ADD = 4'd0;
localparam SUB = 4'd1;
localparam MULT_CONST = 4'd2;

logic [DATA_W-1:0] result;
always_comb begin
  if(start) begin
    case(opcode)
    ADD: begin
      result = operand0 + operand1;
    end
    SUB: begin
      result = operand0 - operand1;
    end
    MULT_CONST: begin
      result = operand0 * operand1;
    end
    default: result = '0;
    endcase
  end
end

assign output = result;

endmodule