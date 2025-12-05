module fifo_rsp0 #(
    parameter unsigned FIFO_DEPTH = 8,
    parameter unsigned INPUT_DATA_WIDTH = 128,
    parameter unsigned OUTPUT_DATA_WIDTH = 128
)
(
    input logic clk,
    input logic rst_n,

    // processor interface
    output logic fifo_rsp_valid,
    input logic fifo_rsp_ready,
    output logic [INPUT_DATA_WIDTH-1:0] fifo_rsp_rdata,

    // co-processor interface
    input logic biu_rsp_valid,
    output logic biu_rsp_ready,
    input logic [OUTPUT_DATA_WIDTH-1:0] biu_rsp_rdata
);

localparam int FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH);

logic empty;
logic full;
logic [FIFO_DEPTH_LOG:0] write_ptr;
logic [FIFO_DEPTH_LOG:0] read_ptr;
logic [OUTPUT_DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];


assign empty = (write_ptr == read_ptr);
assign full = (write_ptr[FIFO_DEPTH_LOG] != read_ptr[FIFO_DEPTH_LOG]) &&
              (write_ptr[FIFO_DEPTH_LOG-1:0] == read_ptr[FIFO_DEPTH_LOG-1:0]);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_rsp_valid <= 0;
        fifo_rsp_rdata <= 0;
        biu_rsp_ready <= 0;
        write_ptr <= 0;
        read_ptr <= 0;  
    end else begin      
        biu_rsp_ready  <= !full && biu_rsp_valid;

        // Write to FIFO
        if (biu_rsp_valid && biu_rsp_ready && !full) begin
            biu_rsp_ready <= 0;
            fifo[write_ptr[FIFO_DEPTH_LOG-1:0]] <= biu_rsp_rdata;
            write_ptr <= write_ptr + 1;
        end

        // Read from FIFO
        if (!empty && !fifo_rsp_ready) begin
            fifo_rsp_valid <= 1;
            fifo_rsp_rdata  <= fifo[read_ptr[FIFO_DEPTH_LOG-1:0]];
        end
        if (fifo_rsp_valid && fifo_rsp_ready) begin
            fifo_rsp_valid <= 0;
            read_ptr <= read_ptr + 1;
        end
    end
end
endmodule
