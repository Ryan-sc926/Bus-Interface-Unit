`timescale 1ns / 1ps

module inst_de0_tb ();

localparam unsigned INPUT_DATA_WIDTH = 32;
localparam unsigned INPUT_INST_WIDTH = 32;
localparam unsigned OUTPUT_DATA_WIDTH = 32;
localparam unsigned OUTPUT_ADDR_WIDTH  = 32;
localparam unsigned CONFIG_ENTRY0 = 32;
localparam unsigned FETCH_MEM_WORD0 = 4;
localparam unsigned WRITE_MEM_WORD0 = 4;

logic clk;
logic rst_n;
logic nice_active;

logic nice_req_valid;
logic nice_req_ready;
logic [INPUT_INST_WIDTH-1:0] nice_req_inst;
logic [INPUT_DATA_WIDTH-1:0] nice_req_rs1;
logic [INPUT_DATA_WIDTH-1:0] nice_req_rs2;

// Control cmd_rsp: NICE-> e203 core
logic nice_rsp_valid;
logic nice_rsp_ready;
logic [OUTPUT_DATA_WIDTH-1:0] nice_rsp_rdat;
logic nice_rsp_err;

// Memory lsu_req: NICE-> ICB-> DTCM
logic nice_icb_cmd_valid;
logic nice_icb_cmd_ready;
logic [OUTPUT_ADDR_WIDTH-1:0] nice_icb_cmd_addr;
logic nice_icb_cmd_read;
logic [OUTPUT_DATA_WIDTH-1:0] nice_icb_cmd_wdata;
logic [1:0] nice_icb_cmd_size;
logic nice_mem_holdup;

// Memory lsu_rsp: DTCM-> ICB -> NICE
logic nice_icb_rsp_valid;
logic nice_icb_rsp_ready;
logic [INPUT_DATA_WIDTH-1:0] nice_icb_rsp_rdata;
logic nice_icb_rsp_err;

// -------------------- Custom0 --------------------
// cmd fifo interface
logic id_cmd_valid0,
logic id_cmd_ready0,
logic [OUTPUT_DATA_WIDTH-1:0] id_cmd_wdata0,

// rsp dwc interface
logic id_rsp_valid0,
logic id_rsp_ready0,
logic [INPUT_DATA_WIDTH-1:0] id_rsp_rdata0,

//config regs
logic [OUTPUT_DATA_WIDTH-1:0] config_reg0[0:CONFIG_ENTRY0-1],


inst_dec # (
    .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
    .INPUT_INST_WIDTH(INPUT_INST_WIDTH),
    .OUTPUT_DATA_WIDTH(OUTPUT_DATA_WIDTH),
    .OUTPUT_ADDR_WIDTH(OUTPUT_ADDR_WIDTH),
    .CONFIG_ENTRY0(CONFIG_ENTRY0),
    .FETCH_MEM_WORD0(FETCH_MEM_WORD0),
    .WRITE_MEM_WORD0(WRITE_MEM_WORD0)
) U1 (
    .clk(clk),
    .rst_n(rst_n),
    .nice_active(nice_active),
    .nice_req_valid(nice_req_valid),
    .nice_req_ready(nice_req_ready),
    .nice_req_inst(nice_req_inst),
    .nice_req_rs1(nice_req_rs1),
    .nice_req_rs2(nice_req_rs2),
    .nice_rsp_valid(nice_rsp_valid),
    .nice_rsp_ready(nice_rsp_ready),
    .nice_rsp_rdat(nice_rsp_rdat),
    .nice_rsp_err(nice_rsp_err),
    .nice_icb_cmd_valid(nice_icb_cmd_valid),
    .nice_icb_cmd_ready(nice_icb_cmd_ready),
    .nice_icb_cmd_addr(nice_icb_cmd_addr),
    .nice_icb_cmd_read(nice_icb_cmd_read),
    .nice_icb_cmd_wdata(nice_icb_cmd_wdata),
    .nice_icb_cmd_size(nice_icb_cmd_size),
    .nice_mem_holdup(nice_mem_holdup),
    .nice_icb_rsp_valid(nice_icb_rsp_valid),
    .nice_icb_rsp_ready(nice_icb_rsp_ready),
    .nice_icb_rsp_rdata(nice_icb_rsp_rdata),
    .nice_icb_rsp_err(nice_icb_rsp_err),
    
    .id_rsp_valid0(id_rsp_valid0),
    .id_rsp_ready0(id_rsp_ready0),
    .id_rsp_rdata0(id_rsp_rdata0),
    .id_cmd_valid0(id_cmd_valid0),
    .id_cmd_ready0(id_cmd_ready0),
    .id_cmd_wdata0(id_cmd_wdata0),
    .config_reg0(config_reg0)
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
    id_rsp_valid0 = 0;
    id_rsp_rdata0 = 0;
    id_cmd_ready0 = 0; 
    #20;
    rst_n = 1;
    #20;


    //data1
    id_rsp_valid0 = 1;
    id_cmd_ready0 = 0; 
    id_rsp_rdata0 = 32'hAAAAAAAA;
    #20;

    //id_rsp_valid0 = 0
    id_rsp_valid0 = 0;
    id_cmd_ready0 = 0; 
    id_rsp_rdata0 = 32'h00000000;
    #20;

    //data1
    id_rsp_valid0 = 1;
    id_cmd_ready0 = 0; 
    id_rsp_rdata0 = 32'hBBBBBBBB;
    #20;

    //id_rsp_valid0 = 0
    id_rsp_valid0 = 0;
    id_cmd_ready0 = 0; 
    id_rsp_rdata0 = 32'h00000000;
    #20;

    //data1
    id_rsp_valid0 = 1;
    id_cmd_ready0 = 0; 
    id_rsp_rdata0 = 32'hCCCCCCCC;
    #20;
    
    //data1
    id_rsp_valid0 = 1;
    id_cmd_ready0 = 0; 
    id_rsp_rdata0 = 32'hDDDDDDDD;
    #20;

    
    id_rsp_valid0 = 0; 
    id_rsp_rdata0 = 32'h00000000;
    #20; 
    id_cmd_ready0 = 1;
    #20; 
    id_cmd_ready0 = 0;



    $display("Simulation complete!");
    #100;
    $finish;
end
endmodule
