`timescale 1ns/1ps

module flag_register_tb;

    parameter WIDTH = 8;

    reg             clk;
    reg             reset;
    reg             enable;

    reg [WIDTH-1:0] alu_result;
    reg             carry_in;
    reg             overflow_in;

    wire            zero_flag;
    wire            negative_flag;
    wire            carry_flag;
    wire            overflow_flag;

    // Instantiate DUT
    flag_register #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .alu_result(alu_result),
        .carry_in(carry_in),
        .overflow_in(overflow_in),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Display flag values
    task display_flags;
        begin
            $display("Time=%0t | Result=%h | Z=%b N=%b C=%b V=%b",
                     $time,
                     alu_result,
                     zero_flag,
                     negative_flag,
                     carry_flag,
                     overflow_flag);
        end
    endtask

    initial begin
        // Initialize
        clk         = 0;
        reset       = 1;
        enable      = 0;
        alu_result  = 8'h00;
        carry_in    = 0;
        overflow_in = 0;

        // Reset
        #12;
        reset = 0;

        // Test 1: Zero result
        enable      = 1;
        alu_result  = 8'h00;
        carry_in    = 0;
        overflow_in = 0;

        @(posedge clk);
        #1;
        display_flags;

        // Test 2: Positive result
        alu_result  = 8'h25;
        carry_in    = 0;
        overflow_in = 0;

        @(posedge clk);
        #1;
        display_flags;

        // Test 3: Negative result
        alu_result  = 8'h80;
        carry_in    = 0;
        overflow_in = 0;

        @(posedge clk);
        #1;
        display_flags;

        // Test 4: Carry flag
        alu_result  = 8'h10;
        carry_in    = 1;
        overflow_in = 0;

        @(posedge clk);
        #1;
        display_flags;

        // Test 5: Overflow flag
        alu_result  = 8'h7F;
        carry_in    = 0;
        overflow_in = 1;

        @(posedge clk);
        #1;
        display_flags;

        // Test 6: Carry + Overflow
        alu_result  = 8'h80;
        carry_in    = 1;
        overflow_in = 1;

        @(posedge clk);
        #1;
        display_flags;

        // Test 7: Disable flag update
        enable      = 0;
        alu_result  = 8'h00;
        carry_in    = 0;
        overflow_in = 0;

        @(posedge clk);
        #1;
        display_flags;

        // Finish simulation
        #10;
        $finish;
    end

    // Generate waveform
    initial begin
        $dumpfile("simulation/waveform.vcd");
        $dumpvars(0, flag_register_tb);
    end

endmodule