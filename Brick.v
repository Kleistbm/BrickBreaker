module Brick(
  input wire clk,                 
  input wire rst,
  input wire ball_x,ball_y,  
  output wire [7:0] brick_rows  
         
);


  parameter HEIGHT = 20;
  parameter WIDTH = 80;
  parameter BRICKS_PER_ROW = 8;    
  parameter NUM_BRICK_ROWS = 4;    

  reg brick_collision;
  reg [7:0] bricks;                 
  reg [3:0] brick_positions_x [NUM_BRICK_ROWS-1:0]; 
  reg [3:0] brick_positions_y [NUM_BRICK_ROWS-1:0]; 
  reg i;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for ( i = 0; i < NUM_BRICK_ROWS; i = i + 1) begin
        brick_positions_x[i] <= i * WIDTH; 
        brick_positions_y[i] <= 0;     
      end
      
      bricks <= {BRICKS_PER_ROW{1'b1}};
      brick_collision <= 1'b0;
    end else begin
      brick_collision <= 0; // Reset collision flag

      

      for ( i = 0; i < NUM_BRICK_ROWS; i = i + 1) begin
        if (ball_x == brick_positions_x[i] && ball_y == brick_positions_y[i]) begin
          // Collision detected
          bricks[i * BRICKS_PER_ROW + (ball_x / 2)] <= 1'b0; 
          brick_collision <= 1; 
      end
		end
    end
  end

  // Output brick rows
  assign brick_rows = bricks;

endmodule