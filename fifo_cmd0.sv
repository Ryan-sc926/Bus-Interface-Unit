module fifo_cmd0 #(
    parameter unsigned FIFO_DEPTH = 8,
    parameter unsigned INPUT_DATA_WIDTH = 32,
    parameter unsigned OUTPUT_DATA_WIDTH = 32
)
(
    input logic clk,
    input logic rst_n,

    // processor interface
    input  logic id_cmd_valid,
    output logic id_cmd_ready,
    input  logic [INPUT_DATA_WIDTH-1:0] id_cmd_wdata,

    // co-processor interface
    output logic fifo_cmd_valid,
    input  logic fifo_cmd_ready,
    output logic [OUTPUT_DATA_WIDTH-1:0] fifo_cmd_wdata
);

localparam int FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH);

logic empty;
logic full;
logic [FIFO_DEPTH_LOG:0] write_ptr;
logic [FIFO_DEPTH_LOG:0] read_ptr;
logic [OUTPUT_DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];

assign empty = (write_ptr == read_ptr);
assign full  = (write_ptr[FIFO_DEPTH_LOG] != read_ptr[FIFO_DEPTH_LOG]) &&
               (write_ptr[FIFO_DEPTH_LOG-1:0] == read_ptr[FIFO_DEPTH_LOG-1:0]);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_cmd_valid <= 0;
        fifo_cmd_wdata  <= 0;
        id_cmd_ready   <= 0;
        write_ptr      <= 0;
        read_ptr       <= 0;
    end else begin
        id_cmd_ready <= !full;

        // Write to FIFO
        if (id_cmd_valid && !full) begin
            fifo[write_ptr[FIFO_DEPTH_LOG-1:0]] <= id_cmd_wdata;
            write_ptr <= write_ptr + 1;
        end

        // Read from FIFO
        if (!empty && !fifo_cmd_ready) begin
            fifo_cmd_valid <= 1;
            fifo_cmd_wdata  <= fifo[read_ptr[FIFO_DEPTH_LOG-1:0]];
        end
        if (fifo_cmd_valid && fifo_cmd_ready) begin
            fifo_cmd_valid <= 0;
            read_ptr <= read_ptr + 1;
        end
    end
end

endmodule
