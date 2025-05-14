class err_seq extends uvm_sequence#(ss_tx);
    `uvm_object_utils(err_seq);
    
        function new(input string name = "err_seq");
            super.new(name);
        endfunction   

        virtual task body();
            ss_tx tr;    
            tr = ss_tx::type_id::create("tr");        
            
            start_item(tr);   
                tr.mem_addr  = 32'h0000_0000;
                tr.mem_valid = 1'b0;   
                tr.mem_wstrb = 4'b1111;  
                tr.mem_wdata = 'hX;     
            finish_item(tr);

            start_item(tr);   
                tr.mem_addr  = 32'hFFFF_FFFF;  
                tr.mem_valid = 1'b1;   
                tr.mem_wstrb = 4'b0000;  
                tr.mem_wdata = 32'h0000_0000; 
            finish_item(tr);
        endtask   

endclass