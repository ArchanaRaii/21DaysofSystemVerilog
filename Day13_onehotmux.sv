// Various ways to implement a mux

module day13 (
  input     wire[3:0] a_i,
  input     wire[3:0] sel_i,

  // Output using ternary operator
  output    wire     y_ter_o,
  // Output using case
  output    logic     y_case_o,
  // Ouput using if-else
  output    logic     y_ifelse_o,
  // Output using for loop
  output    logic     y_loop_o,
  // Output using and-or tree
  output    logic     y_aor_o
);

  always_comb begin
    case(sel_i)
      4'b0001 : y_case_o = a_i[0];
      4'b0010 : y_case_o = a_i[1];
      4'b0100 : y_case_o = a_i[2];
      4'b1000 : y_case_o = a_i[3];
      default : y_case_o = 1'bx;
    endcase
  end

  always_comb begin
    if(sel_i[0]) y_ifelse_o = a_i[0];
    else if(sel_i[1]) y_ifelse_o = a_i[1];
    else if(sel_i[2]) y_ifelse_o = a_i[2];
    else if(sel_i[3]) y_ifelse_o = a_i[3];
    else y_ifelse_o = 1'bx;
  end
  
  always_comb begin
    y_loop_o = 1'b0;
    for(int i = 0; i < 4; i++) begin
      y_loop_o = sel_i[i] & a_i[i] | y_loop_o;
    end
  end
  
  assign y_aor_o = (sel_i[0] & a_i[0]) |
                   (sel_i[1] & a_i[1]) |
                   (sel_i[2] & a_i[2]) |
                   (sel_i[3] & a_i[3]);
  
  assign y_ter_o = sel_i[0] ? a_i[0] :
                   sel_i[1] ? a_i[1] :
                   sel_i[2] ? a_i[2] :
                              a_i[3];
  
endmodule

// Simple TB

module day13_tb ();

	logic [3:0] a_i;
  logic [3:0] sel_i;
  logic     y_ter_o;
  logic     y_case_o;
  logic     y_ifelse_o;
  logic     y_loop_o;
  logic     y_aor_o;

  
  day13 DAY13 (.*);
  
  initial begin
    for(int i = 0; i < 16; i++) begin
      a_i   = $urandom_range(0, 4'hF);
      sel_i = 1'b1 << $urandom_range(0, 2'h3);
      #5;
    end
    #20 $finish();
  end

endmodule
