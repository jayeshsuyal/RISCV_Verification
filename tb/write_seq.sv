class write_seq extends uvm_sequence#(ss_tx);
`uvm_object_utils(write_seq);

    function new(input string name = "write_seq");
        super.new(name);
    endfunction   
    virtual task body();
        ss_tx tr;

        tr = ss_tx::type_id::create("tr");

        start_item(tr);         
        tr.mem_addr = 32'h0000_1000;
        tr.wdata = 32'hABCD_1234;
        tr.mem_wstrb = 4'b0001;     
        tr.mem_valid = 1'b1;               
        if(!tr.randomize()) begin
        `uvm_error("WRIE SEQ","Transaction randomization failed");
            return;
        end
        finish_item(tr);
    endtask
endclass
