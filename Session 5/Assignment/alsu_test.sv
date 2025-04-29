`ifndef ALSU_TEST_PKG_SV
`define ALSU_TEST_PKG_SV

package alsu_test_pkg;
    import uvm_pkg::*;
    import alsu_env_pkg::*;
    import config_obj_pkg::*;
    `include "uvm_macros.svh"
    
    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test)

        alsu_env env0;
        alsu_config alsu_config_obj_test;

        function new(string name = "alsu_test",uvm_component parent = null);
            super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase); 
            alsu_config_obj_test = alsu_config::type_id::create("alsu_config_obj_test"); 

            if(!uvm_config_db #(virtual ALSU_if)::get(this,"","ALSU_IF",alsu_config_obj_test.alsu_config_if))
                `uvm_fatal("build_phase","Test - unable to get the virtual interface")
            uvm_config_db #(alsu_config)::set(this,"*","CFG", alsu_config_obj_test); 
            
            env0 = alsu_env::type_id::create("env0",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            #100; `uvm_info("run_phase", "Inside the ALSU test",UVM_MEDIUM)

            phase.drop_objection(this);
        endtask 
    endclass 
endpackage

`endif