////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package shift_reg_test_pkg;
import shift_reg_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"


class shift_reg_test extends uvm_test;
  // Example 1
  // Do the essentials (factory register & Constructor)
    `uvm_component_utils(shift_reg_test)

      shift_reg_env env;
      shift_reg_config_class SREG_config;

      function new(string name = "shift_reg_test",uvm_component parent = null);
        super.new(name,parent);
      endfunction
  // Build the enviornment in the build phase
      function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        env = shift_reg_env::type_id::create("env",this);
        SREG_config = shift_reg_config_class::type_id::create("shift_cfg");

        if(!uvm_config_db#(shift_reg_config_class)::set(this,"*","CFG",SREG_config))
          `uvm_fetal("build_phase","Test - Unable to get the virtual interface");

        uvm_config_db#(shift_reg_config_class)::set(this,"*","CFG",SREG_config); 
      endfunction

  // Run in the test in the run phase, raise objection, add #100 delay then display a message using `uvm_info, then drop the objection
      task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        #100; 
        `uvm_info("run_phase","Welcome",UVM_NONE)
        phase.drop_objection(this);
      endtask :run_phase

  // Example 2
  // Build the config object in the build phase
  // get the virtual interface and assign it to the virtual interface of the config object
  // set the config obj in the config db
endclass: shift_reg_test
endpackage