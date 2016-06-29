`timescale 1 ns/ 1 ps
module ALU_tst();

	parameter period = 10;

	reg       ci;
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
		opt  = 0;
		numa = 0;
		numb = 0;
		ci   = 0;
		# period;
		opt  = 1;
		numa = 3;
		numb = 5;
		# period;
		opt  = 2;
		numa = 6;
		numb = 12;
		# period;
		opt  = 3;
		numa = 8'b01010101;
		numb = 8'b10101010;
		# period;
		opt = 4;
		# period;
		opt  = 2;
		numa = 172;
		numb = 36;
		# period;
		opt  = 1;
		numa = 55;
		numb = 254;
		# period;
		opt  = 2;
		numa = -6;
		numb = 12;
		# period;
		opt  = 2;
		numa = -56;
		numb = -112;
		# period;
		opt  = 1;
		# period;
		numa = 255;
		numb = 0;
		ci   = 1;
		opt  = 1;
		# period;
		numa = 5;
		numb = 6;
		ci   = 1;
		opt  = 2;
		# period;
		numa = 3;
		numb = 172;
		ci   = 0;
		opt  = 5;
		# period;
		numa = 96;
		numb = 54;
		ci   = 0;
		opt  = 5;
		# period;
		numa = 4;
		numb = 4;
		ci   = 0;
		opt  = 5;
	end

endmodule
