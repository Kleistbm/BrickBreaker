module BrickBreaker (
    input wire clk,
    input wire rst,
	 input wire start,
    input wire btn_left,
    input wire btn_right,
    output wire vga_hsync,
    output wire vga_vsync,
    output wire [2:0]rgb
);
  
  
  wire Bricks;
  //reg collision;
  wire disp_ball,disp_paddle;
  wire [9:0]x_pos,y_pos;
  wire move_x,move_y;
  wire out_bounds;

 
  VGA display(clk,rst,x_pos,y_pos,vga_hsync,vga_vsync);
  
  game_state state(clk,rst,start,out_bounds,brick_clear);

  paddle paddle_inst(clk,rst,start,btn_left,btn_right,x_pos,disp_paddle);

  Ball ball_inst(clk,rst,start,paddle_pos,x_pos,y_pos,move_x,move_y,disp_ball);

  Brick brick_inst(clk,rst,x_pos,y_pos,Bricks);

  assign draw = disp_ball | disp_paddle;
  assign rgb = draw ? 3'b111 : 3'b000;

  endmodule