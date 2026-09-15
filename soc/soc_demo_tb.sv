`timescale 1ns/1ps

module soc_demo_tb;萨达四大队
    logic       clk = 1'b0;
    logic       rst = 1'b1;
    logic       counter_enable = 1'b0;
    logic       gpio_write_en = 1'b0;
    logic [7:0] gpio_write_data = 8'd0;
    logic [7:0] count;
    logic [7:0] gpio_out;
    int checks = 0;

    soc_top dut (.*);
    always #5 clk = ~clk;

    task automatic tick;
        @(posedge clk);
        #1;
    endtask

    task automatic check_outputs(
        input logic [7:0] expected_count,
        input logic [7:0] expected_gpio,
        input string label_text
    );
        if (count !== expected_count || gpio_out !== expected_gpio)
            $fatal(1, "[FAIL] %s: count=%0d expected=%0d gpio=%0h expected=%0h",
                   label_text, count, expected_count, gpio_out, expected_gpio);
        checks++;
        $display("[PASS] %s", label_text);
    endtask

    initial begin
        $dumpfile("soc_demo.vcd");
        $dumpvars(0, soc_demo_tb);
        tick();
        check_outputs(8'd0, 8'h00, "reset clears both IPs");

        @(negedge clk);
        rst = 1'b0;
        counter_enable = 1'b1;
        tick();
        check_outputs(8'd1, 8'h00, "counter increments independently");

        @(negedge clk);
        counter_enable = 1'b0;
        gpio_write_en = 1'b1;
        gpio_write_data = 8'hA5;
        tick();
        check_outputs(8'd1, 8'hA5, "GPIO writes while counter holds");

        @(negedge clk);
        counter_enable = 1'b1;
        gpio_write_data = 8'h3C;
        tick();
        check_outputs(8'd2, 8'h3C, "both IPs update in parallel");

        @(negedge clk);
        counter_enable = 1'b0;
        gpio_write_en = 1'b0;
        gpio_write_data = 8'hFF;
        tick();
        check_outputs(8'd2, 8'h3C, "disabled IPs hold their state");

        @(negedge clk);
        rst = 1'b1;
        counter_enable = 1'b1;
        gpio_write_en = 1'b1;
        tick();
        check_outputs(8'd0, 8'h00, "reset takes priority over enables");

        @(negedge clk);
        rst = 1'b0;
        gpio_write_en = 1'b0;
        repeat (255) tick();
        check_outputs(8'd255, 8'h00, "counter reaches 255");
        tick();
        check_outputs(8'd0, 8'h00, "counter wraps to zero");

        $display("[PASS] All %0d checks succeeded.", checks);
        $finish;
    end

    initial begin
        #10000;
        $fatal(1, "[FAIL] watchdog timeout");
    end
endmodule
