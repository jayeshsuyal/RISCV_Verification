`ifndef RESET_SEQ_SV
`define RESET_SEQ_SV

class reset_seq extends uvm_sequence #(ss_tx);
    `uvm_object_utils(reset_seq)
  
    function new(string name = "reset_seq");
      super.new(name);
    endfunction
  
    virtual task body();
      ss_tx tr = ss_tx::type_id::create("tr");
      tr.opcode = ss_tx::RESET;      
      start_item(tr);
      finish_item(tr);
    endtask
  endclass

  `endif
