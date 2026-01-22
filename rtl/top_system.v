`timescale 1ns / 1ps

module top_system (
    input  wire aclk,
    input  wire aresetn,
    input  wire start_txn,   // The "Go" Button
    output wire txn_done,    // Success LED
    output wire txn_error    // Error LED
);
   //Write Address Channel (AW)
    wire [3:0]  awaddr;
    wire        awvalid;
    wire        awready;

    // Write Data Channel (W)
    wire [31:0] wdata;
    wire [3:0]  wstrb;
    wire        wvalid;
    wire        wready;

    // Write Response Channel (B)
    wire [1:0]  bresp;
    wire        bvalid;
    wire        bready;

    //Read Address Channel (AR)
    wire [3:0]  araddr;
    wire        arvalid;
    wire        arready;

    // Read Data Channel (R)
    wire [31:0] rdata;
    wire [1:0]  rresp;
    wire        rvalid;
    wire        rready;

    axi_lite_master u_master (
        // Global Signals
        .aclk           (aclk),
        .aresetn        (aresetn),
        
        // Control Signals 
        .INT_AXI_TXN    (start_txn),  
        .txn_done       (txn_done),
        .txn_error      (txn_error),

        // Test Inputs 
        .tgt_addr       (4'h8),       // Always write to Address 5
        .tgt_data       (32'hFFFFFFFF), // Always write Data DEADBEEF

        // AXI Connections (Connected to Internal Wires)
        .awaddr(awaddr), .awvalid(awvalid), .awready(awready),
        .wdata(wdata),   .wstrb(wstrb),   .wvalid(wvalid),   .wready(wready),
        .bresp(bresp),   .bvalid(bvalid), .bready(bready),
        .araddr(araddr), .arvalid(arvalid), .arready(arready),
        .rdata(rdata),   .rresp(rresp),   .rvalid(rvalid),   .rready(rready)
    );

    axi_lite_slave u_slave (
        // Global Signals
        .aclk           (aclk),
        .aresetn        (aresetn),

        // AXI Connections
        .awaddr(awaddr), .awvalid(awvalid), .awready(awready),
        .wdata(wdata),   .wstrb(wstrb),   .wvalid(wvalid),   .wready(wready),
        .bresp(bresp),   .bvalid(bvalid), .bready(bready),
        .araddr(araddr), .arvalid(arvalid), .arready(arready),
        .rdata(rdata),   .rresp(rresp),   .rvalid(rvalid),   .rready(rready)
    );

endmodule