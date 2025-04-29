package S2;
    
// lab1
class MemTrans;

logic [7:0] data_in;
logic [3:0] address;

        function new(logic [7:0] dataIN = 'h00,logic [3:0] addr = 'h0);
            this.data_in = dataIN;
            this.address = addr;
        endfunction //new()


        function void print_values ();

            $display("Value of data_in = 0x%0h", data_in);
            $display("Value of address = 0x%0h", address);
            
        endfunction
    endclass 



    class Constraint_Exercise1;

        rand logic [7:0] data;
        rand logic [3:0] address;

        constraint d{
            data == 'd5;
        }

        constraint a{
            address dist {
                4'd0 :/ 10,
                [1:14] :/ 80,
                4'd15 :/ 10 
            };
        }

        function void print_values ();

            $display("Value of data_in = 0x%0h", data);
            $display("Value of address = 0x%0h", address);
            
        endfunction

        
    endclass
endpackage