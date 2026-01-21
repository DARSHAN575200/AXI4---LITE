`timescale 1ns / 1ps
module tb_axi_slave();
    reg aclk;
    reg aresetn;

    reg [3:0]  awaddr;
    reg       awvalid;
    wire         awready;

    reg[31:0] wdata;
    reg [3:0] wstrb;
    reg wvalid;
    wire wready;

    wire[1:0]   bresp;
    wire         bvalid;
    reg        bready;

    reg [3:0]  araddr;
    reg        arvalid;
    wire       arready;

    wire [31:0]  rdata;
    wire [1:0]   rresp;
    wire rvalid;
    reg        rready;

    axi_lite_slave uut (
        .aclk(aclk),
        .aresetn(aresetn),

        // Write Address
        .awaddr(awaddr),
        .awvalid(awvalid),
        .awready(awready),

        // Write Data
        .wdata(wdata),
        .wstrb(wstrb),
        .wvalid(wvalid),
        .wready(wready),

        // Write Response
        .bresp(bresp),
        .bvalid(bvalid),
        .bready(bready),

        // Read Address
        .araddr(araddr),
        .arvalid(arvalid),
        .arready(arready),

        // Read Data
        .rdata(rdata),
        .rresp(rresp),
        .rvalid(rvalid),
        .rready(rready)
    );

    initial begin
        $dumpfile("axi_wave_slave.vcd");  
        $dumpvars(0, tb_axi_slave);  
        aclk=0;
        forever #5 aclk=~aclk;
    end
task axi_write;
        input [3:0]  target_addr;
        input [31:0] target_data;
        begin
            awaddr <=target_addr;
            wdata <=target_data;
            wstrb <= 4'b1111;
            awvalid<=1;
            wvalid <=1;
            bready <=0;
            wait((awready && wready) ==1);
            @(posedge aclk); 
            awvalid <= 0;
            wvalid <= 0;   

            wait(bvalid==1);
            @(posedge aclk);
            bready <=1;
            @(posedge aclk);
            bready <=0;

        end
    endtask

    task axi_read;
        input [3:0] target_addr;
        begin
            araddr <= target_addr;
            arvalid <=1;

            wait(arready);
             @(posedge aclk);
            arvalid <=0;

            rready <=1;
            @(posedge aclk);
            wait(rvalid);
            @(posedge aclk);
            rready <=0;
        end
    endtask

    initial begin
        aresetn = 0;
        awvalid = 0;
        wvalid  = 0;
        bready  = 0;
        arvalid = 0;
        rready  = 0;

        #20 aresetn = 1;  
        // Test 1: Write CAFEBABE to Register 0
        $display("Writing CAFEBABE to Address 0...");
        axi_write(4'h0, 32'hCAFEBABE);

        // Test 2: Read from Register 0
        $display("Reading from Address 0...");
        axi_read(4'h0);
        if (rdata == 32'hCAFEBABE) 
            $display("SUCCESS: Read Data matches Written Data!");
        else 
            $display("ERROR: Read %h, expected CAFEBABE", rdata);
        #50;
        $finish;
    end
    
endmodule

