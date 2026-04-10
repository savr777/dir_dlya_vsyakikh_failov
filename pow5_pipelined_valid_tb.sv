`timescale 1ns/1ps
module pow5_pipelined_valid_tb;

    parameter DATA_WIDTH = 8;
    logic                      clk;
    logic                      rst;
    logic [DATA_WIDTH-1:0]     pow_data_i;
    logic                      data_valid_i;
    logic [(5*DATA_WIDTH)-1:0] pow_data_o;
    logic                      data_valid_o;

    pow5_pipelined_valid DUT(
        .clk_i(clk),
        .rst_i(rst),
        .pow_data_i(pow_data_i),
        .data_valid_i(data_valid_i),
        .pow_data_o(pow_data_o),
        .data_valid_o(data_valid_o)
    );

    initial begin
        clk <= 0;
        forever begin
            #5 clk <= ~clk;
        end
    end

    initial begin
        data_valid_i <= 1;
        rst <= 0;
        repeat(10) begin
            @(posedge clk);
            pow_data_i <= $urandom_range(0, 100);
            $display("time: %t; Input_value: %h Expected: %h", $time(), pow_data_i, pow_data_i**5);
        end
        // сбрасываем data_valid_i
        @(posedge clk);
        data_valid_i <= 0;
        repeat(10) begin
            @(posedge clk);
            pow_data_i <= $urandom_range(0, 100);
            $display("time: %t; Input_value: %h Expected: %h", $time(), pow_data_i, pow_data_i**5);
        end
        // устанавливаем data_valid_i
        @(posedge clk);
        data_valid_i <= 1;
        repeat(10) begin
            @(posedge clk);
            pow_data_i <= $urandom_range(0, 100);
            $display("time: %t; Input_value: %h Expected: %h", $time(), pow_data_i, pow_data_i**5);
        end
        // reset
        @(posedge clk);
        rst <= 1;
        repeat(10) begin
            @(posedge clk);
            pow_data_i <= $urandom_range(0, 100);
            $display("time: %t; Input_value: %h Expected: %h", $time(), pow_data_i, pow_data_i**5);
        end
        @(posedge clk);
        $finish();
    end

endmodule
