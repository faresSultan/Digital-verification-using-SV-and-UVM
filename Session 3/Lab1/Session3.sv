import S3::*;


// //Lab1
// module Image_Generator();

//     Screen S1 = new();
    
  
//     initial begin
                                    
//             assert(S1.randomize());        
//             S1.Print();

//         $stop;
//     end
//endmodule


//Lab2

module alu_seq_tb ();

    byte operand1, operand2;
    logic clk, rst;
    opcode_e opcode;
    byte out;
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
        rst = 1; 
        @(negedge clk);
        rst = 0;
        

        repeat (32) begin
            assert(T1.randomize());
            @(negedge clk) begin
                operand1 = T1.oprand1;
                operand2 = T1.oprand2;
                opcode = T1.opcode;
            end
        end
        $stop;
   end


   endtask
    
endmodule