`ifndef SS_TEST_SV
`define SS_TEST_SV

class ss_test extends uvm_test;
  `uvm_component_utils(ss_test)

  ss_env env;

  function new(string name = "ss_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ss_env::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // Start your sequences
    ss_seq_base seq;
    seq = ss_seq_base::type_id::create("seq");
    seq.start(env.agent.sequencer);

    phase.drop_objection(this);
  endtask

endclass

`endif