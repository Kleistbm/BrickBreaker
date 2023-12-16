module game_state(
  input wire clk,         
  input wire rst,         
  input wire start_game,  
  
  input wire ball_out_of_bounds, // Signal indicating the ball is out of bounds
  output reg all_bricks_cleared  // Signal indicating all bricks are cleared
    
);

  parameter IDLE_STATE = 2'b00;
  parameter RUN_STATE = 2'b01;
  parameter WON_STATE = 2'b10;
  parameter LOSS_STATE = 2'b11;

  reg [1:0] S;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      S <= IDLE_STATE;
    end else begin

      case (S)
        IDLE_STATE: begin
          if (start_game) begin
            S <= RUN_STATE; // Transition to game run state on start
          end else begin
            S <= IDLE_STATE; // Stay in idle state
          end
        end

        RUN_STATE: begin
          if (all_bricks_cleared) begin
            S <= WON_STATE; // Transition to game won state
          end else if (ball_out_of_bounds) begin
            S <= LOSS_STATE; // Transition to game loss state
          end else begin
            S <= RUN_STATE; // Stay in game run state
          end
        end

        WON_STATE, LOSS_STATE: begin
          // Game is won or lost, reset to idle state on the next start
          S <= IDLE_STATE;
        end
      endcase
    end
  end


endmodule