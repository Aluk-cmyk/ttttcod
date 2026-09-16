`timescale 1ns/1ps
module soc_demo_tb;
    logic clk = 0;
    logic rst_n = 0;
    logic enable = 0;
    logic [7:0] count;
    soc_top dut (.*);
    always #5 clk = ~clk;
    initial begin
        repeat (2) @(negedge clk);
        if (count !== 8'd0) $fatal(1, "Reset check failed");
        rst_n = 1;
        enable = 1;
        repeat (3) @(negedge clk);
        if (count !== 8'd3) $fatal(1, "Counter check failed");
        enable = 0;
        repeat (2) @(negedge clk);
        if (count !== 8'd3) $fatal(1, "Hold check failed");
        $display("PASS: reset, count, hold");
        $finish;
    end
endmodule
