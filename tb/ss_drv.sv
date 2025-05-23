class ss_drv extends uvm_driver; // this is drv file we are using.
    `uvm_component_utils(ss_drv);

    ss_tx tr;
    virtual ss_if s=vif;

    function new(input string name = "ss_drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void buil_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual ss_if)::get(this,"", vif, null))
        `uvm_error("DRV:", "Failed to get access of the interface from config db")
        tr = ss_tx::type_id:: create("tr",)
    endfunction


    virtual task reset();
        `uvm_info("DRV:","Reset Initiated", UVM_MEDIUM);
        vif.reset <= 1'b1; //active high reset
        vif.mem_addr <= 32'h0000_0000;
        vif.mem_wdata <= 32'h0000_0000;
        vif.mem_wstrb <= 4'b0000;
        vif.mem_valid <= 1'b0;
        wait(!vif.reset)
        repeat(2)@(posedge vif.clk); 
        `uvm_info("DRV:","Reset complete", UVM_MEDIUM);
    endtask 


    virtual task write_task();
        `uvm_info("DRV:","Write task is being executed", UVM_MEDIUM);
        vif.mem_wdata <= tr.mem_wdata;
        vif.mem_addr <= tr.mem_addr;
        vif.mem_valid <=1'b1;
        vif.mem_wstrb <= tr.mem_wstrb;
        wait(vif.mem_ready);
        @(posedge vif.clk);
        vif.mem_valid <= 1'b0;
        vif.mem_wstrb <= 4'b0000;
    endtask 
    
    virtual task read_task();
        `uvm_info("DRV:","Write task is being executed", UVM_MEDIUM);
        vif.mem_addr <= tr.mem_addr;
        vif.mem_valid <= 1'b1;
        vif.mem_wstrb <= 4'b0000; // read condition for storbe. 
        wait(vif.mem_ready);
        @(posedge vif.clk);
        vif.mem_rdata <= tr.mem_rdata;
        vif.mem_valid<= 1'b1;
    endtask 

    virtual task burst_task();
        `uvm_info("DRV:","Burst task is being executed", UVM_MEDIUM);
        for(int i =0; i<5;i++) begin 
           vif.mem_addr <= tr.mem_addr + (i*4);
           vif.mem_wdata<= tr.mem_wdata[i];//randomizing data for each beat
           vif.mem_wstrb <= tr.mem_wstrb;
           vif.mem_valid <= tr.mem_valid; 
           wait(vif.mem_ready);  
           @(posedge vif.clk);          
            end
        vif.mem_valid <= 1'b0;
        vif.mem_wstrb <= 4'b0000;
        @(posedge vif.clk);        
    endtask 

    virtual task err_task();
        `uvm_info("DRV:","ERR task is being executed", UVM_MEDIUM);    
        vif.mem_valid <= 1'b1;
        vif.mem_addr <= tr.mem_addr;
        vif.mem_wdata <= tr.mem_wdata;
        vif.mem_wstrb <= tr.mem_wstrb;
        wait(vif.mem_ready);
        @(posedge vif.clk);        
        vif.mem_valid <= 1'b0;
        vif.mem_wstrb <= 4'b0000;
    endtask

    virtual task edge_task();
        `uvm_info("DRV:","Edge task is being executed", UVM_MEDIUM);
        vif.mem_valid <= 1'b1;
        vif.mem_addr <= tr.mem_addr;
        vif.mem_wdata <= tr.mem_wdata;
        vif.mem_wstrb <= 4'b1111;
        wait(vif.mem_ready);
        @(posedge vif.clk);        
        vif.mem_valid <= 1'b0;
        vif.mem_wstrb <= 4'b0000;
    endtask 
        virtual task mixed_rd();
        `uvm_info("DRV:","ERR task is being executed", UVM_MEDIUM);
            //write operation first
            vif.mem_valid <= 1'b1;
            vif.mem_addr <= tr.mem_addr;
            vif.mem_wdata <= tr.mem_addr; 
            vif.wstrb <= tr.wstrb;
            wait(vif.mem_ready);
            @(posedge vif.clk);       
            vif.mem_valid <= 1'b0;
            vif.wstrb <= 4'b0000;
            @(posedge vif.clk);

            //read operation
            vif.mem_valid <= 1'b1; 
            vif.mem_addr <= tr.mem_addr; 
            wait(vif.mem_ready); 
            @(posedge vif.clk);=
            vif.mem_valid <= 1'b0;
            @(posedge vif.clk);
        endtask 

        virtual task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin 
                seq_item_port.get_next_item_(tr);
                `uvm_info("DRV:", $sformatf("OPCODE: %0d",tr.opcode), UVM_NONE);
                
                RESET: task reset();
                READ: task read_task();
                WRITE: task write_task();
                MIXED_RD: task mixed_rd();
                BURST: task burst_task();
                ERR: task err_task();
                EDGE: task edge_task();

                seq_item_port.item_done();
            end
        endtask
endclass