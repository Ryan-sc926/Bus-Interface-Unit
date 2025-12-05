`timescale 1ps/1ps

module fifo_rsp0_tb ();

localparam unsigned FIFO_DEPTH = 8;
localparam unsigned INPUT_DATA_WIDTH = 128;
localparam unsigned OUTPUT_DATA_WIDTH = 128;

logic clk;
logic rst_n;

// co-processor interface
logic biu_rsp_valid;
logic biu_rsp_ready;
logic [INPUT_DATA_WIDTH-1:0] biu_rsp_rdata;

// processor interface
logic fifo_rsp_valid;
logic fifo_rsp_ready;
logic [OUTPUT_DATA_WIDTH-1:0] fifo_rsp_rdata;

fifo_rsp0 # (
    .FIFO_DEPTH(FIFO_DEPTH),
    .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
    .OUTPUT_DATA_WIDTH(OUTPUT_DATA_WIDTH)
) U1 (
    .clk(clk),
    .rst_n(rst_n),
    .biu_rsp_valid(biu_rsp_valid),
    .biu_rsp_ready(biu_rsp_ready),
    .biu_rsp_rdata(biu_rsp_rdata),
    .fifo_rsp_valid(fifo_rsp_valid),
    .fifo_rsp_ready(fifo_rsp_ready),
    .fifo_rsp_rdata(fifo_rsp_rdata)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin 
    $dumpfile("fifo_rsp0_tb.vcd");
    $dumpvars(0, fifo_rsp0_tb);

    rst_n = 0;
    biu_rsp_valid = 0;
    biu_rsp_rdata = 0;
    fifo_rsp_ready = 0;
    #10;

    rst_n = 1;
    #10;

    biu_rsp_valid = 1;
    biu_rsp_rdata = 128'h11111111111111111111111111111111;
    fifo_rsp_ready = 0;
    #20;

    biu_rsp_valid = 1;
    biu_rsp_rdata = 128'h22222222222222222222222222222222;
    fifo_rsp_ready = 0;
    #20;

    biu_rsp_valid = 1;
    biu_rsp_rdata = 128'h33333333333333333333333333333333;
    fifo_rsp_ready = 0;
    #20;

    biu_rsp_valid = 0;
    biu_rsp_rdata = 128'h00000000000000000000000000000000;
    fifo_rsp_ready = 1; 
    #10;
    fifo_rsp_ready = 0; 
    #10;

    biu_rsp_valid = 0;
    biu_rsp_rdata = 128'h00000000000000000000000000000000;
    fifo_rsp_ready = 0;
    #10;

    biu_rsp_valid = 0;
    biu_rsp_rdata = 128'h00000000000000000000000000000000;
    fifo_rsp_ready = 1; 
    #10;
    fifo_rsp_ready = 0; 
    #10;

    biu_rsp_valid = 1;
    biu_rsp_rdata = 128'h44444444444444444444444444444444;
    fifo_rsp_ready = 0;
    #20;

    biu_rsp_valid = 1;
    biu_rsp_rdata = 128'h55555555555555555555555555555555;
    #10;
    fifo_rsp_ready = 1;
    #10;
    fifo_rsp_ready = 0;

    biu_rsp_valid = 1;
    biu_rsp_rdata = 128'h66666666666666666666666666666666;
    fifo_rsp_ready = 0;
    #20;

    biu_rsp_valid = 1;
    biu_rsp_rdata = 128'h77777777777777777777777777777777;
    #10;
    fifo_rsp_ready = 1;
    #10;
    biu_rsp_valid = 1;
    biu_rsp_rdata = 128'h88888888888888888888888888888888;
    fifo_rsp_ready = 0;
    #20;

    biu_rsp_valid = 0;
    biu_rsp_rdata = 128'h00000000000000000000000000000000;
    fifo_rsp_ready = 1;
    #10;
    fifo_rsp_ready = 0; 
    #10;

   
    $display("Simulation complete!");
    #50;
    $finish;

end
endmodule

