`timescale 1ns / 1ps

module dwc_rsp0_tb ();

localparam unsigned INPUT_DATA_WIDTH = 128;
localparam unsigned OUTPUT_DATA_WIDTH = 32;
localparam unsigned RSP_WORD_NUMBER = INPUT_DATA_WIDTH / OUTPUT_DATA_WIDTH;

logic clk;
logic rst_n;

logic fifo_rsp_valid;
logic fifo_rsp_ready;
logic [INPUT_DATA_WIDTH-1:0] fifo_rsp_rdata;

logic id_rsp_valid;
logic id_rsp_ready;
logic [OUTPUT_DATA_WIDTH-1:0] id_rsp_rdata;

logic [1:0] state;

dwc_rsp0 # (
    .OUTPUT_DATA_WIDTH(OUTPUT_DATA_WIDTH),
    .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
    .RSP_WORD_NUMBER(RSP_WORD_NUMBER)
) U1 (
    .clk(clk),
    .rst_n(rst_n),
    .fifo_rsp_valid(fifo_rsp_valid),
    .fifo_rsp_ready(fifo_rsp_ready),
    .fifo_rsp_rdata(fifo_rsp_rdata),
    .id_rsp_valid(id_rsp_valid),
    .id_rsp_ready(id_rsp_ready),
    .id_rsp_rdata(id_rsp_rdata)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("dwc_rsp0_tb.vcd");
    $dumpvars(0, dwc_rsp0_tb);

    //reset
    rst_n = 0;
    fifo_rsp_valid = 0;
    fifo_rsp_rdata = 0;
    id_rsp_ready = 0; 
    #10;
    rst_n = 1;
    #10;

    //input data
    fifo_rsp_valid = 1;
    id_rsp_ready = 0; 
    fifo_rsp_rdata = 128'hDDDDDDDDCCCCCCCCBBBBBBBBAAAAAAAA;
    #10;
    fifo_rsp_valid = 0;
    id_rsp_ready = 0; 
    fifo_rsp_rdata = 128'h00000000000000000000000000000000;
    #10;

    // output data1 
    id_rsp_ready = 1;
    #10; 
    id_rsp_ready = 0; 
    #10;

    // output data2
    id_rsp_ready = 1;
    #10; 
    id_rsp_ready = 0; 
    #10;

    // output data3
    id_rsp_ready = 1;
    #10;
    id_rsp_ready = 0; 
    #10; 

    // output data4
    id_rsp_ready = 1;
    #10; 
    id_rsp_ready = 0; 

    #100;
    $finish;
end
endmodule

