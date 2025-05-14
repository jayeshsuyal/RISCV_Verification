class burst_seq extends uvm_sequence#(ss_tx);
    `uvm_object_utils(burst_seq);
    
        function new(input string name = "burst_seq");
            super.new(name);
        endfunction   

        virtual task body();
            ss_tx tr;    
            tr = ss_tx::type_id::create("tr"); 

            for(int i = 0; i<5; i++) begin
            start_item(tr); 
            tr.mem_addr = 32'h0000_1000;
            tr.mem_wdata [i] = $urandom; 
            tr.mem_wstrb = 4'b1111;
            tr.mem_valid = 1'b1;           
            finish_item(tr);              
        end
        endtask    
endclass