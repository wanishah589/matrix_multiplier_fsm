`timescale 1ns / 1ps

module matrix_mac_3x3 (
    input clk,
    input reset,
    input start,
    output reg done
);
    parameter N = 3;

    reg [7:0] A_mem [0:N*N-1];
    reg [7:0] B_mem [0:N*N-1];
    reg [31:0] C_mem [0:N*N-1];

    reg [7:0] A_val, B_val;
    reg [31:0] acc;
    reg [1:0] i, j, k;

    typedef enum reg [2:0] {
        IDLE = 3'b000,
        LOAD = 3'b001,
        MAC_OP = 3'b010,
        CHECK_K = 3'b011,
        STORE = 3'b100,
        CHECK_IJ = 3'b101,
        DONE_STATE = 3'b110
    } state_type;

    state_type state;

    // Initialize matrices for simulation
    initial begin
        A_mem[0]=1; A_mem[1]=2; A_mem[2]=3;
        A_mem[3]=4; A_mem[4]=5; A_mem[5]=6;
      A_mem[6]=7; A_mem[7]=1; A_mem[8]=9;

      B_mem[0]=9; B_mem[1]=1; B_mem[2]=1;
      B_mem[3]=1; B_mem[4]=1; B_mem[5]=1;
      B_mem[6]=1; B_mem[7]=4; B_mem[8]=1;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            i <= 0; j <= 0; k <= 0;
            acc <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        i <= 0; j <= 0; k <= 0; acc <= 0;
                        state <= LOAD;
                    end
                end
                LOAD: begin
                    A_val <= A_mem[i*N + k];
                    B_val <= B_mem[j*N + k];
                    state <= MAC_OP;
                end
                MAC_OP: begin
                    acc <= acc + (A_val * B_val);
                    state <= CHECK_K;
                end
                CHECK_K: begin
                    if (k < N-1) begin
                        k <= k + 1;
                        state <= LOAD;
                    end else state <= STORE;
                end
                STORE: begin
                    C_mem[i*N + j] <= acc;
                    acc <= 0;
                    k <= 0;
                    state <= CHECK_IJ;
                end
                CHECK_IJ: begin
                    if (j < N-1) begin
                        j <= j + 1;
                        state <= LOAD;
                    end else if (i < N-1) begin
                        i <= i + 1;
                        j <= 0;
                        state <= LOAD;
                    end else state <= DONE_STATE;
                end
                DONE_STATE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
