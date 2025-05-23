`ifndef SS_COV_SV
`define SS_COV_SV

class ss_cov extends uvm_subscriber#(ss_tx);
    `uvm_component_utils(ss_cov)

    //coverage group.
    covergroup risc_cov;
        coverpoint tr.op; // cover enum operation

        coverpoint tr.mem_valid{
            bins valid = {1'b1};
            bins not_valid = {1'b0};
        }

        coverpoint tr.mem_wstrb{
            bins w0 = {4'b0001};
            bins w1 = {4'b0010};
            bins w2 = {4'b0100};
            bins w3 = {4'b1000};
        }

        coverpoint tr.mem_addr{
            bins low_range = {[32'h0000_0000:32'h0000_0FFF]};
            bins mid_range = {[32'h1000_0000: 32'h1FFF_FFFF]};
            bins high_range = {[32'hFFFF_0000:32'hFFFF_FFFF]};
        }

        cross op_valid_x = tr.op,tr.mem_valid;
        cross op_strobe_x = tr.op, tr.mem_wstrb;
    endgroup 


    function new (string name = "ss_cov", uvm_component parent = null);
        super.new(name, parent);
        mem_cov = new();
    endfunction

    virtual function void(ss_tx t);
        tr = t;
        mem_cov.sample();
    endfunction

endclass : ss_cov
`endif