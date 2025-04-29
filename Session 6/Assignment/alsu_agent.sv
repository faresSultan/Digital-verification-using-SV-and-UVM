package alsu_agent_pkg;

    import uvm_pkg::*;
    import alsu_driver_pkg::*;
    import alsu_sequencer_pkg::*;
    import alsu_monitor_pkg::*;
    import alsu_seq_item_pkg::*;

    import config_obj_pkg::*;
    `include "uvm_macros.svh"

    class alsu_agent extends uvm_agent;
        `uvm_component_utils(alsu_agent)
        alsu_driver driver;
        alsu_sequencer sqr;
        alsu_monitor mon;
        alsu_config alsu_config_obj;
        uvm_analysis_port #(alsu_seq_item) agt_a_port;

        function new(string name = "alsu_agent", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(alsu_config)::get(this,"","CFG",alsu_config_obj))
                `uvm_fatal("build_phase","Agent - unable to get the virtual interface")
            
            sqr = alsu_sequencer::type_id::create("sqr",this);
            driver = alsu_driver::type_id::create("driver",this);
            mon = alsu_monitor::type_id::create("mon",this);
            agt_a_port = new("agt_a_port",this);

        endfunction

        function void connect_phase(uvm_phase phase);
            driver.alsu_driver_vif = alsu_config_obj.alsu_config_if;
            mon.alsu_monitor_vif = alsu_config_obj.alsu_config_if;
            driver.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_a_port.connect(agt_a_port);
        endfunction
    endclass
endpackage