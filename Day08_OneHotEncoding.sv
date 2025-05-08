// Binary to one-hot

module day8#(
  parameter BIN_W       = 4,
  parameter ONE_HOT_W   = 16
)(
  input   wire[BIN_W-1:0]     bin_i,
  output  wire[ONE_HOT_W-1:0] one_hot_o
);

  assign one_hot_o = 1'b1 << bin_i;
  
endmodule

//tb
module day8_tb();

  localparam BIN_W = 4;
  localparam ONE_HOT_W = 16;

  logic [BIN_W-1:0] bin_i;
  logic [ONE_HOT_W-1:0] one_hot_o;

  day8 #(BIN_W, ONE_HOT_W) DAY8 (.*);
  
  
  initial begin
    for(int i=0; i<32; i=i+1) begin
      bin_i = $urandom_range(0, 4'hF);
      #10;
    end
    #20 $finish();
  end

endmodule
