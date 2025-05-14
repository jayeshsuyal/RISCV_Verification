`ifndef SS_MON_SV
`define SS_MON_SV

class ss_mon extends uvm_monitor;
`uvm_component_utils(ss_mon);
 
    virtual interface ss_if vif;
    uvm_analysis_port #(ss_tx) send;
    ss_tx tr;

    virtual function new(input string path = "ss_mon", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        (!uvm_config_db#(virtual ss_if)::get(this, "", "vif", vif)) begin
        `uvm_error("MON:","Couldn't access the interface");
    end
    send = new("send",this);
    endfunction


    virtual task run_phase(uvm_phase phase);
        forever begin 
            @(posedge vif.clk);            
            //reset
            if(vif.reset) begin 
                tr = ss_tx::type_id:: create("tr",this);
                tr.op = RESET;
                `uvm_info("MON:","RESET DETECTED", UVM_NONE);
                send.write(tr);
            end

            //write
            else if (vif.mem_valid && vif.mem_ready && vif.mem_wstrb != 4'b0000) begin
                tr = ss_tx::type_id:: create("tr",this);
                tr.mem_addr = vif.mem_addr;
                tr.mem_wdata= vif.mem_wdata;
                tr.mem_wstrb = vif.mem_wstrb;
                tr.mem_valid = 1'b1;
                tr.mem_ready  = 1'b1;
                tr.op = WRITE;
                `uvm_info("MON:",$sformatf("Write tx: addr = %0h, wdata = %0h",tr.mem_addr,tr.mem_wdata), UVM_LOW);
                send.write(tr);
            end

            //read
            else if (vif.mem_valid && vif.mem_ready && vif.mem_wstrb = 4'b0000) begin
                tr = ss_tx::type_id:: create("tr",this);
                tr.mem_addr = vif.mem_addr;
                tr.mem_rdata= vif.mem_rdata;
                tr.mem_valid = 1'b1;
                tr.mem_ready  = 1'b1;
                tr.op = READ;
                `uvm_info("MON:",$sformatf("READ tx: addr = %0h, wdata = %0h",tr.mem_addr,tr.mem_rdata), UVM_LOW);
                send.write(tr);
            end

            //EDGE
            else if (vif.mem_valid && vif.mem_ready && (vif.mem_wstrb = 4'b0000||vif.mem_wstrb = 4'bFFFF)) begin
                tr = ss_tx::type_id:: create("tr",this);
                tr.mem_addr = vif.mem_addr;
                tr.mem_valid = 1'b1;
                tr.mem_ready  = 1'b1;
                tr.op = EDGE;
                if(vif.mem_wstrb != 4'b0000)
                    tr.mem_wdata = vif.mem_wdata;
                else 
                    tr.mem_rdata = vif.mem_rdata;

                `uvm_info("MON:",$sformatf("READ tx: addr = %0h, wdata = %0h",tr.mem_addr,(vif.mem_wstrb ! = 0)? vif.mem_wdata: vif.mem_rdata), UVM_LOW);                
                send.write(tr);
            end

            //err
            else if (vif.mem_valid && vif.mem_ready && (^vif.mem_wdata === 1'bx)) begin
                tr = ss_tx::type_id:: create("tr",this);
                tr.mem_addr = vif.mem_addr;
                tr.mem_wdata = vif.mem_wdata;
                tr.mem_valid = 1'b1;
                tr.mem_ready  = 1'b1;
                tr.op = ERR;

                `uvm_info("MON:",$sformatf("READ tx: addr = %0h, wdata = %0h",tr.mem_addr, mem_wdata), UVM_LOW);                
                send.write(tr);
            end


            // Detect BURST write
            else if (vif.mem_valid && vif.mem_ready) begin
                static bit [31:0] last_addr = 0;
                static int burst_count = 0;

                if (burst_count == 0 || vif.mem_addr == (last_addr + 4)) begin
                    tr = ss_tx::type_id::create("tr", this);
                    tr.mem_addr  = vif.mem_addr;
                    tr.mem_wdata = vif.mem_wdata;
                    tr.mem_valid = 1'b1;
                    tr.mem_ready = 1'b1;
                    tr.op        = BURST;

                    `uvm_info("MON:", $sformatf("BURST Tx[%0d]: Addr=%0h, Data=%0h", 
                                burst_count, tr.mem_addr, tr.mem_wdata), UVM_LOW);
                    send.write(tr);
                    
                    last_addr   = vif.mem_addr;
                    burst_count++;
                end else begin
                    burst_count = 0; // Reset if address not sequential
                end
            end

            // Detect MIXED_RD (Write followed by Read)
            else if (vif.mem_valid && vif.mem_ready) begin
                tr = ss_tx::type_id::create("tr", this);
                tr.mem_addr  = vif.mem_addr;
                tr.mem_wdata = vif.mem_wdata;
                tr.mem_valid = 1'b1;
                tr.mem_ready = 1'b1;
                tr.op        = MIXED_RD; // Context-dependent

                `uvm_info("MON:", $sformatf("MIXED_RD Write Tx: Addr=%0h, Data=%0h",
                            tr.mem_addr, tr.mem_wdata), UVM_LOW);

                send.write(tr);
            end else if (vif.mem_ready && !vif.mem_valid) begin
                tr = ss_tx::type_id::create("tr", this);
                tr.mem_addr  = vif.mem_addr;
                tr.mem_rdata = vif.mem_rdata;
                tr.mem_ready = 1'b1;
                tr.op        = MIXED_RD;

                `uvm_info("MON:", $sformatf("MIXED_RD Read Tx: Addr=%0h, Data=%0h",
                            tr.mem_addr, tr.mem_rdata), UVM_LOW);

                send.write(tr);
            end
        end
    endtask 
endclass
`endif // SS_MON_SV