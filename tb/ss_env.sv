// ENVIRONMENT CLASS
`ifndef SS_ENV_SV
`define SS_ENV_SV

class ss_env extends uvm_env;
  `uvm_component_utils(ss_env)

  ss_agent agent;
  ss_sco   sco;
  ss_cov   cov;

  function new(string name = "ss_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = ss_agent::type_id::create("agent", this);
    sco   = ss_sco::type_id::create("sco", this);
    cov   = ss_cov::type_id::create("cov", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    agent.monitor.send.connect(sco.recv);
    agent.monitor.send.connect(cov.analysis_export);
  endfunction

endclass

`endif
