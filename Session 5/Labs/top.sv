////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_test_pkg::*;

module top();
  // Example 1
  // Clock generation
  bit clk;

  // Instantiate the interface and DUT
  initial begin
    clk = 0;
    forever begin
      #1 clk = ~clk;
    end
  end

  shift_reg_if SregIf (clk);

  shift_reg DUT (clk, SregIf.reset, SregIf.serial_in, SregIf.direction, SregIf.mode, SregIf.datain, SregIf.dataout);
  // run test using run_test task

  initial begin
    uvm_config_db#(virtual shift_reg_if)::set(null,"uvm_test_top","SREG_IF",SregIf);
    run_test("shift_reg_test");
  end

  // Example 2
  // Set the virtual interface for the uvm test
endmodule