module VGA(
  input wire clk,             
  input wire rst,             
  input wire [9:0] x_position, 
  input wire [9:0] y_position, 
  output wire h_sync,         
  output wire v_sync,        
  output reg [2:0] color 
);

  parameter H_SYNC_CYCLES = 96;  
  parameter H_BACK_PORCH = 48;  
  parameter H_ACTIVE = 640;     
  parameter H_FRONT_PORCH = 16; 
  parameter V_SYNC_LINES = 2;   
  parameter V_BACK_PORCH = 33;  
  parameter V_ACTIVE = 480;     
  parameter V_FRONT_PORCH = 10; 


  reg [11:0] h_counter, v_counter;
  reg h_sync_reg, v_sync_reg;


  reg [9:0] x_pos_sync, y_pos_sync;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      h_counter <= 12'b0;
      v_counter <= 12'b0;
      h_sync_reg <= 1'b0;
      v_sync_reg <= 1'b0;
      x_pos_sync <= 10'b0;
      y_pos_sync <= 10'b0;
    end else begin
      x_pos_sync <= x_position;
      y_pos_sync <= y_position;

      if (h_counter == H_SYNC_CYCLES + H_BACK_PORCH + H_ACTIVE + H_FRONT_PORCH - 1) begin
        h_counter <= 12'b0;
        h_sync_reg <= 1'b1;
      end else if (h_counter == H_SYNC_CYCLES + H_BACK_PORCH - 1) begin
        h_sync_reg <= 1'b0;
      end else begin
        h_counter <= h_counter + 1;
      end

      if (v_counter == V_SYNC_LINES + V_BACK_PORCH + V_ACTIVE + V_FRONT_PORCH - 1) begin
        v_counter <= 12'b0;
        v_sync_reg <= 1'b1;
      end else if (v_counter == V_SYNC_LINES + V_BACK_PORCH - 1) begin
        v_sync_reg <= 1'b0;
      end else begin
        v_counter <= v_counter + 1;
      end
    end
  end

  assign h_sync = h_sync_reg;
  assign v_sync = v_sync_reg;

  // RGB color output
  always @* begin
    case ({h_counter, v_counter})
      12'h0F0: color = 3'b111; // White
      12'h0FF: color = 3'b001; // Blue
      12'h1F0: color = 3'b010; // Green
      12'h1FF: color = 3'b011; // Cyan
      12'h2F0: color = 3'b100; // Red
      12'h2FF: color = 3'b101; // Magenta
      12'h3F0: color = 3'b110; // Yellow
      default: color = 3'b000; // Black (default)
    endcase
  end

endmodule