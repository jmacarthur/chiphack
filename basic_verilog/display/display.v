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

module display(input clk, 
	       output red, output green,
	       output addr0, output addr1, output addr2, output addr4,
	       output latch, output step, output debug_led,
	       output output_enable);

   reg [28:0] 	      clock_divider = 0;
   reg [1:0] 	      stage = 0;
   reg [31:0] 	      pattern1[15:0];
   reg [31:0] 	      rotate = 0;
	      
   initial $readmemb("display/contents.txt", pattern1);
   
   reg [5:0] 	      x = 0;
   reg [3:0] 	      row = 0;
 	      
   always @(posedge clk)
     clock_divider <= clock_divider + 1;

   always @(posedge clock_divider[4]) begin
      stage <= stage + 1;
      case(stage)
	0: begin
	   if(x >= 32) begin
	      output_enable <= 0;
	   end
	   else begin
	      output_enable <= 1;
	   end
	   if(x == 63) begin
	      row <= row +1;
	   end
	   x <= x + 1;
	   latch <= 0;	   
	   red <= pattern1[row][x+rotate];
	   green <= pattern1[row][x+rotate+8];
	   latch <= 0;
	   step <= 0;
	   debug_led <= 1;
	end
	1: begin
	   if(x<32) begin
	   latch <= 1;
	   step <= 0;
	   debug_led <= 0;
	      end
	end
	2: begin
	   if(x<32) begin
	      step <= 1;
	   end else begin
	     step <= 0;

	   end
	      latch <= 0;	   
	      debug_led <= 0;
	   end
	3: begin
	   latch <= 0;	   
	   step <= 0;
	   debug_led <= 0;
	end
      endcase // case (stage)

   end

   always @(posedge clock_divider[19]) begin
      if(row == 0 && x == 0) begin
	 rotate <= rotate + 1;
      end
   end

   
   assign addr0 = row[0];
   assign addr1 = row[1];
   assign addr2 = row[2];
   assign addr4 = row[3];
   
endmodule
