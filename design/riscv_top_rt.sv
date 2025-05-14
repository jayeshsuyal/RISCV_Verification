module riscv_subsystem_top (
    input  wire        clk,
    input  wire        resetn,
    // UART Pins
    output wire        uart_tx,
    input  wire        uart_rx
);

// Signals between Core and Bus
wire        mem_valid;
wire        mem_instr;
wire [31:0] mem_addr;
wire [31:0] mem_wdata;
wire [3:0]  mem_wstrb;
wire [31:0] mem_rdata;
wire        mem_ready;

// APB Bus Signals
wire        apb_sel_uart, apb_sel_timer;
wire [31:0] apb_rdata_uart, apb_rdata_timer;
wire        apb_ready_uart, apb_ready_timer;

// Instantiate RAM
simple_ram #(
    .ADDR_WIDTH(16)
) ram (
    .clk(clk),
    .resetn(resetn),
    .valid(mem_valid && (mem_addr[31:28] == 4'h0)),
    .instr(mem_instr),
    .addr(mem_addr[15:0]),
    .wdata(mem_wdata),
    .wstrb(mem_wstrb),
    .rdata(mem_rdata),
    .ready(mem_ready)
);

// Instantiate PicoRV32 Core
picorv32_with_custom_alu #(
    .ENABLE_REGS_DUALPORT(1)
) core (
    .clk         (clk),
    .resetn      (resetn),
    .op_a        (mem_wdata),
    .op_b        (mem_rdata),
    .op_code     (mem_addr[3:0]),
    .result      (mem_rdata)
);

// Instantiate UART APB Peripheral
uart_apb uart (
    .clk    (clk),
    .resetn (resetn),
    .psel   (apb_sel_uart),
    .paddr  (mem_addr[7:0]),
    .penable(mem_valid),
    .pwrite (|mem_wstrb),
    .pwdata (mem_wdata),
    .prdata (apb_rdata_uart),
    .pready (apb_ready_uart),
    .uart_tx(uart_tx),
    .uart_rx(uart_rx)
);

// Instantiate Timer APB Peripheral
timer_apb timer (
    .clk    (clk),
    .resetn (resetn),
    .psel   (apb_sel_timer),
    .paddr  (mem_addr[7:0]),
    .penable(mem_valid),
    .pwrite (|mem_wstrb),
    .pwdata (mem_wdata),
    .prdata (apb_rdata_timer),
    .pready (apb_ready_timer)
);

// Simple APB Address Decoder
assign apb_sel_uart  = mem_valid && (mem_addr[31:20] == 12'h100);
assign apb_sel_timer = mem_valid && (mem_addr[31:20] == 12'h101);

// MUX Responses
assign mem_ready = mem_ready || apb_ready_uart || apb_ready_timer;
assign mem_rdata = (apb_ready_uart) ? apb_rdata_uart :
                   (apb_ready_timer) ? apb_rdata_timer : mem_rdata;

endmodule
