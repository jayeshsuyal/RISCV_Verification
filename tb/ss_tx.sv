`ifndef SS_TX_SV
`define SS_TX_SV

typedef enum {RESET, READ, WRITE, MIXED_RD, BURST, ERR, EDGE} oper_mode;

class ss_tx extends uvm_sequence_item; //Use uvm_sequence_item instead of uvm_transaction

    // Rand and non-rand variables
    rand bit [31:0] mem_addr; 
    rand bit [31:0] mem_wdata;
    rand bit [3:0]  mem_wstrb;
         bit [31:0] mem_rdata;
    rand bit        mem_valid;
    rand oper_mode  op;
         bit        mem_ready;

    // Constructor
    function new(string name = "mem_tx");
        super.new(name);
    endfunction

    // Registering fields with factory
    `uvm_object_utils_begin(mem_tx)
        `uvm_field_int(mem_valid,  UVM_ALL_ON)
        `uvm_field_int(mem_addr,   UVM_ALL_ON)
        `uvm_field_int(mem_wstrb,  UVM_ALL_ON)
        `uvm_field_int(mem_wdata,  UVM_ALL_ON)
        `uvm_field_int(mem_rdata,  UVM_ALL_ON)
        `uvm_field_int(mem_ready,  UVM_ALL_ON)
        `uvm_field_enum(oper_mode, op, UVM_ALL_ON)
    `uvm_object_utils_end

    // Constraints
    constraint addr_range_c {
        mem_addr inside {[32'h0000_0000 : 32'hFFFF_FFFF]};
    }

    constraint write_data_c {        
        mem_wdata inside {[32'h0000_0000 : 32'hFFFF_FFFF]};
    }

    constraint write_strobe_c {
        mem_wstrb dist {
            4'b0001 := 25,
            4'b0010 := 25,
            4'b0100 := 25,
            4'b1000 := 25
        };
    }

    constraint valid_c {
        mem_valid dist {1'b1 := 50, 1'b0 := 50;};
    }

endclass

`endif // SS_TX_SV
