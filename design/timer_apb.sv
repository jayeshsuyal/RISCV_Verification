module timer_apb (
    input wire clk,
    input wire resetn,
    input wire psel,
    input wire [7:0] paddr,
    input wire penable,
    input wire pwrite,
    input wire [31:0] pwdata,
    output wire [31:0] prdata,
    output wire pready
);

reg [31:0] timer_data;
assign prdata = timer_data;
assign pready = 1'b1;

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        timer_data <= 32'b0;
    end else if (psel && penable) begin
        if (pwrite) begin
            // Write Timer data
            timer_data <= pwdata;
        end else begin
            // Read Timer data
            timer_data <= timer_data + 1;  // Increment timer as an example
        end
    end
end

endmodule
