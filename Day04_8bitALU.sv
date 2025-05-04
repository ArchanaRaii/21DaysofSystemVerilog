//8bit alu code
// A simple ALU

module day4 (
  input     logic [7:0]   a_i,
  input     logic [7:0]   b_i,
  input     logic [2:0]   op_i,

  output    logic [7:0]   alu_o
);
  
  
  localparam  OP_ADD = 3'b000;
  localparam  OP_SUB = 3'b001;
  localparam  OP_SLL = 3'b010;
  localparam  OP_LSR = 3'b011;
  localparam  OP_AND = 3'b100;
  localparam  OP_OR  = 3'b101;
  localparam  OP_XOR = 3'b110;
  localparam  OP_EQL = 3'b111; 

 initial begin
   case(op_i)
			OP_ADD: alu_o = a_i + b_i;
	   	OP_SUB: alu_o = a_i - b_i;
     	OP_SLL: alu_o = a_i[7:0] <<  b_i[2:0];
     	OP_LSR: alu_o = a_i[7:0] >>  b_i[2:0];
      OP_AND: alu_o = a_i & b_i;
      OP_OR:  alu_o = a_i | b_i;
      OP_XOR: alu_o = a_i ^ b_i;
      OP_EQL: alu_o = {7'h0, a_i == b_i};
   endcase
 end

endmodule

//8bit alu tb

module day4_tb ();

  logic [7:0] a_i;
  logic [7:0] b_i;
  logic [2:0] op_i;
  logic [7:0] alu_o;

  day4 dut(.a_i(a_i),
           .b_i(b_i),
           .op_i(op_i),
           .alu_o(alu_o)
          );
  
 
  initial begin
    for(int i = 0; i < 7; i++) begin
      a_i = $urandom_range(0 , 8'hFF);
      b_i = $urandom_range(0 , 8'hFF);
    end
  end
  
  always #5 op_i = op_i + 1;

endmodule
