`timescale 1ns/1ps

module flag_register #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             reset,
    input  wire             enable,

    input  wire [WIDTH-1:0] alu_result,
    input  wire             carry_in,
    input  wire             overflow_in,

    output reg              zero_flag,
    output reg              negative_flag,
    output reg              carry_flag,
    output reg              overflow_flag
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            zero_flag     <= 1'b0;
            negative_flag <= 1'b0;
            carry_flag    <= 1'b0;
            overflow_flag <= 1'b0;
        end
        else if (enable) begin
            // Zero flag: result is zero
            zero_flag <= (alu_result == {WIDTH{1'b0}});

            // Negative flag: MSB indicates sign
            negative_flag <= alu_result[WIDTH-1];

            // Carry and overflow flags from ALU
            carry_flag    <= carry_in;
            overflow_flag <= overflow_in;
        end
    end

endmodule