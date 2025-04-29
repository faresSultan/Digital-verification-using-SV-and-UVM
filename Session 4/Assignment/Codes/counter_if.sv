interface counter_if(input bit clk);
    input rst_n;
    input load_n;
    input up_down;
    input ce;
    input [3:0] data_load;
    output [3:0] count_out;
    output reg max_count;
    output zero;


    modport TEST(
        output logic rst_n,load_n,up_down,ce,data_load,
        input logic count_out,max_count,zero
        );

    modport DUT(
        input rst_n,load_n,up_down,ce,data_load,
        output count_out,max_count,zero
        );

endinterface