module Ball(
  input wire clk,         
  input wire rst,         
  input wire game_run,    
  input wire paddle_position, 
  output reg ball_out_of_bounds, 

  output reg [9:0] ball_position_x, 
  output reg [9:0] ball_position_y, 
  output wire ball_direction_x,       // (0 for left, 1 for right)
  output wire ball_direction_y,  // (0 for down, 1 for up)
  output reg display_ball
);

  parameter ball_height = 16;
  parameter ball_width = 16;
  parameter MAX_X = 640; 
  parameter MAX_Y = 480; 

  reg [9:0] velocity_x, velocity_y;

  reg [1:0] direction_x, direction_y;

  initial begin
    ball_position_x = MAX_X / 2; 
    ball_position_y = MAX_Y / 2;
    velocity_x = 4'b0100; 
    velocity_y = 4'b0100;
    direction_x = 1'b1; 
    direction_y = 1'b1;
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      ball_position_x <= MAX_X / 2;
      ball_position_y <= MAX_Y / 2;
      velocity_x <= 4'b0100;
      velocity_y <= 4'b0100;
      direction_x <= 1'b1;
      direction_y <= 1'b1;
    end else if (game_run && !ball_out_of_bounds) begin
      // Update ball position based on velocity and direction
      ball_position_x <= (direction_x == 1'b1) ? (ball_position_x + velocity_x) : (ball_position_x - velocity_x);
      ball_position_y <= (direction_y == 1'b1) ? (ball_position_y + velocity_y) : (ball_position_y - velocity_y);

      // Reflect ball off the walls
      if (ball_position_x >= MAX_X || ball_position_x <= 0) begin
        direction_x <= ~direction_x;
      end

      if (ball_position_y >= MAX_Y) begin
        ball_out_of_bounds <= 1'b1;
      end else if (ball_position_y <= 0) begin
        direction_y <= ~direction_y;
      end

      // Reflect ball off the paddle
      if (ball_position_y == 0 && ball_position_x >= paddle_position && ball_position_x <= (paddle_position + 80)) begin
        direction_y <= 1'b1;
      end
    end
  end

  // Output ball direction
  assign ball_direction_x = direction_x;
  assign ball_direction_y = direction_y;
  
always @(posedge clk)
begin
    if (game_run)
      display_ball <= 1'b1;
    else
      display_ball <= 1'b0;
end


endmodule