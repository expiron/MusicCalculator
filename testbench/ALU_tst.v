`timescale 1 ns/ 1 ps
module ALU_tst();

	reg [7:0] ci;
	reg [7:0] numa;
	reg [7:0] numb;
	reg [2:0] opt;
	
	wire      co;
	wire[7:0] s;
	wire      zero;

	ALU inst1 (
		.opt(opt),
		.numa(numa),
		.numb(numb),
		.ci(ci),
		.s(s),
		.zero(zero),
		.co(co)
	);

	initial begin
		opt = 0;
		numa = 0;
		numb = 0;
		ci = 0;
		# 10 opt = 1;
		numa = 3;
		numb = 5;
		# 10 opt = 2;
		numa = 6;
		numb = 12;
		# 10 opt = 3;
		numa = 8'b01010101;
		numb = 8'b10101010;
		# 10 opt = 4;
		# 10 opt = 2;
		numa = 172;
		numb = 36;
		# 10 opt = 1;
		numa = 55;
		numb = 254;
		# 10 opt = 2;
		numa = -6;
		numb = 12;
		# 10 opt = 2;
		numa = -56;
		numb = -112;
		# 10 opt = 1;
	end

endmodule

