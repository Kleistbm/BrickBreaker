module paddle(  
  input wire clk,              
  input wire rst, 
  input wire game_run,  
  input wire left_button,      
  input wire right_button,
  output wire [9:0] paddle_position, 
  output reg display_paddle 
);

  parameter HEIGHT = 16;
  parameter WIDTH = 80;          
  parameter MAX_POS = 640-WIDTH;     

  reg [WIDTH-1:0] position;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      position <= (MAX_POS-WIDTH) / 2; // Initial position at the center
    end else begin
      if (left_button && (position > 0)) begin
        position <= position - 2; // Move left
      end
      if (right_button && (position < MAX_POS)) begin
        position <= position + 2; // Move right
      end
    end
  end

  assign paddle_position = position;
  
always @(posedge clk)
begin
    if (game_run)
      display_paddle <= 1'b1;
    else
      display_paddle <= 1'b0;
end


endmodule