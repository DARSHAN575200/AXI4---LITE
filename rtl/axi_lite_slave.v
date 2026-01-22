`timescale 1ns / 1ps
module axi_lite_slave (
    // Global Signals
    input  wire        aclk,
    input  wire        aresetn,

    // Write Address Channel (AW)
    input  wire [3:0]  awaddr,
    input  wire        awvalid,
    output reg         awready,

   
    // Write Data Channel (W)
    input  wire [31:0] wdata,
    input wire [3:0] wstrb,
    input wire wvalid,
      output reg wready,

    // Write Response Channel (B)
    output reg [1:0]   bresp,
    output reg         bvalid,
    input  wire        bready,
    // Read Address Channel (AR)
    input  wire [3:0]  araddr,
    input  wire        arvalid,
    output reg         arready,
    // Read Data Channel (R)
    output reg [31:0]  rdata,
    output reg [1:0]   rresp,
    output reg         rvalid,
    input  wire        rready
);
    reg[31:0] slv_reg0;
    reg[31:0] slv_reg1;
    reg[31:0] slv_reg2;
    reg[31:0] slv_reg3;

    reg[3:0] axi_araddr;
    reg[3:0] axi_awaddr;

    always @(posedge aclk ) begin
        //f the Reset button is pressed (Active Low), it forces your "Ready" signals to 0
        if(aresetn==0)begin
            awready<=0;
            wready<=0;
        end else begin
            if (awvalid && !awready) begin
                awready <= 1;
                axi_awaddr <= awaddr; 
            end else begin
                awready <= 0;
            end
            if (wvalid && !wready) begin
                wready <= 1;
            end else begin
                wready <= 0;
            end
        end
    end
// to store data

always @(posedge aclk ) begin
    if(aresetn==0) begin
        slv_reg0<=0;
        slv_reg1<=0;
        slv_reg2<=0;
        slv_reg3<=0;
    end else begin
       if (wvalid && wready) begin
            case (awaddr[3:2]) // Look at bits 2 and 3 of address Bits [3:2]: These are the Index. 
            //They tell us exactly which register (0, 1, 2, or 3) we are talking to.
            2'b00    :slv_reg0 <= wdata;
            2'b01    :slv_reg1 <= wdata;
            2'b10    :slv_reg2 <= wdata;
            2'b11    :slv_reg3 <= wdata;
                default: begin end
            endcase
        end
    end    
end

// confirmation
 always @(posedge aclk ) begin
    if (aresetn==0) begin
        bvalid <= 0;
        bresp <= 0;
    end else begin
        if (wvalid && wready && !bvalid) begin    
            bvalid <= 1;
            bresp <= 2'b00;
        end else if (bvalid && bready) begin
            bvalid <=0;
        end
    end
    
 end

 //read data
 always @(posedge aclk ) begin
    if (aresetn==0) begin
        arready <= 0;
        axi_araddr <=0;
    end else begin
        if ((arvalid==1) && (arready==0) ) begin
        arready <= 1;
        axi_araddr <= araddr;  
        end else begin
            arready <= 0;
        end
    
    end
 end
always @(posedge aclk ) begin
    if(aresetn==0) begin
        rvalid <= 0;
    end else begin
        if ((arready==0) && (arvalid==1)) begin
            rvalid <= 1;
            rresp <= 0;
            case (araddr[3:2])
              2'b00  :rdata <= slv_reg0;
              2'b01  :rdata <= slv_reg1;
              2'b10  :rdata <= slv_reg2;
              2'b11  :rdata <= slv_reg3;
                default: rdata <= 32'h0;
            endcase
        end else if(rvalid && rready) begin
            rvalid <= 0;
        end
    end
end
endmodule