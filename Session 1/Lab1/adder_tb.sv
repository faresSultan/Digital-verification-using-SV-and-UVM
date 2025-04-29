module TB ();

logic signed [3:0] A,B ;
reg clk, reset;

logic signed [4:0] C;

localparam MAXPOS = 7, ZERO = 0, MAXNEG = -8 ;

integer Error_Count, Correct_Count;

adder a1 (.*); //if same signals name

initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    Error_Count = 0;
    Correct_Count = 0;
    A = 1;  // to ensure 1
    B = 1;

    //ADDER_1
    assert_reset;

    // ADDER_2
    A = MAXNEG;B = MAXNEG;
    check_result(-16);
   
    // ADDER_3
    A = MAXNEG;B = 0;
    check_result(-8);
   
    // ADDER_4
    A = MAXNEG;B = MAXPOS;
    check_result(-1);
   
    // ADDER_5
    A = MAXNEG;B = MAXPOS;
    check_result(-1);
   
    // ADDER_6
    A = 0;B = MAXPOS;
    check_result(7);
   
    // ADDER_7
    A = MAXPOS;B = MAXPOS;
    check_result(14);
   
    // ADDER_8
    A = MAXPOS;B = 0;
    check_result(7);
   
    // ADDER_9
    A = 0;B = 0;
    check_result(0);
   
    // ADDER_10
    A = MAXNEG;B = 0;
    check_result(-8);

    reset = 1;
    check_result(0);

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

task check_result(logic signed [4:0] expected_value);

    @(negedge clk);

    if (A + B == expected_value) begin
        $display("Passed for excpected output: %0d",expected_value);
        Correct_Count++;
    end
    else begin 
        $display("Failed for excpected output: %0d",expected_value);
         Error_Count++;
    end
endtask //


    
endmodule