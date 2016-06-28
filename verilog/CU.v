module CU(
	input            clk,
	input            reset,
	input      [3:0] num,
	input            numPressed,
	input      [2:0] opt,
	input            optPressed,
	input            submit,
	output reg [7:0] byteNum,
	output reg [1:0] nTimes
);
/* Work Frequency of the CU */
	parameter workFreq = 25000000;
/* Registers */
	integer   workCnt;
	reg       workClk;
//	reg [7:0] byteNum;
//	reg [1:0] nTimes;

	always @ (posedge numPressed or negedge reset) begin
		if(!reset) begin
			byteNum <= 0;
			nTimes <= 0;
		end
		else
			case (nTimes)
				0,1,2: begin
					byteNum <= (byteNum * 10) + {4'b0000,num};
					nTimes <= (num == 4'b0000 ? nTimes : nTimes + 1);
				end
				default: ;
			endcase
	end

/* Generate Clock */
	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			workCnt <= 0;
			workClk <= 0;
		end
		else  if (workCnt < (25000000 / workFreq - 1) / 2) begin
					workCnt <= workCnt + 1;
				end
				else begin
					workCnt <= 0;
					workClk <= ~workClk;
				end
	end
endmodule