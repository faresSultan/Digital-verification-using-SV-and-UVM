`include "../Lab1/package.sv"
import S3::*;
module alu_seq_tb ();

    byte operand1, operand2;
    logic clk, rst;
    opcode_e opcode;
    byte out, out_exp;
    int Correct_Count,Error_Count;
    alu_seq DUT (.*);
    Transaction T1;

    initial begin
        clk = 0;
        T1 = new();
        forever begin
            T1.clk = clk;
            #1 clk = ~clk;
        end
   end

   initial begin

        Error_Count = 0; Correct_Count = 0;

        assert_rst;

        repeat (32) begin
            assert(T1.randomize());
                operand1 = T1.oprand1;
                operand2 = T1.oprand2;
                opcode = T1.opcode;
                GoldenModel;
                check_result;
        end
        assert_rst;
        $display("Correct Count = %0d",Correct_Count);
        $display("Error Count = %0d",Error_Count);
        $stop;
   end

   task assert_rst();
        operand1 = 'b1;
        operand2 = 'b1;
        opcode = ADD;
        rst = 1;
        @(negedge clk); 
        if(out == 0) begin
            $display("Reset Passed.");
            Correct_Count++;   
        end
        else begin
            $display("Reset Failed.");
            Error_Count++;
            $stop;
        end 
        rst = 0;
   endtask

   task GoldenModel();
        case(opcode) 
            ADD: out_exp = operand1 + operand2;
            SUB: out_exp = operand1 - operand2;
			MULT:out_exp = operand1 * operand2; 
        endcase
   endtask

   task check_result();
        @(negedge clk);

        if(out == out_exp) begin
            Correct_Count++;
        end
        else if(opcode != DIV) begin
            Error_Count++;
            $display("Failed for opcode =%0b, op1 =%0d, op2 =%0d, out =%0d -> Expected:%0d",
            opcode,operand1,operand2,out,out_exp);
        end  
   endtask     
endmodule