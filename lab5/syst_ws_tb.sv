module syst_ws_tb;

    logic clk;
    logic rst;

    logic [7:0] x1_i;
    logic [7:0] x2_i;
    logic [7:0] x3_i;

    logic [18:0] y1_o;
    logic [18:0] y2_o;

    syst_ws DUT (
      .clk_i(clk),
      .rst_i(rst),
      .x1_i(x1_i),
      .x2_i(x2_i),
      .x3_i(x3_i),
      .y1_o(y1_o),
      .y2_o(y2_o),
    )

    initial begin
        clk <= 0;
        forever begin
            #5 clk <= ~clk;
        end
    end

    initial begin
        rst <= 0;
        repeat(10) begin
            @(posedge clk);
            x1_i <= $urandom_range(0, 100);
            x2_i <= $urandom_range(0, 100);
            x3_i <= $urandom_range(0, 100);
        end
        // reset
        @(posedge clk);
        rst <= 1;
        repeat(10) begin
            x1_i <= $urandom_range(0, 100);
            x2_i <= $urandom_range(0, 100);
            x3_i <= $urandom_range(0, 100);
            @(posedge clk);
        end
        @(posedge clk);
        $finish();
    end

endmodule