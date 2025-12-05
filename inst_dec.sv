module inst_dec #(
    parameter unsigned INPUT_DATA_WIDTH = 32,
    parameter unsigned INPUT_INST_WIDTH = 32,
    parameter unsigned OUTPUT_DATA_WIDTH = 32,
    parameter unsigned OUTPUT_ADDR_WIDTH = 32,

// -------------------- Custom0 --------------------
    parameter unsigned CONFIG_ENTRY0 = 32,
    parameter unsigned FETCH_MEM_WORD0 = 6,
    parameter unsigned WRITE_MEM_WORD0 = 4,

// -------------------- Custom1 --------------------
    parameter unsigned CONFIG_ENTRY1 = 32,
    parameter unsigned FETCH_MEM_WORD1 = 6,
    parameter unsigned WRITE_MEM_WORD1 = 4,

// -------------------- Custom2 --------------------
    parameter unsigned CONFIG_ENTRY2 = 32,
    parameter unsigned FETCH_MEM_WORD2 = 6,
    parameter unsigned WRITE_MEM_WORD2 = 4,

// -------------------- Custom3 --------------------
    parameter unsigned CONFIG_ENTRY3 = 32,
    parameter unsigned FETCH_MEM_WORD3 = 6,
    parameter unsigned WRITE_MEM_WORD3 = 4
)
(
    input logic clk,
    input logic rst_n,
    output logic nice_active,

    // Control cmd_req: e203 core-> NICE
    input logic nice_req_valid,
    output logic nice_req_ready,
    input logic [INPUT_INST_WIDTH-1:0] nice_req_inst,
    input logic [INPUT_DATA_WIDTH-1:0] nice_req_rs1,
    input logic [INPUT_DATA_WIDTH-1:0] nice_req_rs2,

    // Control cmd_rsp: NICE-> e203 core
    output logic nice_rsp_valid,
    input logic nice_rsp_ready,
    output logic [OUTPUT_DATA_WIDTH-1:0] nice_rsp_rdat,
    output logic nice_rsp_err,

    // Memory lsu_req: NICE-> ICB-> DTCM
    output logic nice_icb_cmd_valid,
    input logic nice_icb_cmd_ready,
    output logic [OUTPUT_ADDR_WIDTH-1:0] nice_icb_cmd_addr,
    output logic nice_icb_cmd_read,
    output logic [OUTPUT_DATA_WIDTH-1:0] nice_icb_cmd_wdata,
    output logic [1:0] nice_icb_cmd_size,
    output logic nice_mem_holdup,

    // Memory lsu_rsp: DTCM-> ICB -> NICE
    input logic nice_icb_rsp_valid,
    output logic nice_icb_rsp_ready,
    input logic [INPUT_DATA_WIDTH-1:0] nice_icb_rsp_rdata,
    input logic nice_icb_rsp_err,

// -------------------- Custom0 --------------------
    // cmd fifo interface
    output logic id_cmd_valid0,
    input logic id_cmd_ready0,
    output logic [OUTPUT_DATA_WIDTH-1:0] id_cmd_wdata0,

    // rsp dwc interface
    input logic id_rsp_valid0,
    output logic id_rsp_ready0,
    input logic [INPUT_DATA_WIDTH-1:0] id_rsp_rdata0,

    //config regs
    output logic [OUTPUT_DATA_WIDTH-1:0] config_reg0[0:CONFIG_ENTRY0-1],

    output logic [2:0] state0,

// -------------------- Custom1 --------------------
    // cmd fifo interface
    output logic id_cmd_valid1,
    input logic id_cmd_ready1,
    output logic [OUTPUT_DATA_WIDTH-1:0] id_cmd_wdata1,

    // rsp dwc interface
    input logic id_rsp_valid1,
    output logic id_rsp_ready1,
    input logic [INPUT_DATA_WIDTH-1:0] id_rsp_rdata1,

    //config regs
    output logic [OUTPUT_DATA_WIDTH-1:0] config_reg1[0:CONFIG_ENTRY1-1],

    output logic [2:0] state1,

// -------------------- Custom2 --------------------
    // cmd fifo interface
    output logic id_cmd_valid2,
    input logic id_cmd_ready2,
    output logic [OUTPUT_DATA_WIDTH-1:0] id_cmd_wdata2,

    // rsp dwc interface
    input logic id_rsp_valid2,
    output logic id_rsp_ready2,
    input logic [INPUT_DATA_WIDTH-1:0] id_rsp_rdata2,

    //config regs
    output logic [OUTPUT_DATA_WIDTH-1:0] config_reg2[0:CONFIG_ENTRY2-1],

    output logic [2:0] state2,

// -------------------- Custom3 --------------------
    // cmd fifo interface
    output logic id_cmd_valid3,
    input logic id_cmd_ready3,
    output logic [OUTPUT_DATA_WIDTH-1:0] id_cmd_wdata3,

    // rsp dwc interface
    input logic id_rsp_valid3,
    output logic id_rsp_ready3,
    input logic [INPUT_DATA_WIDTH-1:0] id_rsp_rdata3,

    //config regs
    output logic [OUTPUT_DATA_WIDTH-1:0] config_reg3[0:CONFIG_ENTRY3-1],

    output logic [2:0] state3
    
);

