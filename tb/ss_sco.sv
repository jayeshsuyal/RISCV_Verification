`ifndef SS_SCO_SV
`define SS_SCO_SV

class ss_sco extends uvm_scoreboard;
  `uvm_component_utils(ss_sco)

  // Analysis port to receive transactions from monitor
  uvm_analysis_imp #(ss_tx, ss_sco) recv;

  typedef bit [31:0] addr_t;
  typedef bit [31:0] data_t;

  typedef struct packed {
    data_t data;
    bit    valid;
  } model_entry_t;

  model_entry_t mem_model [addr_t]; // associative array using addr as key

  function new(string name = "ss_sco", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
  endfunction

  // Write callback from monitor
  function void write(ss_tx tr);
    case (tr.op)
      WRITE, BURST, MIXED_RD: begin
        mem_model[tr.mem_addr].data  = tr.mem_wdata;
        mem_model[tr.mem_addr].valid = 1;
        `uvm_info("SCO", $sformatf("WRITE/UPDATE: Addr=0x%0h, Data=0x%0h, OP=%s",
                                    tr.mem_addr, tr.mem_wdata, tr.op.name()), UVM_MEDIUM);
      end

      READ: begin
        if (mem_model.exists(tr.mem_addr) && mem_model[tr.mem_addr].valid) begin
          if (mem_model[tr.mem_addr].data !== tr.mem_rdata) begin
            `uvm_error("SCO", $sformatf("READ MISMATCH at Addr=0x%0h. Expected=0x%0h, Got=0x%0h",
                        tr.mem_addr, mem_model[tr.mem_addr].data, tr.mem_rdata));
          end else begin
            `uvm_info("SCO", $sformatf("READ MATCH: Addr=0x%0h, Data=0x%0h",
                        tr.mem_addr, tr.mem_rdata), UVM_MEDIUM);
          end
        end else begin
          `uvm_warning("SCO", $sformatf("READ on uninitialized address: Addr=0x%0h", tr.mem_addr));
        end
      end

      EDGE: begin
        `uvm_info("SCO", $sformatf("EDGE CASE: Addr=0x%0h", tr.mem_addr), UVM_LOW);
      end

      ERR: begin
        if (tr.mem_wdata === 32'hx) begin
          `uvm_info("SCO", $sformatf("ERROR INJECTION DETECTED: Addr=0x%0h has X data", tr.mem_addr), UVM_MEDIUM);
        end else begin
          `uvm_warning("SCO", $sformatf("ERR TX but no Xs: Addr=0x%0h, Data=0x%0h", tr.mem_addr, tr.mem_wdata));
        end
      end

      RESET: begin
        `uvm_info("SCO", "RESET Operation detected. Flushing memory model.", UVM_LOW);
        mem_model.delete();
      end

      default: begin
        `uvm_warning("SCO", $sformatf("Unhandled operation: %s", tr.op.name()));
      end
    endcase
  endfunction

endclass : ss_sco

`endif
