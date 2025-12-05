`timescale 1ps/1ps

module fifo_cmd0_tb ();

localparam unsigned FIFO_DEPTH = 8;
localparam unsigned INPUT_DATA_WIDTH = 32;
localparam unsigned OUTPUT_DATA_WIDTH = 32;

logic clk;
logic rst_n;

// processor interface
logic id_cmd_valid;
logic id_cmd_ready;
logic [INPUT_DATA_WIDTH-1:0] id_cmd_wdata;

// co-processor interface
logic fifo_cmd_valid;
logic fifo_cmd_ready;
logic [OUTPUT_DATA_WIDTH-1:0] fifo_cmd_wdata;

fifo_cmd0 # (
    .FIFO_DEPTH(FIFO_DEPTH),
    .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
    .OUTPUT_DATA_WIDTH(OUTPUT_DATA_WIDTH)
) U1 (
    .clk(clk),
    .rst_n(rst_n),
    .id_cmd_valid(id_cmd_valid),
    .id_cmd_ready(id_cmd_ready),
    .id_cmd_wdata(id_cmd_wdata),
    .fifo_cmd_valid(fifo_cmd_valid),
    .fifo_cmd_ready(fifo_cmd_ready),
    .fifo_cmd_wdata(fifo_cmd_wdata)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin 
    $dumpfile("fifo_cmd0_tb.vcd");
    $dumpvars(0, fifo_cmd0_tb);

    rst_n = 0;
    id_cmd_valid = 0;
    id_cmd_wdata = 0;
    fifo_cmd_ready = 0;
    #10;

    rst_n = 1;
    #10;

    id_cmd_valid = 1;
    id_cmd_wdata = 32'h11111111;
    fifo_cmd_ready = 0;
    #10;

    id_cmd_valid = 1;
    id_cmd_wdata = 32'h22222222;
    fifo_cmd_ready = 0;
    #10;

    id_cmd_valid = 1;
    id_cmd_wdata = 32'h33333333;
    fifo_cmd_ready = 0;
    #10;

    id_cmd_valid = 0;
    id_cmd_wdata = 32'h00000000;
    fifo_cmd_ready = 1; 
    #10;
    fifo_cmd_ready = 0; 
    #10;

    id_cmd_valid = 0;
    id_cmd_wdata = 32'h00000000;
    fifo_cmd_ready = 0;
    #10;

    id_cmd_valid = 0;
    id_cmd_wdata = 32'h00000000;
    fifo_cmd_ready = 1; 
    #10;
    fifo_cmd_ready = 0; 
    #10;

    id_cmd_valid = 1;
    id_cmd_wdata = 32'h44444444;
    fifo_cmd_ready = 0;
    #10;

    id_cmd_valid = 1;
    id_cmd_wdata = 32'h55555555;
    fifo_cmd_ready = 1;
    #10;
    fifo_cmd_ready = 0;

    id_cmd_valid = 1;
    id_cmd_wdata = 32'h66666666;
    fifo_cmd_ready = 0;
    #10;

    id_cmd_valid = 1;
    id_cmd_wdata = 32'h77777777;
    fifo_cmd_ready = 1; 
    #10;
    id_cmd_valid = 1;
    id_cmd_wdata = 32'h88888888;
    fifo_cmd_ready = 0;
    #10;

    id_cmd_valid = 0;
    id_cmd_wdata = 32'h00000000;
    fifo_cmd_ready = 1;
    #10;
    fifo_cmd_ready = 0; 
    #10;

   
    $display("Simulation complete!");
    #50;
    $finish;

end
endmodule

