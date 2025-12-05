module dwc_rsp0 #(
    parameter unsigned INPUT_DATA_WIDTH = 128,
    parameter unsigned OUTPUT_DATA_WIDTH = 32,
    parameter unsigned RSP_WORD_NUMBER = INPUT_DATA_WIDTH / OUTPUT_DATA_WIDTH
) (
    input logic clk,
    input logic rst_n,

    // processor interface
    output logic id_rsp_valid,
    input logic id_rsp_ready,
    output logic [OUTPUT_DATA_WIDTH-1:0] id_rsp_rdata,

    // co-processor interface
    input logic fifo_rsp_valid,
    output logic fifo_rsp_ready,
    input logic [INPUT_DATA_WIDTH-1:0] fifo_rsp_rdata,

    output logic [1:0] state
);

localparam int WORD_COUNT_WIDTH = (RSP_WORD_NUMBER > 1) ? $clog2(RSP_WORD_NUMBER) : 1;

logic [INPUT_DATA_WIDTH-1:0] data_buf;
logic [OUTPUT_DATA_WIDTH-1:0] unpack_data_buf;
logic [WORD_COUNT_WIDTH:0] word_count;

typedef enum logic [1:0] {
    LOAD,
    UNPACK,
    SEND
} State;

State current_state, next_state;

always_comb begin
    next_state = current_state;
    case (current_state)
    LOAD: begin
        if (fifo_rsp_valid && RSP_WORD_NUMBER != 1) begin
            next_state = UNPACK;
        end else if (fifo_rsp_valid && RSP_WORD_NUMBER == 1) begin
            next_state = SEND;
        end
    end
    UNPACK: begin
        next_state = SEND;
    end
    SEND: begin
        if (id_rsp_ready && RSP_WORD_NUMBER != 1 && word_count != RSP_WORD_NUMBER) begin
            next_state = UNPACK;
        end else if (id_rsp_ready && RSP_WORD_NUMBER != 1 && word_count == RSP_WORD_NUMBER) begin
            next_state = LOAD;
        end else if (id_rsp_ready && RSP_WORD_NUMBER == 1) begin
            next_state = LOAD;
        end else begin
            next_state = SEND;
        end
    end
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= LOAD;
    end else begin
        current_state <= next_state;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_rsp_ready <= 0;
        id_rsp_valid <= 0;
        id_rsp_rdata <= 0;
        data_buf <= 0;
        word_count <= 0;
        unpack_data_buf <= 0;
        state <= 0;
    end else begin
        fifo_rsp_ready <= 0;
        id_rsp_valid <= 0;

        case(current_state)
        LOAD: begin
            word_count <= 0;
            if (fifo_rsp_valid) begin
                fifo_rsp_ready <= 1;
                data_buf <= fifo_rsp_rdata;
            end
        end
        UNPACK: begin
            state <= UNPACK;
            unpack_data_buf <= data_buf[word_count * OUTPUT_DATA_WIDTH +: OUTPUT_DATA_WIDTH];
            word_count <= word_count + 1;
        end
        SEND: begin
            state <= SEND;
            id_rsp_valid <= 1;
            if (RSP_WORD_NUMBER != 1) id_rsp_rdata <= unpack_data_buf;
            else if (RSP_WORD_NUMBER == 1) id_rsp_rdata <= data_buf;
        end
        endcase
    end
end

endmodule
