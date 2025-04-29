////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package shift_reg_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class shift_reg_env extends uvm_env;
  // Example 1
  // Do the essentials (factory register & Constructor)
      `uvm_component_utils(shift_reg_env)

      function new (string name = "shift_reg_env", uvm_component parent = null);

        super.new(name,parent);
        
      endfunction


  // Example 2
  // Build the driver in the build phase
endclass
endpackage