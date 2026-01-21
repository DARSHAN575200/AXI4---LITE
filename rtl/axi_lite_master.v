`timescale 1ns/1ps
module  axi_lite_master (
    input wire aclk,
    input wire aresetn,

    input wire INT_AXI_TXN,
    input wire[3:0] tgt_addr,
    input wire[31:0] tgt_data,
    output reg txn_done,
    output reg txn_error,

    output reg[3:0] awaddr,
    input wire awready,
    output reg awvalid,
    
    output reg[31:0] wdata,
    output reg[3:0] wstrb,
    output reg wvalid,
    input wire wready,

    input wire[1:0] bresp,
    input wire bvalid,
    output reg bready,

    output reg[3:0]  araddr,
    input  wire  arready,
    output reg   arvalid,

    input wire [31:0]  rdata,
    input wire [1:0]   rresp,
    input wire rvalid,
    output reg  rready
);


localparam IDLE      = 2'b00;
localparam SEND_ADDR = 2'b01;
localparam SEND_DATA = 2'b10;
localparam WAIT_RESP = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;
reg error_reg;

always @(posedge aclk or negedge aresetn) begin
    if(aresetn==0)begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end  
always @(*) begin
    case (current_state)
    IDLE    : if (INT_AXI_TXN) begin
                            next_state=SEND_ADDR  ;      
                end else begin
                    next_state =IDLE;
                end
    SEND_ADDR : if(awready)begin
                    next_state=SEND_DATA;
                end else begin
                    next_state=SEND_ADDR;
                end
    SEND_DATA : if(wready)begin
                    next_state=WAIT_RESP;
                end else begin
                    next_state=SEND_DATA;
                end
    WAIT_RESP : if(bvalid)begin
                    next_state=IDLE;
                end else begin
                    next_state=WAIT_RESP;
                end

        default: next_state=IDLE;
    endcase
end  
always @(posedge aclk or negedge aresetn ) begin
    if(aresetn==0) begin
        awvalid <=0;
        wvalid <=0;
        bready <= 0;
        awaddr <= 0;
        wdata  <= 0;
        txn_done  <= 0;
        txn_error <= 0;
    end else begin
    if((current_state==IDLE) && (INT_AXI_TXN==1))begin
        awaddr <= tgt_addr;
        wdata <= tgt_data;
    end
    awvalid <= (next_state == SEND_ADDR);
    wstrb <= 4'b1111;
    wvalid  <= (next_state == SEND_DATA);
    bready  <= (next_state == WAIT_RESP);

    if (current_state == WAIT_RESP && bvalid == 1) begin
            txn_done <= 1;
            if (bresp != 2'b00) txn_error <= 1;
            else txn_error <= 0;
        end else begin
            txn_done <= 0;
            txn_error <= 0;
        end
end
end
endmodule