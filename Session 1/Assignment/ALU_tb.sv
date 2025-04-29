module ALU_tb ();

logic signed [3:0] A,B ;
logic clk, reset;
logic [1:0] Opcode;
logic signed [4:0] C;

localparam MAXPOS = 7, MAXNEG = -8 ;
localparam 		    Add	           = 2'b00; // A + B
localparam 		    Sub	           = 2'b01; // A - B
localparam 		    Not_A	       = 2'b10; // ~A
localparam 		    ReductionOR_B  = 2'b11; // |B

integer Error_Count, Correct_Count;

ALU_4_bit DUT (.*);

initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    Error_Count = 0;
    Correct_Count = 0;
    A = 1;  
    B = 1;
    Opcode = Add;

//ALU1
    assert_reset;

// ALU2
    A = MAXNEG;B = MAXNEG; Opcode = Add; 
    check_Add_result(-16);
    Opcode = Sub;
    check_Sub_result(0);
   
    A = MAXNEG;B = 0; Opcode = Add;
    check_Add_result(-8);
    Opcode = Sub;
    check_Sub_result(-8);
   
    A = MAXNEG;B = MAXPOS; Opcode = Add;
    check_Add_result(-1);
    Opcode = Sub;
    check_Sub_result(-15);
   
    A = 0;B = MAXPOS; Opcode = Add;
    check_Add_result(7);
    Opcode = Sub;
    check_Sub_result(-7);

    A = MAXPOS;B = MAXPOS; Opcode = Add;
    check_Add_result(14);
    Opcode = Sub;
    check_Sub_result(0);
   
    A = MAXPOS;B = 0; Opcode = Add;
    check_Add_result(7);
    Opcode = Sub;
    check_Sub_result(7);

    A = 0;B = 0; Opcode = Add;
    check_Add_result(0);
    Opcode = Sub;
    check_Sub_result(0);

    A = MAXNEG;B = 0;Opcode = Add;
    check_Add_result(-8);
    Opcode = Sub;
    check_Sub_result(-8);

//ALU3
    Opcode = Not_A;
    repeat(10) begin
        A = $random;
        check_Ainvert_result;
    end

//ALU4
    Opcode = ReductionOR_B;
    repeat(10) begin
        B = $random;
        check_RedOR_B_result;
    end

//ALU5
    
    A = 6; B = -3;
    Opcode = Add; check_Add_result(3);
    Opcode = Sub; check_Sub_result(9);
    Opcode = Not_A; check_Ainvert_result;
    Opcode = ReductionOR_B; check_RedOR_B_result;


assert_reset; // to complete toggle coverage

    $display("Error Count = %0d\n",Error_Count);
    $display("Correct Count = %0d\n",Correct_Count);

    $stop;
end


task assert_reset ;

    reset = 1;
    @(negedge clk);
    if (C != 'b0)
     begin
      $display("Reset failed");
      Error_Count++;   
    end
    else begin
     $display("Reset Passed");
     Correct_Count++;
    end
    reset = 0;
    
endtask //

task check_Add_result(logic signed [4:0] expected_value);

    @(negedge clk);

    if (A + B == expected_value) begin
        $display("Passed Adding for A = %0d, B = %0d excpected output: %0d",A,B,expected_value);
        Correct_Count++;
    end
    else begin 
        $display("Failed Adding for A = %0d, B = %0d excpected output: %0d",A,B,expected_value);
         Error_Count++;
    end
endtask 

task check_Sub_result(logic signed [4:0] expected_value);

    @(negedge clk);

    if (A - B == expected_value) begin
        $display("Passed Subtracting for A = %0d, B = %0d excpected output: %0d",A,B,expected_value);
        Correct_Count++;
    end
    else begin 
        $display("Failed Subtracting for A = %0d, B = %0d excpected output: %0d",A,B,expected_value);
         Error_Count++;
    end
endtask 

task check_Ainvert_result;

    @(negedge clk);

    if (C == ~A) begin
        $display("Passed Op1 Inverting for A = %0b,output: %0b",A,C);
        Correct_Count++;
    end
    else begin 
        $display("Failed Op1 Inverting for A = %0b,output: %0b",A,C);
         Error_Count++;
    end
endtask 

task check_RedOR_B_result;

    @(negedge clk);

    if (C == |B) begin
        $display("Passed Op2 Reduction OR for B = %0b,output: %0b",B,C);
        Correct_Count++;
    end
    else begin 
        $display("Failed Op2 Reduction OR for B = %0b,output: %0b",B,C);
         Error_Count++;
    end
endtask 
    
endmodule