class mixed_rd_seq extends uvm_sequence#(ss_tx);
`uvm_object_utils(mixed_rd_seq);

    function new(input string name\= "mixed_rd_seq");
        super.new(name);
    endfunction

    virtual task body();
        ss_tx tr;
        tr = ss_tx::type_id::create("tr");

        start_item(tr);
            if(!tr.randomize()) begin
                `uvm_error("mixed read/write", "Transaction failed")
                return;
            end
            tr.mem_valid = 1'b1; 
        finish_item(tr);   
    endtask 

endclass