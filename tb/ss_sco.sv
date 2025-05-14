`ifndef SS_SCO_SV
`define SS_SCO_SV

class ss_sco extends uvm_scoreboard;
`uvm_compoement_utils(ss_sco);

    virtual function new(input string name = "ss_sco", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    uvm_analysis_imp#(ss_tx, ss_scoreboard) recv; ;

    bit [31:0] mem_model [*]; //associative arry
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);        
        recv = new("this",recv);
    endfunction: build_phase

    virtual function void write (ss_tx tr);
        case(tr.op)
            WRITE, BURST, MIXED_RD: begin
                mem_model[mem_addr]== mem_wdata;
                `uvm_info("SCO", $sformatf("operation type: %s, address: %0h, data: %0h",tr.op.name(),tr.mem_addr, tr.mem_wdata));
            end

            READ: 
            if(mem_model[mem_addr] !== mem_rdata) begin
                `uvm_error("SCO:", $sformatf("Read mismatch ")); 
            end

        endcase
    endfunction: write
    

endclass

`endif