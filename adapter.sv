class top_adapter extends uvm_reg_adapter;
        `uvm_object_utils(top_adapter)

        function new(string name = "top_adapter");
                super.new(name);
        endfunction

        function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
                reg_seq_item t;
                t = reg_seq_item::type_id::create("t");

                t.addr = rw.addr;

                t.wr_en = (rw.kind == UVM_WRITE);
                t.rd_en = (rw.kind == UVM_READ);

                if(t.wr_en == 1) t.wdata = rw.data;
                return t;
        endfunction

 
	function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);

  		reg_seq_item t;
  		if (!$cast(t, bus_item))
    			return;

  		rw.addr = t.addr;

  		if (t.wr_en) begin
    			rw.kind = UVM_WRITE;
    			rw.data = t.wdata;   
  		end
  		else if (t.rd_en) begin
    			rw.kind = UVM_READ;
    			rw.data = t.rdata;
  		end
  		else begin
    			return;
  		end

  		rw.status = UVM_IS_OK;
	endfunction

endclass
