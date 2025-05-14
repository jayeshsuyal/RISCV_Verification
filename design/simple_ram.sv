module simple_ram #(
    parameter ADDR_WIDTH = 16
)(
    input  wire        clk,
    input  wire        resetn,
    input  wire        valid,
    input  wire        instr,
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [31:0]  wdata,
    input  wire [3:0]   wstrb,
    output reg  [31:0]  rdata,
    output wire        ready
);

localparam DEPTH = 1 << ADDR_WIDTH;
reg [31:0] mem [0:DEPTH-1];

assign ready = valid;

always @(posedge clk) begin
    if (!resetn) begin
        rdata <= 32'b0;
    end
    else if (valid) begin
        if (|wstrb) begin
            if (wstrb[0]) mem[addr][7:0]   <= wdata[7:0];
            if (wstrb[1]) mem[addr][15:8]  <= wdata[15:8];
            if (wstrb[2]) mem[addr][23:16] <= wdata[23:16];
            if (wstrb[3]) mem[addr][31:24] <= wdata[31:24];
        end
        rdata <= mem[addr];
    end
end

endmodule
