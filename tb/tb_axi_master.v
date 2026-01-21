`timescale 1ns/1ps
module tb_axi_master ();
    reg aclk;
    reg aresetn;

    reg INT_AXI_TXN;
    reg[3:0] tgt_addr;
    reg[31:0] tgt_data;
    wire txn_done;
    wire txn_error;

    wire[3:0] awaddr;
    reg awready;
    wire awvalid;
    
    wire[31:0] wdata;
    wire[3:0] wstrb;
    wire wvalid;
    reg wready;

    reg[1:0] bresp;
    reg bvalid;
    wire bready;

    wire[3:0]  araddr;
    reg  arready;
    wire   arvalid;

    reg [31:0]  rdata;
    reg [1:0]   rresp;
    reg rvalid;
    wire  rready;

    axi_lite_master uut(
    .aclk(aclk),
    .aresetn(aresetn),

    .INT_AXI_TXN(INT_AXI_TXN),
    .tgt_addr(tgt_addr),
    .tgt_data(tgt_data),
    .txn_done(txn_done),
    .txn_error(txn_error),

    .awaddr(awaddr),
    .awready(awready),
    .awvalid(awvalid),
    
    .wdata(wdata),
    .wstrb(wstrb),
    .wvalid(wvalid),
    .wready(wready),

    .bresp(bresp),
    .bvalid(bvalid),
    .bready(bready),

    .araddr(araddr),
    .arready(arready),
    .arvalid(arvalid),

    .rdata(rdata),
    .rresp(rresp),
    .rvalid(rvalid),
    .rready(rready)

    );

    initial begin
        $dumpfile("axi_waveform_master.vcd"); 
        $dumpvars(0, tb_axi_master);   
    end

   initial begin
    aclk =0;
   end 
   always #5 aclk = ~aclk;

   initial begin
    aresetn=0;
    INT_AXI_TXN=0;
    awready=0;
    wready=0;
    bvalid=0;
    bresp = 2'b00;

    #20;

    aresetn=1;

    #20;

    // set targets
    tgt_addr= 4'b0101;
    tgt_data= 32'hFFFFFFFF;

    INT_AXI_TXN = 1;  
    #10;              
    INT_AXI_TXN = 0; 
    #100;
    $finish;
   end

// Fake Slave Logic 
always @(posedge aclk ) begin
    if(awvalid==1 && awready==0) begin
        awready <=1;
    end else awready <=0;

    if(wvalid==1 && wready==0)begin
        wready <=1;
    end else wready <=0;

    if(wready && wvalid)begin
        bvalid <=1;
    end
    if(bvalid && bready)begin
        bvalid <=0;
    end
    
end


    
endmodule