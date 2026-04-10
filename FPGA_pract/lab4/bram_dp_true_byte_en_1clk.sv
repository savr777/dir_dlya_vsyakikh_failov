module bram_dp_true_byte_en_1clk
#(
  parameter NB_COL = 4,
  parameter COL_WIDTH = 8,
  parameter RAM_ADDR_BITS = 10
)
(
  input  logic                          clk_i,
  input  logic [RAM_ADDR_BITS-1:0]      addr_a_i,
  input  logic [RAM_ADDR_BITS-1:0]      addr_b_i,
  input  logic [(NB_COL*COL_WIDTH)-1:0] data_a_i,
  input  logic [(NB_COL*COL_WIDTH)-1:0] data_b_i,
  input  logic [NB_COL-1:0]             we_a_i,
  input  logic [NB_COL-1:0]             we_b_i,
  input  logic                          en_a_i,
  input  logic                          en_b_i,
  output logic [(NB_COL*COL_WIDTH)-1:0] data_a_o,
  output logic [(NB_COL*COL_WIDTH)-1:0] data_b_o
);

  localparam RAM_DEPTH = 2**RAM_ADDR_BITS;

  logic [(NB_COL*COL_WIDTH)-1:0] bram [RAM_DEPTH-1:0];
  logic [(NB_COL*COL_WIDTH)-1:0] ram_data_a_ff;
  logic [(NB_COL*COL_WIDTH)-1:0] ram_data_b_ff;

  always_ff @(posedge clk_i) begin
    if (en_a_i)
      ram_data_a_ff <= bram[addr_a_i];
  end

  always_ff @(posedge clk_i) begin
    if (en_b_i)
      ram_data_b_ff <= bram[addr_b_i];
  end

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write_a
       always_ff @(posedge clk_i)
         if (!((addr_a_i == addr_b_i) && we_a_i[i] && we_b_i[i])) begin
           if (en_a_i)
             if (we_a_i[i])
               bram[addr_a_i][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= data_a_i[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
           if (en_b_i)
             if (we_b_i[i])
               bram[addr_b_i][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= data_b_i[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
         end
      end
  endgenerate

  assign data_a_o = ram_data_a_ff;
  assign data_b_o = ram_data_b_ff;

endmodule
