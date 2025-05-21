// Counter with a load
module day10 (
  input     wire          clk,
  input     wire          reset,
  input     wire          load_i,
  input     wire[3:0]     load_val_i,

  output    wire[3:0]     count_o
);

    logic [3:0] count;              
    logic [3:0] reload_val;            

    always @(posedge clk or posedge reset) begin
        if (reset) 
          begin
            count  <= 4'h0;
            reload_val <= 4'h0;
        	end 
      	else 
          begin
            if (load_i) reload_val <= load_val_i;  

            if (count == 4'hF) count <= reload_val;    
            else count <= count + 4'h1;
        	end
    end

    assign count_o = count;

  
endmodule

//tb
module day10_tb ();

  logic          clk;
  logic          reset;
  logic          load_i;
  logic[3:0]     load_val_i;

  logic[3:0]     count_o;

  day10 DAY10 (.*);


  initial clk = 0;
    always #5 clk = ~clk;

  
    initial begin
        reset = 1;
        load_i = 0;
        load_val_i = 4'h0;
        #10;
        reset = 0;
        #50;
        load_val_i = $urandom_range(0, 4'hF);
        load_i = 1;
        #10;
        load_i = 0;
        #200;
        load_val_i = $urandom_range(0, 4'hF);
        load_i = 1;
        #10;
        load_i = 0;
        #200;
        $finish;
    end

endmodule
