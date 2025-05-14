`ifndef SS_IF_SV
`define SS_IF_SV

interface ss_if (input logic clk, input logic reset);

    logic mem_valid;
    logic [31:0] mem_addr;
    logic [31:0] mem_wdata;
    logic [3:0] mem_wstrb;
    logic [31:0] mem_rdata;
    logic mem_ready;
    logic uart_tx;
    logic uart_rx;

    // Clocking block for driver or monitor
    clocking cb @(posedge clk);
        default input #1step output #1step;

        output mem_wdata;
        output mem_addr;
        output mem_wstrb;
        output mem_valid;

        input mem_ready;
        input mem_rdata;

        input uart_tx;
        output uart_rx;
    endclocking

endinterface: ss_if

`endif // SS_IF_SV
