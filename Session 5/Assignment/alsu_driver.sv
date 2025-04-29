`ifndef ALSU_DRIVER_PKG_SV
`define ALSU_DRIVER_PKG_SV

package alsu_driver_pkg;
    import uvm_pkg::*;
    import config_obj_pkg::*;

    `include "uvm_macros.svh"
    
    class alsu_driver extends uvm_driver;
        `uvm_component_utils(alsu_driver)

        virtual ALSU_if alsu_driver_vif;
        alsu_config alsu_config_obj_driver;

        function new(string name = "alsu_driver",uvm_component parent = null);
            super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);  

            if(!uvm_config_db #(alsu_config)::get(this,"","CFG",alsu_config_obj_driver))
                `uvm_fatal("build_phase","Driver - unable to get the virtual interface")
            
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            alsu_driver_vif = alsu_config_obj_driver.alsu_config_if;
            
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            phase.raise_objection(this);

            alsu_driver_vif.rst = 1;
            @(negedge alsu_driver_vif.clk);
            alsu_driver_vif.rst = 0;

            repeat(10) begin
                alsu_driver_vif.cin =  $random();
                alsu_driver_vif.red_op_A = $random();
                alsu_driver_vif.red_op_B = $random();
                alsu_driver_vif.bypass_A = $random();
                alsu_driver_vif.bypass_B = $random();
                alsu_driver_vif.direction = $random(); 
                alsu_driver_vif.serial_in = $random(); 
                alsu_driver_vif.opcode = $random();
                alsu_driver_vif.A = $random();
                alsu_driver_vif.B = $random();
                @(negedge alsu_driver_vif.clk);
            end

            phase.drop_objection(this);
        endtask 
    endclass 
endpackage

`endif