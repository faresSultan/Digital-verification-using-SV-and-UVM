package S3;

// Lab1
    
        parameter HEIGHT = 10 ;
        parameter WIDTH = 10 ;
        parameter PERCENT_WHITE = 20;
        typedef enum  { BLACK,WHITE } colors_t;

    class Screen;

        rand colors_t image [HEIGHT][WIDTH];

        constraint img_color {
            foreach (image[i,j]) {
                image[i][j] dist{
                    WHITE :/ PERCENT_WHITE,
                    BLACK :/ (100-PERCENT_WHITE)}; // ; is a must
            }
        }

        function void Print();
            
            foreach (image[i]) 
                $display("Row #%0d: %p",i,image[i]);
    
        endfunction
        
    endclass


    // Lab2

typedef enum {ADD,SUB,MULT,DIV } opcode_e;

class Transaction;
    rand opcode_e opcode;
    opcode_e prev_opcode = ADD;
    rand byte oprand1;
    rand byte oprand2;

    logic clk;

    covergroup CovCode @(posedge clk);

       opcode_cp: coverpoint opcode{
            bins opcode_cp1 = {ADD,SUB};
            bins opcode_cp2 =  (ADD=>SUB);
            illegal_bins opcode3 = {DIV};
        }

        oprand1CP: coverpoint oprand1{
            bins operand1_cp1 = {-128};
            bins operand1_cp2 = {127};
            bins operand1_cp3 = {0};
            bins others = default;
        }
    endgroup

    constraint opcode_constraints{
            opcode dist {  // To avoid illegal bin (DIV)
                DIV := 2,
                [ADD:MULT] := 98

            };

            if(prev_opcode == ADD) {  // to hit the the bin (opcode_cp2)
                opcode dist {
                    SUB := 50,
                    (MULT || DIV || ADD) :=50
                };
            }
        }

    constraint oprand1_constraints{
        oprand1 dist{
            0 := 33,
           -128 := 33,
            127 := 34
        };
    }
    function void post_randomize();
        prev_opcode = opcode;
    endfunction

    function new();
        CovCode = new();
    endfunction

endclass
    



endpackage