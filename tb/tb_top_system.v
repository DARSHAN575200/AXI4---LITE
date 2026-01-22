`timescale 1ns / 1ps

module tb_top_system();

    reg aclk;
    reg aresetn;
    reg start_txn;
    
    // watch the LEDs
    wire txn_done;
    wire txn_error;

    //Instantiate the Motherboard 
    top_system uut (
        .aclk(aclk),
        .aresetn(aresetn),
        .start_txn(start_txn),
        .txn_done(txn_done),
        .txn_error(txn_error)
    );

    // Generate Clock (100MHz)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

    // Test Sequence
    initial begin
        aresetn = 0;
        start_txn = 0;
        
        #20;
        aresetn = 1;
        #20;

        //Press the "Start" Button
        $display("--- Starting System Transaction ---");
        start_txn = 1;
        #10;
        start_txn = 0;

        // Wait for the "Done" LED
        wait(txn_done == 1);
        $display("--- Transaction Complete! LED is ON ---");
        
        #50;
        $finish;
    end
    
    initial begin
        $dumpfile("system_wave.vcd");
        $dumpvars(0, tb_top_system);
    end

endmodule