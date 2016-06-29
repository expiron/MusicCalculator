`timescale 1 ns/ 1 ps
module AnsDecoder_tst();

	parameter period = 10;

	reg [15:0] ans;

	wire [3:0]  num1;
	wire [3:0]  num2;
	wire [3:0]  num3;
	wire [3:0]  num4;
	wire sign;

	AnsDecoder inst1 (
		.ans(ans),
		.sign(sign),
		.num1(num1),
		.num2(num2),
		.num3(num3),
		.num4(num4)
	);

	initial begin
		ans = 0;
		# period;
		ans = 255;
		# period;
		ans = 65535;
		# period;
		ans = 32768;
		# period;
		ans = 387;
		# period;
		ans = 12345;
	end

endmodule

