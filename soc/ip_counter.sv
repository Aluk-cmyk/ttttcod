// Git-IP joint acceptance 20260916: Counter source changed
`timescale 1ns/1ps

// Counter IP: synchronous active-high reset; enable-controlled 8-bit count.
module ip_counter (
    input  logic       clk,
    input  logic       rst,
    input  logic       enable,
    output logic [7:0] count
);
    always_ff @(posedge clk) begin
        if (rst)
            count <= 8'd0;
        else if (enable)
            count <= count + 8'd1;
    end
endmodule
