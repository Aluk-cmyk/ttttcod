`timescale 1ns/1ps

// GPIO IP: synchronous active-high reset; write updates the output register.
module ip_gpio (
    input  logic       clk,
    input  logic       rst,
    input  logic       write_en,
    input  logic [7:0] write_data,
    output logic [7:0] gpio_out
);
    always_ff @(posedge clk) begin
        if (rst)
            gpio_out <= 8'd0;
        else if (write_en)
            gpio_out <= write_data;
    end
endmodule
