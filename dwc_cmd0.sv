module dwc_cmd0 #(
    parameter unsigned INPUT_DATA_WIDTH = 32,
    parameter unsigned OUTPUT_DATA_WIDTH = 128,
    parameter unsigned CMD_WORD_NUMBER  = OUTPUT_DATA_WIDTH / INPUT_DATA_WIDTH
) (
    input  logic clk,
    input  logic rst_n,

    // processor interface
    input  logic fifo_cmd_valid,
    output logic fifo_cmd_ready,
    input  logic [INPUT_DATA_WIDTH-1:0] fifo_cmd_wdata,

    // co-processor interface
    output logic dwc_cmd_valid,
    input  logic dwc_cmd_ready,
    output logic [OUTPUT_DATA_WIDTH-1:0] dwc_cmd_wdata,

    output logic [1:0] state
);

logic send_en;

localparam int WORD_COUNT_WIDTH = (CMD_WORD_NUMBER > 1) ? $clog2(CMD_WORD_NUMBER) : 1;

typedef enum logic [1:0] {
    PACK   = 2'b00,
    BYPASS = 2'b01,
    SEND   = 2'b10
} State;

State current_state, next_state;

logic [OUTPUT_DATA_WIDTH-1:0] data_buf;
logic [WORD_COUNT_WIDTH:0] word_count;

always_comb begin
    case (current_state)
        PACK: begin
            if (word_count == CMD_WORD_NUMBER) next_state = SEND;
            else next_state = PACK;
        end
        BYPASS: begin
            if (fifo_cmd_valid && fifo_cmd_ready) next_state = SEND;
            else next_state = BYPASS;
        end
        SEND: begin
            if (dwc_cmd_ready) next_state = (CMD_WORD_NUMBER == 1) ? BYPASS : PACK;
            else next_state = SEND;
        end
        default: next_state = PACK;
    endcase
end


always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) current_state <= (CMD_WORD_NUMBER == 1) ? BYPASS : PACK;
    else current_state <= next_state;
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_cmd_ready <= 0;
        dwc_cmd_valid  <= 0;
        dwc_cmd_wdata  <= 0;
        data_buf       <= 0;
        word_count     <= 0;
        state          <= 0;
        send_en <= 0;
    end else begin
        fifo_cmd_ready <= 0; // default: only pulse when needed
        dwc_cmd_valid  <= 0;
        state          <= current_state;

        case (current_state)
        PACK: begin
            if (fifo_cmd_valid) fifo_cmd_ready <= 1;
            if (fifo_cmd_valid && fifo_cmd_ready) begin
                data_buf[word_count * INPUT_DATA_WIDTH +: INPUT_DATA_WIDTH] <= fifo_cmd_wdata;
                word_count <= word_count + 1;
                send_en <= 1;
            end
        end

        BYPASS: begin
            if (fifo_cmd_valid) fifo_cmd_ready <= 1;
            if (fifo_cmd_valid && fifo_cmd_ready) begin
                data_buf <= fifo_cmd_wdata;
                send_en <= 1;
            end
        end

        SEND: begin
            if (send_en) begin
                dwc_cmd_valid <= 1;
                dwc_cmd_wdata <= data_buf;
                word_count <= 0;
            end
            if (dwc_cmd_ready) begin
                dwc_cmd_valid <= 0;
                send_en <= 0;
            end

        end
        endcase
    end
end

endmodule
