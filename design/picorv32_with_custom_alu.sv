module picorv32_with_custom_alu (
    input wire        clk,
    input wire        resetn,
    input wire [31:0] op_a,
    input wire [31:0] op_b,
    input wire [3:0]  op_code,
    output wire [31:0] result
);

wire [31:0] custom_alu_result;

// Instantiate the custom ALU
custom_alu custom_alu_inst (
    .operand_a(op_a),
    .operand_b(op_b),
    .op_code(op_code),
    .result(custom_alu_result)
);

// Logic to route to the custom ALU result based on the instruction type
assign result = custom_alu_result;

endmodule
