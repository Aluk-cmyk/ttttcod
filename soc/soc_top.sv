`timescale 1ns/1ps

// Minimal integration top: two independent IPs share clock and reset.
module soc_top (
    input  logic       clk,
    input  logic       rst,
    input  logic       counter_enable,
    input  logic       gpio_write_en,
    input  logic [7:0] gpio_write_data,
    output logic [7:0] count,
    output logic [7:0] gpio_out
);
    ip_counter u_counter (
        .clk(clk),
        .rst(rst),
        .enable(counter_enable),
        .count(count)
    );

    ip_gpio u_gpio (
        .clk(clk),
        .rst(rst),
        .write_en(gpio_write_en),
        .write_data(gpio_write_data),
        .gpio_out(gpio_out)
    );
endmodule
