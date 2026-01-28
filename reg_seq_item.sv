
class reg_seq_item extends uvm_sequence_item;
        `uvm_object_utils(reg_seq_item)

        bit rst_n;
        bit wr_en;
        bit rd_en;
        bit[31:0] wdata;
        bit[31:0] addr;
        bit[31:0] rdata;

        function new(string name = "reg_seq_item");
                super.new(name);
        endfunction
endclass
