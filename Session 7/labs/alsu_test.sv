`ifndef ALSU_TEST_PKG_SV
`define ALSU_TEST_PKG_SV

package alsu_test_pkg;
    import uvm_pkg::*;
    import alsu_env_pkg::*;
    import config_obj_pkg::*;
    import alsu_sequence_pkg::*;
    import alsu_seq_item_pkg::*;
    `include "uvm_macros.svh"
    
    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test)

        alsu_env env0;
        alsu_config alsu_config_obj_test;
        alsu_reset_sequence reset_seq;
        alsu_sequence_1 seq_1;
        alsu_sequence_2 seq_2;
        alsu_sequence_3 seq_3;
        alsu_sequence_4 seq_4;
        alsu_sequence_5 seq_5;


        function new(string name = "alsu_test",uvm_component parent = null);
            super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase); 
            alsu_config_obj_test = alsu_config::type_id::create("alsu_config_obj_test");
            alsu_config_obj_test.is_active = UVM_ACTIVE; // ACTIVE/PASSIVE

            if(!uvm_config_db #(virtual ALSU_if)::get(this,"","ALSU_IF",alsu_config_obj_test.alsu_config_if))
                `uvm_fatal("build_phase","Test - unable to get the virtual interface")
            uvm_config_db #(alsu_config)::set(this,"*","CFG", alsu_config_obj_test); 
            
            env0 = alsu_env::type_id::create("env0",this);
            reset_seq = alsu_reset_sequence::type_id::create("reset_seq");
            seq_1 = alsu_sequence_1::type_id::create("seq1");
            seq_2 = alsu_sequence_2::type_id::create("seq2");
            seq_3 = alsu_sequence_3::type_id::create("seq3");
            seq_4 = alsu_sequence_4::type_id::create("seq4");
            seq_5 = alsu_sequence_5::type_id::create("seq5");

            set_type_override_by_type(alsu_seq_item::get_type(),alsu_seq_item_disable_rst::get_type());

        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            phase.raise_objection(this);
            //=========Reset_sequence===========    
                `uvm_info("run_phase","Reset Asserted",UVM_MEDIUM)
                reset_seq.start(env0.agt.sqr);
            //=========Sequence_1===========
                `uvm_info("run_phase","Sequence-1 started",UVM_MEDIUM)
                seq_1.start(env0.agt.sqr);
            //=========Sequence_2===========
                `uvm_info("run_phase","Sequence-2 started",UVM_MEDIUM)
                seq_2.start(env0.agt.sqr);
            //=========Sequence_3===========
                `uvm_info("run_phase","Sequence-3 started",UVM_MEDIUM)
                seq_3.start(env0.agt.sqr);
            //=========Sequence_4===========
                `uvm_info("run_phase","Sequence-4 started",UVM_MEDIUM)
                seq_4.start(env0.agt.sqr);
            //=========Sequence_5===========
                `uvm_info("run_phase","Sequence-5 started",UVM_MEDIUM)
                seq_5.start(env0.agt.sqr);
            phase.drop_objection(this);
        endtask 
    endclass 
endpackage

`endif