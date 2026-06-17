/*
 * Copyright (c) 2024 Josue Olivos
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_josue_olivos_alu (
    input  wire [7:0] ui_in,    
    output wire [7:0] uo_out,   
    input  wire [7:0] uio_in,   
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       ena,      
    input  wire       clk,      
    input  wire       rst_n     
);

  wire [3:0] a;
  wire [3:0] b;
  wire [2:0] opcode;

  reg  [3:0] result;
  reg        carry_out;
  wire       zero_flag;

  assign a = ui_in[3:0];
  assign b = ui_in[7:4];
  assign opcode = uio_in[2:0];

  assign zero_flag = (result == 4'b0000);

  always @(*) begin
    result = 4'b0000;
    carry_out = 1'b0;

    case (opcode)
      3'b000: begin
        {carry_out, result} = a + b;
      end

      3'b001: begin
        {carry_out, result} = a - b;
      end

      3'b010: begin
        result = a & b;
      end

      3'b011: begin
        result = a | b;
      end

      3'b100: begin
        result = a ^ b;
      end

      3'b101: begin
        result = ~a;
      end

      3'b110: begin
        result = a << 1;
      end

      3'b111: begin
        result = a >> 1;
      end

      default: begin
        result = 4'b0000;
        carry_out = 1'b0;
      end
    endcase
  end

  assign uo_out[3:0] = result;
  assign uo_out[4]   = carry_out;
  assign uo_out[5]   = zero_flag;
  assign uo_out[6]   = 1'b0;
  assign uo_out[7]   = 1'b0;

  assign uio_out = 8'b0000_0000;
  assign uio_oe  = 8'b0000_0000;

  wire _unused = &{ena, clk, rst_n, uio_in[7:3], 1'b0};

endmodule
