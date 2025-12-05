`timescale 1ns / 1ps

module dwc_cmd0_tb ();

localparam unsigned INPUT_DATA_WIDTH = 32;
localparam unsigned OUTPUT_DATA_WIDTH = 128;
localparam unsigned CMD_WORD_NUMBER  = OUTPUT_DATA_WIDTH / INPUT_DATA_WIDTH;

logic clk;
logic rst_n;

logic fifo_cmd_valid;
logic fifo_cmd_ready;
logic [INPUT_DATA_WIDTH-1:0] fifo_cmd_wdata;

logic dwc_cmd_valid;
logic dwc_cmd_ready;
logic [OUTPUT_DATA_WIDTH-1:0] dwc_cmd_wdata;


dwc_cmd0 # (
    .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
    .OUTPUT_DATA_WIDTH(OUTPUT_DATA_WIDTH),
    .CMD_WORD_NUMBER(CMD_WORD_NUMBER)
) U1 (
    .clk(clk),
    .rst_n(rst_n),
    .fifo_cmd_valid(fifo_cmd_valid),
    .fifo_cmd_ready(fifo_cmd_ready),
    .fifo_cmd_wdata(fifo_cmd_wdata),
    .dwc_cmd_valid(dwc_cmd_valid),
    .dwc_cmd_ready(dwc_cmd_ready),
    .dwc_cmd_wdata(dwc_cmd_wdata)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("dwc_cmd0_tb.vcd");
    $dumpvars(0, dwc_cmd0_tb);

    //reset
    rst_n = 0;
    fifo_cmd_valid = 0;
    fifo_cmd_wdata = 0;
    dwc_cmd_ready = 0; 
    #20;
    rst_n = 1;
    #20;


    //data1
    fifo_cmd_valid = 1;
    dwc_cmd_ready = 0; 
    fifo_cmd_wdata = 32'hAAAAAAAA;
    #20;

    //fifo_cmd_valid = 0
    fifo_cmd_valid = 0;
    dwc_cmd_ready = 0; 
    fifo_cmd_wdata = 32'h00000000;
    #20;

    //data1
    fifo_cmd_valid = 1;
    dwc_cmd_ready = 0; 
    fifo_cmd_wdata = 32'hBBBBBBBB;
    #20;

    //fifo_cmd_valid = 0
    fifo_cmd_valid = 0;
    dwc_cmd_ready = 0; 
    fifo_cmd_wdata = 32'h00000000;
    #20;

    //data1
    fifo_cmd_valid = 1;
    dwc_cmd_ready = 0; 
    fifo_cmd_wdata = 32'hCCCCCCCC;
    #20;
    
    //data1
    fifo_cmd_valid = 1;
    dwc_cmd_ready = 0; 
    fifo_cmd_wdata = 32'hDDDDDDDD;
    #20;

    
    fifo_cmd_valid = 0; 
    fifo_cmd_wdata = 32'h00000000;
    #20; 
    dwc_cmd_ready = 1;
    #20; 
    dwc_cmd_ready = 0;



    $display("Simulation complete!");
    #100;
    $finish;
end
endmodule
