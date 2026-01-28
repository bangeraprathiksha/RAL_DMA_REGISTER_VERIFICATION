// Code your testbench here
// or browse Examples
`include "design.v"
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ral_pkg.sv"
import ral_pkg::*;

`include "intf.sv"

module tb_top;   // �~\~E unique testbench name

  bit clk;
  bit rst_n;

  intf vif (clk);

 dma_design dut (       // �~\~E now this resolves to your design.v DUT
    .clk   (clk),
    .rst_n (rst_n),
    .wr_en (vif.wr_en),
    .rd_en (vif.rd_en),
    .wdata (vif.wdata),
    .addr  (vif.addr),
    .rdata (vif.rdata)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end

  initial begin
    uvm_config_db#(virtual intf)::set(null, "*", "vif", vif);
    //run_test("reset_check_test");
    //run_test("intr_test");
    //run_test("ctrl_test");
    //run_test("io_addr_test");
    //run_test("mem_addr_test");
    //run_test("extra_info_test");
    //run_test("status_test");
    //run_test("transfer_count_test");
    //run_test("descriptor_addr_test");
    //run_test("error_status_test");
    //run_test("config_test");
    run_test("regression_test");
  end

endmodule
