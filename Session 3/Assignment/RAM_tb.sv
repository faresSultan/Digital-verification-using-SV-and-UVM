

typedef logic [8:0] word_t;

module RAM_tb();

    localparam TESTS = 100 ;

    int address_array[];
    logic[7:0] data_to_write_array[];
    word_t data_read_expect_assoc[int];
    word_t data_read_queue[$];

    bit clk,write,read;
    bit[7:0] data_in;
    bit[15:0] address;
    word_t data_out;
    int correct_count, error_count;

    my_mem DUT (.*);

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

//=============== Stimulus Generation ====================
    initial begin
        correct_count = 0; error_count = 0;
        address_array = new[TESTS];
        data_to_write_array = new[TESTS];
        stimulus_gen();
        golden_model();

        // store test vectors in the memory (write operation)
        write = 1;
        for (int i = 0; i<TESTS ;i++ ) begin  
            address = address_array[i];
            data_in = data_to_write_array[i];
            @(negedge clk); 
        end

        // read test vectors from the memory (read operation)
        write = 0;
        read = 1;
        for (int i=0; i<TESTS; i++) begin
            address = address_array[i];
            check9bits(i);            
        end
        ReportResults();
    end



//====================== Tasks ==========================

    task  stimulus_gen();
        
       for (int i = 0; i<TESTS ;i++) begin
            address_array[i] = $urandom_range(63999,0);
            data_to_write_array[i] = $random();
       end
    endtask

    task golden_model();
        
        for (int i = 0; i<TESTS ;i++) begin
            data_read_expect_assoc[address_array[i]] = {
                ~^(data_to_write_array[i]),data_to_write_array[i]};
       end     
    endtask

    task check9bits(int i);

        @(negedge clk);
            if (data_out == data_read_expect_assoc[address_array[i]]) begin
                correct_count++;
                data_read_queue.push_back(data_out);
            end
            else begin
                error_count++;
                $display("Error at time =%0t: data_out = %0h, Expected: &0h",
                data_out,data_read_expect_assoc[address_array[i]]);
                $stop;
            end
    endtask

    task ReportResults();
        automatic int j =0;
        $display("=================Write Test==============");
        foreach (address_array[i]) begin
            $display("Address: 0x%0h -> Data: %0b",address_array[i],data_to_write_array[i]);
        end

        $display("=================Read Test==============");
        
        while (data_read_queue.size() != 0) begin
            $display("Address: 0x%0h -> Data: %0b",address_array[j++],
            data_read_queue.pop_front());
        end
        $display("Error count = %0d",error_count);
        $display("Correct count = %0d",correct_count);
        $stop;
    endtask    
endmodule