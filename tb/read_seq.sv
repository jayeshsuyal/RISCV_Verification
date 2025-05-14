class read_seq extends uvm_sequence#(ss_tx);
    `uvm_object_utils(read_seq);
    
        function new(input string name = "read_seq");
            super.new(name);
        endfunction   
        virtual task body();
            ss_tx tr;
    
            tr = ss_tx::type_id::create("tr"); 
            start_item(tr);   
            if(!tr.randomize()) begin
                `uvm_error("WRIE SEQ","Transaction randomization failed");
                    return;
                end      
            tr.mem_wstrb = 4'b0000;     
            tr.mem_valid = 1'b1;                           
            finish_item(tr);
        endtask
    endclass
    