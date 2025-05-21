// Priority arbiter
// port[0] - highest priority

module day14 #(
  parameter NUM_PORTS = 4
)(
    input       wire[NUM_PORTS-1:0] req_i,
    output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
);

  genvar i;
  for (i=1; i<NUM_PORTS; i=i+1) begin
    assign gnt_o[i] = req_i[i] & ~(|gnt_o[i-1:0]);
  end
  
    assign gnt_o[0] = req_i[0];

  
endmodule

//tb
module day14_tb ();

  localparam NUM_PORTS = 8;

  logic[NUM_PORTS-1:0] req_i;
  logic[NUM_PORTS-1:0] gnt_o;

  day14 #(NUM_PORTS) DAY14 (.*);

  initial begin
    for (int i=0; i<32; i=i+1) begin
      req_i = $urandom_range(0, 2**NUM_PORTS-1);
      #5;
    end
  end

endmodule
