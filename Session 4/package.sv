package S4;


typedef enum {ADD,SUB,MULT,DIV } opcode_e;

class Transaction;
    rand opcode_e opcode;
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

        oprandOpcode: cross opcode_cp,oprand1CP{
            bins MaxNeg = binsof(opcode_cp.opcode_cp1) && binsof(oprand1CP.opcode_cp1);
            bins MaxPos = binsof(opcode_cp.opcode_cp1) && binsof(oprand1CP.opcode_cp2);

            option.wait = 5;
            option.cross_auto_bin_max = 0;
        }

    endgroup

    function new();
        CovCode = new();
    endfunction

endclass
    



endpackage