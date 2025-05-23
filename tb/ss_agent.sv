`ifndef SS_AGENT_SV
`define SS_AGENT_SV

class ss_agent extends uvm_agent;
  `uvm_component_utils(ss_agent)

  ss_sequencer sequencer;
  ss_drv       driver;
  ss_monitor   monitor;

  function new(string name = "ss_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (is_active == UVM_ACTIVE) begin
      sequencer = ss_sequencer::type_id::create("sequencer", this);
      driver    = ss_drv::type_id::create("driver", this);
    end

    monitor = ss_monitor::type_id::create("monitor", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

`endif