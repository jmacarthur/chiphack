/******************************************************************************
*                                                                             *
* Copyright 2016 myStorm Copyright and related                                *
* rights are licensed under the Solderpad Hardware License, Version 0.51      *
* (the “License”); you may not use this file except in compliance with        *
* the License. You may obtain a copy of the License at                        *
* http://solderpad.org/licenses/SHL-0.51. Unless required by applicable       *
* law or agreed to in writing, software, hardware and materials               *
* distributed under this License is distributed on an “AS IS” BASIS,          *
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or             *
* implied. See the License for the specific language governing                *
* permissions and limitations under the License.                              *
*                                                                             *
******************************************************************************/

module chip (
    // 100MHz clock input
    input  clk,
    // SRAM Memory lines
    output [18:0] ADR,
    output [15:0] DAT,
    output RAMOE,
    output RAMWE,
    output RAMCS,
    // All PMOD outputs
    output [55:0] PMOD,
    input [1:0] BUT,
    input [3:0] DIP
  );

  // SRAM signals are not use in this design, lets set them to default values
  assign ADR[18:0] = {19{1'b0}};
  assign DAT[15:0] = {16{1'b0}};
  assign RAMOE = 1'b1;
  assign RAMWE = 1'b1;
  assign RAMCS = 1'b1;

  // Set unused pmod pins to default
  assign PMOD[54:9] = {55{1'b0}};

  display my_display(
    .clk   (clk),
    .red (PMOD[0]),
		     .green (PMOD[1]),
		     .addr0 (PMOD[3]),
		     .addr1 (PMOD[2]),
		     .addr2 (PMOD[5]),
		     .addr4 (PMOD[4]),
		     .latch (PMOD[6]),
		     .step (PMOD[7]),
		     .debug_led (PMOD[55]),
		     .output_enable (PMOD[8]));

endmodule
