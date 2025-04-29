module top();
    bit clk;

    always #1 clk = ~clk;

    counter_if countIF(clk);
    
    counter DUT(
        .clk(countIF.clk) ,.rst_n(countIF.rst_n), .load_n(countIF.load_n),
        .up_down(countIF.up_down), .ce(countIF.ce), .data_load(countIF.data_load), 
        .count_out(countIF.count_out), .max_count(countIF.max_count), .zero(countIF.zero)
    );

    counter_tb tb(countIF);

    bind counter counter_sva countSVA (
        countIF.clk,countIF.rst_n,countIF.load_n,
        countIF.up_down,countIF.ce,countIF.data_load,countIF.count_out,
        countIF.max_count,countIF.zero
    );
    
endmodule