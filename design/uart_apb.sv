module uart_apb (
    input wire clk,
    input wire resetn,
    input wire psel,
    input wire [7:0] paddr,
    input wire penable,
    input wire pwrite,
    input wire [31:0] pwdata,
    output wire [31:0] prdata,
    output wire pready,
    output wire uart_tx,
    input wire uart_rx
);

reg [31:0] uart_data;
assign prdata = uart_data;
assign pready = 1'b1;

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        uart_data <= 32'b0;
    end else if (psel && penable) begin
        if (pwrite) begin
            // Write UART data
            uart_data <= pwdata;
        end else begin
            // Read UART data
            uart_data <= uart_rx;  // Simple read from UART
        end
    end
end

// UART transmission logic
assign uart_tx = uart_data[0];  // Transmit least significant bit as an example

endmodule
