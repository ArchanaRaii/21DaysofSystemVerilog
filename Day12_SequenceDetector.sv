// Detecting a big sequence - 1110_1101_1011
module day12 (
  input     wire        clk,
  input     wire        reset,
  input     wire        x_i,

  output    wire        det_o
);

  logic [11:0] shift;
  
  always_ff @(posedge clk or posedge reset)
    if(reset)
      shift <= 12'h0;
    else
      shift <= {shift[10:0],x_i};

      assign det_o = (shift[11:0] == 12'b1110_1101_1011);    
      
endmodule

//tb
module day12_tb ();
  logic         clk;
  logic         reset;
  logic         x_i;
  logic         det_o;

  day12 DAY12 (.*);
  
  logic [11:0] seq_i = 12'b1110_1101_1011;
  
  initial begin
    clk <= 1'b0;
    reset <= 1'b1;
    x_i <= 1'b1;
    #10;
    reset <= 1'b0;
    #10;
    for (int i=0; i<12; i=i+1) begin
      x_i <= seq_i[i];
      #10;
    end
    for (int i=0; i<12; i=i+1) begin
      x_i <= $random%2;
      #10;
    end
    $finish();
  end
  
  always #5 clk= ~clk;

endmodule
