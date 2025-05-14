module custom_alu (
    input [31:0] operand_a,
    input [31:0] operand_b,
    input [3:0]  op_code,   // Defines the operation (e.g., POPCOUNT, CLZ, ADD)
    output reg [31:0] result
);

always @(*) begin
    case (op_code)
        4'b0000: result = operand_a + operand_b;     // ADD
        4'b0001: result = operand_a - operand_b;     // SUB
        4'b0010: result = operand_a & operand_b;     // AND
        4'b0011: result = operand_a | operand_b;     // OR
        4'b0100: result = $popcount(operand_a);      // POPCOUNT (example)
        4'b0101: result = $clog2(operand_a);         // CLZ (example)
        default: result = 32'b0;                     // Default to 0
    endcase
end

endmodule
