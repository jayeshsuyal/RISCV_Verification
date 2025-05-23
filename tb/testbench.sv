`timescale 1ns/1ps
module top;

  // Clock and Reset
  logic clk;
  logic reset;

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk; // 100 MHz clock

  // Reset generation
  initial begin
    reset = 1;
    #20;
    reset = 0;
  end

  // Interface instantiation
  ss_if vif(clk, reset);

  // DUT instantiation (replace DUT_MODULE with actual module name)
  DUT_MODULE dut (
    .clk        (vif.clk),
    .reset      (vif.reset),
    .mem_valid  (vif.mem_valid),
    .mem_addr   (vif.mem_addr),
    .mem_wdata  (vif.mem_wdata),
    .mem_wstrb  (vif.mem_wstrb),
    .mem_rdata  (vif.mem_rdata),
    .mem_ready  (vif.mem_ready),
    .uart_tx    (vif.uart_tx),
    .uart_rx    (vif.uart_rx)
  );

  // UVM testbench setup
  initial begin
    // Set the interface for all components using config_db
    uvm_config_db#(virtual ss_if)::set(null, "*", "vif", vif);

    // Run the test
    run_test("ss_test"); // Replace with your test name
  end

endmodule
