import S2::*;

// Lab1
// module MemTrans ();

// MemTrans Tarns1;
// MemTrans Tarns2;
//     initial begin
//          Tarns1 = new(.addr('h2));
//        Tarns2 = new(.addr('h4),.dataIN('h03));

//         Tarns1.print_values();
//         Tarns2.print_values();
//     end
// endmodule


//lab2
 module lab2 ();

    Constraint_Exercise1 C1 = new();
    logic [7:0] data;
    logic [3:0] address;
  
    initial begin
          
        repeat (20) begin
            assert(C1.randomize());

            data = C1.data;
            address = C1.address;
            
            C1.print_values();
        end
        $stop;
    end
    
 endmodule