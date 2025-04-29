`ifndef ALSU_ENV_PKG_SV
`define ALSU_ENV_PKG_SV

package alsu_env_pkg;
    import uvm_pkg::*;
    import alsu_agent_pkg::*;
    import alsu_scoreboard_pkg::*;
    import alsu_coverage_collector_pkg::*;
    `include "uvm_macros.svh"
    
    class alsu_env extends uvm_env;
        `uvm_component_utils(alsu_env)

        alsu_agent agt;
        alsu_scoreboard sb;
        alsu_coverage_collector cov;

        function new(string name = "alsu_env",uvm_component parent = null);
            super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agt = alsu_agent::type_id::create("agt",this);
            sb = alsu_scoreboard::type_id::create("sb",this);
            cov = alsu_coverage_collector::type_id::create("cov",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_a_port.connect(sb.sb_a_export); 
            agt.agt_a_port.connect(cov.cov_a_export);  
        endfunction
    endclass 

endpackage


`endif