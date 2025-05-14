class edge_seq extends uvm_sequence#(ss_tx);
    `uvm_object_utils(edge_seq);
    
        function new(input string name = "edge_seq");
            super.new(name);
        endfunction   

        virtual task body();
            ss_tx tr;    
            tr = ss_tx::type_id::create("tr"); 

            start_item(tr); 
                tr.mem_addr = 32'h0000_0000;
                tr.mem_wdata = 32'h0000_1010; 
                tr.mem_valid = 1'b1;           
            finish_item(tr);              

            start_item(tr);   
                tr.mem_addr = 32'hFFFF_FFFF;
                tr.mem_wdata = 32'hA5A5_A5A5;
                tr.mem_valid = 1'b1;
            finish_item(tr);
        endtask    
endclass