// CUSTOM0 = 7'h0b, R type
// CUSTOM1 = 7'h2b, R tpye
// CUSTOM2 = 7'h5b, R type
// CUSTOM3 = 7'h7b, R type

// -------------------- Instruction Decode --------------------
logic [6:0] opcode;
logic [2:0] func3;
logic [6:0] func7;

assign opcode = nice_req_inst[6:0];
assign func3  = nice_req_inst[14:12];
assign func7  = nice_req_inst[31:25];

logic opcode_custom0;
logic opcode_custom1;
logic opcode_custom2;
logic opcode_custom3;
assign opcode_custom0 = (opcode == 7'b0001011);
assign opcode_custom1 = (opcode == 7'b0101011);
assign opcode_custom2 = (opcode == 7'b1011011);
assign opcode_custom3 = (opcode == 7'b1111011);

logic custom0_lbuf;
logic custom0_sbuf;
logic custom0_rs1;
logic custom0_rs2;
logic custom0_rd;
assign custom0_lbuf = opcode_custom0 & (func3 == 3'b010) & (func7 == 7'd1);
assign custom0_sbuf = opcode_custom0 & (func3 == 3'b010) & (func7 == 7'd2);
assign custom0_rs1  = opcode_custom0 & (func3 == 3'b010) & (func7 == 7'd3);
assign custom0_rs2  = opcode_custom0 & (func3 == 3'b001) & (func7 == 7'd4);
assign custom0_rd   = opcode_custom0 & (func3 == 3'b100) & (func7 == 7'd5);

logic custom1_lbuf;
logic custom1_sbuf;
logic custom1_rs1;
logic custom1_rs2;
logic custom1_rd;
assign custom1_lbuf = opcode_custom1 & (func3 == 3'b010) & (func7 == 7'd1);
assign custom1_sbuf = opcode_custom1 & (func3 == 3'b010) & (func7 == 7'd2);
assign custom1_rs1  = opcode_custom1 & (func3 == 3'b010) & (func7 == 7'd3);
assign custom1_rs2  = opcode_custom1 & (func3 == 3'b001) & (func7 == 7'd4);
assign custom1_rd   = opcode_custom1 & (func3 == 3'b100) & (func7 == 7'd5);

logic custom2_lbuf;
logic custom2_sbuf;
logic custom2_rs1;
logic custom2_rs2;
logic custom2_rd;
assign custom2_lbuf = opcode_custom2 & (func3 == 3'b010) & (func7 == 7'd1);
assign custom2_sbuf = opcode_custom2 & (func3 == 3'b010) & (func7 == 7'd2);
assign custom2_rs1  = opcode_custom2 & (func3 == 3'b010) & (func7 == 7'd3);
assign custom2_rs2  = opcode_custom2 & (func3 == 3'b001) & (func7 == 7'd4);
assign custom2_rd   = opcode_custom2 & (func3 == 3'b100) & (func7 == 7'd5);

logic custom3_lbuf;
logic custom3_sbuf;
logic custom3_rs1;
logic custom3_rs2;
logic custom3_rd;
assign custom3_lbuf = opcode_custom3 & (func3 == 3'b010) & (func7 == 7'd1);
assign custom3_sbuf = opcode_custom3 & (func3 == 3'b010) & (func7 == 7'd2);
assign custom3_rs1  = opcode_custom3 & (func3 == 3'b010) & (func7 == 7'd3);
assign custom3_rs2  = opcode_custom3 & (func3 == 3'b001) & (func7 == 7'd4);
assign custom3_rd   = opcode_custom3 & (func3 == 3'b100) & (func7 == 7'd5);

logic custom0_config;
always_comb begin
    custom0_config = 1'b0;
    if (opcode_custom0 && func3 == 3'b010 && func7 >= 7'd6 && func7 < 7'd6 + CONFIG_ENTRY0)
        custom0_config = 1'b1;
end

logic custom1_config;
always_comb begin
    custom1_config = 1'b0;
    if (opcode_custom1 && func3 == 3'b010 && func7 >= 7'd6 && func7 < 7'd6 + CONFIG_ENTRY1)
        custom1_config = 1'b1;
end

logic custom2_config;
always_comb begin
    custom2_config = 1'b0;
    if (opcode_custom2 && func3 == 3'b010 && func7 >= 7'd6 && func7 < 7'd6 + CONFIG_ENTRY2)
        custom2_config = 1'b1;
end

logic custom3_config;
always_comb begin
    custom3_config = 1'b0;
    if (opcode_custom3 && func3 == 3'b010 && func7 >= 7'd6 && func7 < 7'd6 + CONFIG_ENTRY3)
        custom3_config = 1'b1;
end

// -------------------- FSM --------------------
typedef enum logic [4:0] {
    IDLE,

    CONFIG_REG0,
    LOAD_CMD0,
    LBUF0,
    SBUF0,
    FIFO_WRITE0,
    DWC_READ0,

    CONFIG_REG1,
    LOAD_CMD1,
    LBUF1,
    SBUF1,
    FIFO_WRITE1,
    DWC_READ1,

    CONFIG_REG2,
    LOAD_CMD2,
    LBUF2,
    SBUF2,
    FIFO_WRITE2,
    DWC_READ2,

    CONFIG_REG3,
    LOAD_CMD3,
    LBUF3,
    SBUF3,
    FIFO_WRITE3,
    DWC_READ3 
} State;

State current_state, next_state;

// -------------------- Internal Registers --------------------
logic [INPUT_DATA_WIDTH-1:0] addr_data_lbuf;
logic [6:0] func7_reg;
logic [OUTPUT_DATA_WIDTH-1:0] lbuf, sbuf;
logic send_en;
logic addr_add_done;
logic addr_add_en;
logic [$clog2(FETCH_MEM_WORD0):0] load_word_count0;
logic [$clog2(FETCH_MEM_WORD1):0] load_word_count1;
logic [$clog2(FETCH_MEM_WORD2):0] load_word_count2;
logic [$clog2(FETCH_MEM_WORD3):0] load_word_count3;
logic [$clog2(WRITE_MEM_WORD0):0] store_word_count0;
logic [$clog2(WRITE_MEM_WORD1):0] store_word_count1;
logic [$clog2(WRITE_MEM_WORD2):0] store_word_count2;
logic [$clog2(WRITE_MEM_WORD3):0] store_word_count3;

assign nice_icb_cmd_size = 2'b10;
assign nice_active = (current_state == IDLE) ? nice_req_valid : 1'b1;
//assign nice_mem_holdup    =  current_state != IDLE | current_state != CONFIG_REG3; 
assign nice_rsp_err = ((nice_req_valid && !(custom0_lbuf || custom0_sbuf || custom0_config)) &&
                      (nice_req_valid && !(custom1_lbuf || custom1_sbuf || custom1_config)) &&
                      (nice_req_valid && !(custom2_lbuf || custom2_sbuf || custom2_config)) &&
                      (nice_req_valid && !(custom3_lbuf || custom3_sbuf || custom3_config))) ||
                       nice_icb_rsp_err;

always_comb begin
    next_state = current_state;
    case (current_state)
        IDLE: begin
            if (nice_req_valid && custom0_sbuf) next_state = DWC_READ0;
            else if (nice_req_valid && custom1_sbuf) next_state = DWC_READ1;
            else if (nice_req_valid && custom2_sbuf) next_state = DWC_READ2;
            else if (nice_req_valid && custom3_sbuf) next_state = DWC_READ3;
            
            if (nice_req_valid && nice_req_ready) begin
                if (custom0_config) next_state = CONFIG_REG0;
                else if (custom1_config) next_state = CONFIG_REG1;
                else if (custom2_config) next_state = CONFIG_REG2;
                else if (custom3_config) next_state = CONFIG_REG3;
                else if (custom0_lbuf) next_state = LBUF0;
                else if (custom1_lbuf) next_state = LBUF1;
                else if (custom2_lbuf) next_state = LBUF2;
                else if (custom3_lbuf) next_state = LBUF3;
            end
        end
        CONFIG_REG0: if (nice_rsp_valid) next_state = IDLE;
        LOAD_CMD0: if (nice_icb_cmd_valid && nice_icb_cmd_ready) next_state = LBUF0;
        LBUF0: if (nice_icb_rsp_valid && nice_icb_rsp_ready) next_state = FIFO_WRITE0;
        SBUF0: if (nice_icb_cmd_valid && nice_icb_cmd_ready && store_word_count0 == WRITE_MEM_WORD0-1) next_state = IDLE;
              else if (nice_icb_cmd_valid && nice_icb_cmd_ready) next_state = DWC_READ0;
        FIFO_WRITE0: if (id_cmd_valid0 && id_cmd_ready0 && load_word_count0 == FETCH_MEM_WORD0 - 1) next_state = IDLE;
                    else if (id_cmd_valid0 && id_cmd_ready0) next_state = LOAD_CMD0;
        DWC_READ0: if (id_rsp_valid0 && id_rsp_ready0) next_state = SBUF0;

        CONFIG_REG1: if (nice_rsp_valid) next_state = IDLE;
        LOAD_CMD1: if (nice_icb_cmd_valid && nice_icb_cmd_ready) next_state = LBUF1;
        LBUF1: if (nice_icb_rsp_valid && nice_icb_rsp_ready) next_state = FIFO_WRITE1;
        SBUF1: if (nice_icb_cmd_valid && nice_icb_cmd_ready && store_word_count1 == WRITE_MEM_WORD1-1) next_state = IDLE;
              else if (nice_icb_cmd_valid && nice_icb_cmd_ready) next_state = DWC_READ1;
        FIFO_WRITE1: if (id_cmd_valid1 && id_cmd_ready1 && load_word_count1 == FETCH_MEM_WORD1 - 1) next_state = IDLE;
                    else if (id_cmd_valid1 && id_cmd_ready1) next_state = LOAD_CMD1;
        DWC_READ1: if (id_rsp_valid1 && id_rsp_ready1) next_state = SBUF1;

        CONFIG_REG2: if (nice_rsp_valid) next_state = IDLE;
        LOAD_CMD2: if (nice_icb_cmd_valid && nice_icb_cmd_ready) next_state = LBUF2;
        LBUF2: if (nice_icb_rsp_valid && nice_icb_rsp_ready) next_state = FIFO_WRITE2;
        SBUF2: if (nice_icb_cmd_valid && nice_icb_cmd_ready && store_word_count2 == WRITE_MEM_WORD2-1) next_state = IDLE;
              else if (nice_icb_cmd_valid && nice_icb_cmd_ready) next_state = DWC_READ2;
        FIFO_WRITE2: if (id_cmd_valid2 && id_cmd_ready2 && load_word_count2 == FETCH_MEM_WORD2 - 1) next_state = IDLE;
                    else if (id_cmd_valid2 && id_cmd_ready2) next_state = LOAD_CMD2;
        DWC_READ2: if (id_rsp_valid2 && id_rsp_ready2) next_state = SBUF2;

        CONFIG_REG3: if (nice_rsp_valid) next_state = IDLE;
        LOAD_CMD3: if (nice_icb_cmd_valid && nice_icb_cmd_ready) next_state = LBUF3;
        LBUF3: if (nice_icb_rsp_valid && nice_icb_rsp_ready) next_state = FIFO_WRITE3;
        SBUF3: if (nice_icb_cmd_valid && nice_icb_cmd_ready && store_word_count3 == WRITE_MEM_WORD3-1) next_state = IDLE;
              else if (nice_icb_cmd_valid && nice_icb_cmd_ready) next_state = DWC_READ3;
        FIFO_WRITE3: if (id_cmd_valid3 && id_cmd_ready3 && load_word_count3 == FETCH_MEM_WORD3 - 1) next_state = IDLE;
                    else if (id_cmd_valid3 && id_cmd_ready3) next_state = LOAD_CMD3;
        DWC_READ3: if (id_rsp_valid3 && id_rsp_ready3) next_state = SBUF3;
        default: next_state = IDLE;
    endcase
end

// -------------------- FSM Sequential Logic --------------------
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// -------------------- Main Sequential Logic --------------------
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        nice_req_ready <= 0;
        nice_rsp_valid <= 0;
        nice_rsp_rdat <= 0;
        nice_icb_cmd_valid <= 0;
        nice_icb_cmd_addr <= 0;
        nice_icb_cmd_wdata <= 0;
        nice_icb_cmd_read <= 0;
        nice_icb_rsp_ready <= 0;

        id_cmd_valid0 <= 0;
        id_cmd_wdata0 <= 0;
        id_rsp_ready0 <= 0;
        state0 <= 0;
        for (int j = 0; j < CONFIG_ENTRY0; j++) config_reg0[j] <= 0;
        load_word_count0 <= 0;
        store_word_count0 <= 0;

        id_cmd_valid1 <= 0;
        id_cmd_wdata1 <= 0;
        id_rsp_ready1 <= 0;
        state1 <= 0;
        for (int j = 0; j < CONFIG_ENTRY1; j++) config_reg1[j] <= 0;
        load_word_count1 <= 0;
        store_word_count1 <= 0;

        id_cmd_valid2 <= 0;
        id_cmd_wdata2 <= 0;
        id_rsp_ready2 <= 0;
        state2 <= 0;
        for (int j = 0; j < CONFIG_ENTRY2; j++) config_reg2[j] <= 0;
        load_word_count2 <= 0;
        store_word_count2 <= 0;

        id_cmd_valid3 <= 0;
        id_cmd_wdata3 <= 0;
        id_rsp_ready3 <= 0;
        state3 <= 0;
        for (int j = 0; j < CONFIG_ENTRY3; j++) config_reg3[j] <= 0;
        load_word_count3 <= 0;
        store_word_count3 <= 0;

        nice_mem_holdup <= 0;
        addr_data_lbuf <= 0;
        func7_reg <= 0;
        lbuf <= 0;
        sbuf <= 0;
        send_en <= 0;
        addr_add_done <= 0;
        addr_add_en <= 0;
        
    end else begin
        nice_req_ready <= 0;
        nice_rsp_valid <= 0;
        nice_icb_cmd_valid <= 0;
        nice_icb_rsp_ready <= 0;
        nice_mem_holdup <= 1;

        id_cmd_valid0 <= 0;
        id_rsp_ready0 <= 0;
        state0 <= current_state;

        id_cmd_valid1 <= 0;
        id_rsp_ready1 <= 0;
        state1 <= current_state;

        id_cmd_valid2 <= 0;
        id_rsp_ready2 <= 0;
        state2 <= current_state;

        id_cmd_valid3 <= 0;
        id_rsp_ready3 <= 0;
        state3 <= current_state;
        
        case (current_state)
            IDLE: begin
                nice_mem_holdup <= 0;
                load_word_count0 <= 0;
                load_word_count1 <= 0;
                load_word_count2 <= 0;
                load_word_count3 <= 0;
                store_word_count0 <= 0;
                store_word_count1 <= 0;
                store_word_count2 <= 0;
                store_word_count3 <= 0;
                if (nice_req_valid && !nice_rsp_err) begin
                    addr_data_lbuf <= nice_req_rs1;
                    func7_reg <= func7;
                    if (custom0_lbuf) begin
                        nice_req_ready <= 1;
                        nice_icb_cmd_valid <= 1;
                        nice_icb_cmd_addr <= nice_req_rs1;
                        nice_icb_cmd_read <= 1;
                        send_en <= 1;
                    end else if (custom0_config) begin
                        nice_req_ready <= 1;
                    end
                    if (custom1_lbuf) begin
                        nice_req_ready <= 1;
                        nice_icb_cmd_valid <= 1;
                        nice_icb_cmd_addr <= nice_req_rs1;
                        nice_icb_cmd_read <= 1;
                        send_en <= 1;
                    end else if (custom1_config) begin
                        nice_req_ready <= 1;
                    end
                    if (custom2_lbuf) begin
                        nice_req_ready <= 1;
                        nice_icb_cmd_valid <= 1;
                        nice_icb_cmd_addr <= nice_req_rs1;
                        nice_icb_cmd_read <= 1;
                        send_en <= 1;
                    end else if (custom2_config) begin
                        nice_req_ready <= 1;
                    end
                    if (custom3_lbuf) begin
                        nice_req_ready <= 1;
                        nice_icb_cmd_valid <= 1;
                        nice_icb_cmd_addr <= nice_req_rs1;
                        nice_icb_cmd_read <= 1;
                        send_en <= 1;
                    end else if (custom3_config) begin
                        nice_req_ready <= 1;
                    end
                end
            end

// -------------------- Custom0 --------------------
            CONFIG_REG0: begin
                config_reg0[func7_reg - 7'd6] <= addr_data_lbuf;
                nice_rsp_valid <= 1;
            end
            LOAD_CMD0: begin
                if (addr_add_en) begin
                    nice_icb_cmd_addr <= nice_icb_cmd_addr + 4;
                    nice_icb_cmd_read <= 1;
                    addr_add_done <= 1;
                    addr_add_en <= 0;
                end
                if (addr_add_done) begin
                    nice_icb_cmd_valid <= 1;  
                end
                if (nice_icb_cmd_valid && nice_icb_cmd_ready) begin
                    nice_icb_cmd_valid <= 0;
                    addr_add_done <= 0;
                end
            end
            LBUF0: begin
                if (nice_icb_rsp_valid) begin
                    nice_icb_rsp_ready <= 1;
                    lbuf <= nice_icb_rsp_rdata;
                    send_en <= 1;
                end
            end
            FIFO_WRITE0: begin
                if (send_en) begin
                    id_cmd_valid0 <= 1;
                    id_cmd_wdata0 <= lbuf;
                    send_en <= 0;
                end
                if (id_cmd_valid0 && id_cmd_ready0) begin
                    if (load_word_count0 != FETCH_MEM_WORD0-1) begin
                        addr_add_en <= 1;
                        load_word_count0 <= load_word_count0 + 1; 
                    end else begin
                        nice_rsp_valid <= 1;
                    end
                end
            end
            DWC_READ0: begin
                nice_icb_cmd_valid <= 0; 
                if (id_rsp_valid0) begin
                    id_rsp_ready0 <= 1;
                    sbuf <= id_rsp_rdata0;
                    send_en <= 1;
                end
            end
            SBUF0: begin
                if (nice_req_valid && send_en) begin
                    nice_req_ready <= 1;
                end else begin
                    nice_req_ready <= 0;
                end
                if (send_en) begin
                    nice_icb_cmd_valid <= 1;
                    nice_icb_cmd_addr <= addr_data_lbuf;
                    nice_icb_cmd_read <= 0;
                    nice_icb_cmd_wdata <= sbuf;
                    nice_icb_rsp_ready <= 1;                 
                end
                if (nice_icb_cmd_valid && nice_icb_cmd_ready) begin
                    nice_icb_cmd_valid <= 0;   
                    send_en <= 0;
                    if (store_word_count0 != WRITE_MEM_WORD0-1) begin
                        addr_data_lbuf <= addr_data_lbuf + 4;
                        store_word_count0 <= store_word_count0 + 1;
                    end else nice_rsp_valid <= 1;
                end
            end

// -------------------- Custom1 --------------------
            CONFIG_REG1: begin
                config_reg1[func7_reg - 7'd6] <= addr_data_lbuf;
                nice_rsp_valid <= 1;
            end
            LOAD_CMD1: begin
                if (addr_add_en) begin
                    nice_icb_cmd_addr <= nice_icb_cmd_addr + 4;
                    nice_icb_cmd_read <= 1;
                    addr_add_done <= 1;
                    addr_add_en <= 0;
                end
                if (addr_add_done) begin
                    nice_icb_cmd_valid <= 1;  
                end
                if (nice_icb_cmd_valid && nice_icb_cmd_ready) begin
                    nice_icb_cmd_valid <= 0;
                    addr_add_done <= 0;
                end
            end
            LBUF1: begin
                if (nice_icb_rsp_valid) begin
                    nice_icb_rsp_ready <= 1;
                    lbuf <= nice_icb_rsp_rdata;
                    send_en <= 1;
                end
            end
            FIFO_WRITE1: begin
                if (send_en) begin
                    id_cmd_valid1 <= 1;
                    id_cmd_wdata1 <= lbuf;
                    send_en <= 0;
                end
                if (id_cmd_valid1 && id_cmd_ready1) begin
                    if (load_word_count1 != FETCH_MEM_WORD1-1) begin
                        addr_add_en <= 1;
                        load_word_count1 <= load_word_count1 + 1; 
                    end else begin
                        nice_rsp_valid <= 1;
                    end
                end
            end
            DWC_READ1: begin
                nice_icb_cmd_valid <= 0; 
                if (id_rsp_valid1) begin
                    id_rsp_ready1 <= 1;
                    sbuf <= id_rsp_rdata1;
                    send_en <= 1;
                end
            end
            SBUF1: begin
                if (nice_req_valid && send_en) begin
                    nice_req_ready <= 1;
                end else begin
                    nice_req_ready <= 0;
                end
                if (send_en) begin
                    nice_icb_cmd_valid <= 1;
                    nice_icb_cmd_addr <= addr_data_lbuf;
                    nice_icb_cmd_read <= 0;
                    nice_icb_cmd_wdata <= sbuf;
                    nice_icb_rsp_ready <= 1;                 
                end
                if (nice_icb_cmd_valid && nice_icb_cmd_ready) begin
                    nice_icb_cmd_valid <= 0;   
                    send_en <= 0;
                    if (store_word_count1 != WRITE_MEM_WORD1-1) begin
                        addr_data_lbuf <= addr_data_lbuf + 4;
                        store_word_count1 <= store_word_count1 + 1;
                    end else nice_rsp_valid <= 1;
                end
            end

// -------------------- Custom2 --------------------
            CONFIG_REG2: begin
                config_reg2[func7_reg - 7'd6] <= addr_data_lbuf;
                nice_rsp_valid <= 1;
            end
            LOAD_CMD2: begin
                if (addr_add_en) begin
                    nice_icb_cmd_addr <= nice_icb_cmd_addr + 4;
                    nice_icb_cmd_read <= 1;
                    addr_add_done <= 1;
                    addr_add_en <= 0;
                end
                if (addr_add_done) begin
                    nice_icb_cmd_valid <= 1;  
                end
                if (nice_icb_cmd_valid && nice_icb_cmd_ready) begin
                    nice_icb_cmd_valid <= 0;
                    addr_add_done <= 0;
                end
            end
            LBUF2: begin
                if (nice_icb_rsp_valid) begin
                    nice_icb_rsp_ready <= 1;
                    lbuf <= nice_icb_rsp_rdata;
                    send_en <= 1;
                end
            end
            FIFO_WRITE2: begin
                if (send_en) begin
                    id_cmd_valid2 <= 1;
                    id_cmd_wdata2 <= lbuf;
                    send_en <= 0;
                end
                if (id_cmd_valid2 && id_cmd_ready2) begin
                    if (load_word_count2 != FETCH_MEM_WORD2-1) begin
                        addr_add_en <= 1;
                        load_word_count2 <= load_word_count2 + 1; 
                    end else begin
                        nice_rsp_valid <= 1;
                    end
                end
            end
            DWC_READ2: begin
                nice_icb_cmd_valid <= 0; 
                if (id_rsp_valid2) begin
                    id_rsp_ready2 <= 1;
                    sbuf <= id_rsp_rdata2;
                    send_en <= 1;
                end
            end
            SBUF2: begin
                if (nice_req_valid && send_en) begin
                    nice_req_ready <= 1;
                end else begin
                    nice_req_ready <= 0;
                end
                if (send_en) begin
                    nice_icb_cmd_valid <= 1;
                    nice_icb_cmd_addr <= addr_data_lbuf;
                    nice_icb_cmd_read <= 0;
                    nice_icb_cmd_wdata <= sbuf;
                    nice_icb_rsp_ready <= 1;                 
                end
                if (nice_icb_cmd_valid && nice_icb_cmd_ready) begin
                    nice_icb_cmd_valid <= 0;   
                    send_en <= 0;
                    if (store_word_count2 != WRITE_MEM_WORD2-1) begin
                        addr_data_lbuf <= addr_data_lbuf + 4;
                        store_word_count2 <= store_word_count2 + 1;
                    end else nice_rsp_valid <= 1;
                end
            end

// -------------------- Custom3 --------------------
            CONFIG_REG3: begin
                config_reg3[func7_reg - 7'd6] <= addr_data_lbuf;
                nice_rsp_valid <= 1;
            end
            LOAD_CMD3: begin
                if (addr_add_en) begin
                    nice_icb_cmd_addr <= nice_icb_cmd_addr + 4;
                    nice_icb_cmd_read <= 1;
                    addr_add_done <= 1;
                    addr_add_en <= 0;
                end
                if (addr_add_done) begin
                    nice_icb_cmd_valid <= 1;  
                end
                if (nice_icb_cmd_valid && nice_icb_cmd_ready) begin
                    nice_icb_cmd_valid <= 0;
                    addr_add_done <= 0;
                end
            end
            LBUF3: begin
                if (nice_icb_rsp_valid) begin
                    nice_icb_rsp_ready <= 1;
                    lbuf <= nice_icb_rsp_rdata;
                    send_en <= 1;
                end
            end
            FIFO_WRITE3: begin
                if (send_en) begin
                    id_cmd_valid3 <= 1;
                    id_cmd_wdata3 <= lbuf;
                    send_en <= 0;
                end
                if (id_cmd_valid3 && id_cmd_ready3) begin
                    if (load_word_count3 != FETCH_MEM_WORD3-1) begin
                        addr_add_en <= 1;
                        load_word_count3 <= load_word_count3 + 1; 
                    end else begin
                        nice_rsp_valid <= 1;
                    end
                end
            end
            DWC_READ3: begin
                nice_icb_cmd_valid <= 0; 
                if (id_rsp_valid3) begin
                    id_rsp_ready3 <= 1;
                    sbuf <= id_rsp_rdata3;
                    send_en <= 1;
                end
            end
            SBUF3: begin
                if (nice_req_valid && send_en) begin
                    nice_req_ready <= 1;
                end else begin
                    nice_req_ready <= 0;
                end
                if (send_en) begin
                    nice_icb_cmd_valid <= 1;
                    nice_icb_cmd_addr <= addr_data_lbuf;
                    nice_icb_cmd_read <= 0;
                    nice_icb_cmd_wdata <= sbuf;
                    nice_icb_rsp_ready <= 1;                 
                end
                if (nice_icb_cmd_valid && nice_icb_cmd_ready) begin
                    nice_icb_cmd_valid <= 0;   
                    send_en <= 0;
                    if (store_word_count3 != WRITE_MEM_WORD3-1) begin
                        addr_data_lbuf <= addr_data_lbuf + 4;
                        store_word_count3 <= store_word_count3 + 1;
                    end else nice_rsp_valid <= 1;
                end
            end
        endcase
    end
end

endmodule
