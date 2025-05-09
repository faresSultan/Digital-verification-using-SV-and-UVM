package alsu_coverage_collector_pkg;
    import uvm_pkg::*;
    import alsu_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class alsu_coverage_collector extends uvm_component;
        `uvm_component_utils(alsu_coverage_collector)

        parameter MAXPOS = 3 ;
        parameter MAXNEG = -4;

        uvm_analysis_export #(alsu_seq_item) cov_a_export;
        uvm_tlm_analysis_fifo #(alsu_seq_item) cov_fifo;
        alsu_seq_item cov_seq_item;

        
        covergroup CovCode ;

        //=============== A coverage points ======================
           A_cp: coverpoint cov_seq_item.A iff(!cov_seq_item.rst){
            bins A_data_0 = {0};     
            bins A_data_max = {cov_seq_item.MAXPOS};
            bins A_data_min = {cov_seq_item.MAXNEG};
            bins A_data_default = default;
           }

           A_WalkingOnes_cp: coverpoint unsigned'(cov_seq_item.A) iff(!cov_seq_item.rst && cov_seq_item.red_op_A){
            bins A_data_walkingones001 = {3'b001};
            bins A_data_walkingones010 = {3'b010};
            bins A_data_walkingones100 = {3'b100};
           }

        //=============== B coverage points ======================

           B_cp: coverpoint cov_seq_item.B iff(!(cov_seq_item.rst || cov_seq_item.bypass_A)){ //*
            bins B_data_0 = {0};
            bins B_data_max = {cov_seq_item.MAXPOS};
            bins B_data_min = {cov_seq_item.MAXNEG};
            bins B_data_default = default;
           }

           B_WalkingOnes_cp: coverpoint unsigned'(cov_seq_item.B) iff(!(cov_seq_item.rst || cov_seq_item.bypass_A) && cov_seq_item.red_op_B && !cov_seq_item.red_op_A){ 
            bins B_data_walkingones001 = {3'b001};
            bins B_data_walkingones010 = {3'b010};
            bins B_data_walkingones100 = {3'b100};

           }

        //=============== Opcode coverage points ====================== 

            ALU_cp: coverpoint cov_seq_item.opcode iff(!(cov_seq_item.rst || cov_seq_item.bypass_A || cov_seq_item.bypass_B)){

                bins Bins_shift[] = {SHIFT,ROTATE};
                bins Bins_arith[] = {ADD,MULT};
                bins Bins_bitwise[] = {OR,XOR};
                illegal_bins Bins_invalid = {INVALID_6,INVALID_7};
                bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
            }

        //=========== reduction operation coverage point ==============

            red_op_A_cp: coverpoint cov_seq_item.red_op_A{
                bins red_op_A_bins = {1};
            }

            red_op_B_cp: coverpoint cov_seq_item.red_op_B{
                bins red_op_B_bins = {1};
            }


        //======================Cross coverpoints======================

            //1. add/mult cross A_cp and B_cp

            addMultCrossAB: cross ALU_cp, A_cp,B_cp{
                //option.cross_auto_bin_max = 0; 
                ignore_bins notArth = !binsof(ALU_cp.Bins_arith);
            }

            //2. add cross cin

            addCrossCin: cross ALU_cp, cov_seq_item.cin iff(cov_seq_item.opcode == ADD){
               //option.cross_auto_bin_max = 0;
               ignore_bins notADD = !binsof(ALU_cp.Bins_arith) intersect{ADD};
               ignore_bins notADD2 = !binsof(ALU_cp.Bins_arith);
            }

            //3. shift/rotate cross direction

            shiftRotateCrossDir: cross ALU_cp, cov_seq_item.direction {

                ignore_bins notShiftRotate = ! binsof(ALU_cp.Bins_shift);
            }

            //4. shift cross shift_in

            shiftCrossShiftin: cross ALU_cp, cov_seq_item.serial_in iff(cov_seq_item.opcode == SHIFT){

                ignore_bins notShiftBins = !binsof(ALU_cp.Bins_shift) intersect{SHIFT};
                ignore_bins notShift = !binsof(ALU_cp.Bins_shift);
            }

            //5. OR/XOR and redA cross (A=> walking ones, B=> 0) 

            BinsBitwiseCrossWalkingA: cross ALU_cp, B_cp, A_WalkingOnes_cp iff(cov_seq_item.red_op_A){

                ignore_bins notBitwise = !binsof(ALU_cp.Bins_bitwise);
                ignore_bins BnotZero = !binsof(B_cp.B_data_0);

            }

            //6. OR/XOR and (!redA && redopB) cross (B=> walking ones, A=> 0) 

            BinsBitwiseCrossWalkingB: cross ALU_cp, A_cp, B_WalkingOnes_cp iff((!cov_seq_item.red_op_A && cov_seq_item.red_op_B)){

                ignore_bins notBitwise = !binsof(ALU_cp.Bins_bitwise);
                ignore_bins BnotZero = !binsof(A_cp.A_data_0);

            }

            //7. reduction operation while opcode != OR/XOR

            Bins_invalid_reduction: cross ALU_cp ,  red_op_A_cp,red_op_B_cp {

                ignore_bins valid_A_reduction = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_A_cp.red_op_A_bins);
                ignore_bins valid_B_reduction = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_B_cp.red_op_B_bins);
                ignore_bins transition_cp = binsof(ALU_cp.Bins_trans) ;
            } 

        endgroup  


        function new(string name = "alsu_coverage_collector", uvm_component parent = null);
            super.new(name,parent);
            CovCode = new(); 
        endfunction


        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            cov_a_export = new("cov_a_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            cov_a_export.connect(cov_fifo.analysis_export);          
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                cov_fifo.get(cov_seq_item);
                CovCode.sample();
            end           
        endtask

    endclass

    
endpackage