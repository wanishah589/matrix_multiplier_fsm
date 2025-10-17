`timescale 1ns / 1ps

module tb_matrix_mac_3x3;

    reg clk, reset, start;
    wire done;

    
    matrix_mac_3x3 uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        // Dump file for waveform
        $dumpfile("matrix_mac_3x3.vcd");
        $dumpvars(0, tb_matrix_mac_3x3);

        // Initialize signals
        clk = 0;
        reset = 1;
        start = 0;

        // Reset pulse
        #10 reset = 0;

        // Start the matrix multiplication
        #10 start = 1;
        #10 start = 0;

        // Wait for completion
        wait (done == 1);

        // Display final result matrix
        $display("\n--- 3x3 MATRIX MULTIPLICATION RESULT ---");
        $display("C[0][0]=%0d  C[0][1]=%0d  C[0][2]=%0d", uut.C_mem[0], uut.C_mem[1], uut.C_mem[2]);
        $display("C[1][0]=%0d  C[1][1]=%0d  C[1][2]=%0d", uut.C_mem[3], uut.C_mem[4], uut.C_mem[5]);
        $display("C[2][0]=%0d  C[2][1]=%0d  C[2][2]=%0d", uut.C_mem[6], uut.C_mem[7], uut.C_mem[8]);
        $display("-----------------------------------------\n");

        #20 $finish;
    end
endmodule
