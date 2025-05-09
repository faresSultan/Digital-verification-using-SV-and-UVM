package alsu_scoreboard_pkg;
    import uvm_pkg::*;
    import alsu_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class alsu_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(alsu_scoreboard)

        uvm_analysis_export #(alsu_seq_item) sb_a_export;
        uvm_tlm_analysis_fifo #(alsu_seq_item) sb_fifo;
        alsu_seq_item sb_seq_item;

        function new(string name = "alsu_scoreboard", uvm_component parent = null);
            super.new(name,parent);
        endfunction


        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            sb_a_export = new("sb_a_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            sb_a_export.connect(sb_fifo.analysis_export);          
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                sb_fifo.get(sb_seq_item);
            end           
        endtask

    endclass

    
endpackage