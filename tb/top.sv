`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ss_if.sv"
`include "ss_tx.sv"

module top;

    ss_if sif();

    initial begin 

        ss_tx tx;

        tx = ss_tx :: type_id:: create("tx");

        if(!tx.randomize())
        `uvm_fatal("Top", "Randomization failed");
        else
        `uvm_info("Top",$sformatf("mem_addr randomized to : %0h",tx.mem_addr),UVM_MED);

        $finish;

    end

endmodule