`timescale 1 ns/ 1 ps
module CU_tst();

	parameter period = 20;

	reg clk;
	reg [3:0] num;
	reg numPressed;
	reg [2:0] opt;
	reg optPressed;
	reg reset;
	reg submit;

	wire clcCo;
	wire clcZero;
	wire cmpSign;
	wire [3:0]  num1;
	wire [3:0]  num2;
	wire [3:0]  num3;
	wire [3:0]  num4;
	wire sign;

	CU inst1 (
		.clcCo(clcCo),
		.clcZero(clcZero),
		.clk(clk),
		.cmpSign(cmpSign),
		.num(num),
		.num1(num1),
		.num2(num2),
		.num3(num3),
		.num4(num4),
		.numPressed(numPressed),
		.opt(opt),
		.optPressed(optPressed),
		.reset(reset),
		.sign(sign),
		.submit(submit)
	);

	task PressNum;
		input [3:0]innum;
		input [3:0]pt;
		begin
			#(period / 2);
			num = innum;
			numPressed = 1;
			# period;
			num = 0;
			numPressed = 0;
			#(period / 2);
		end
	endtask

		task PressOpt;
		input [3:0]inopt;
		input [3:0]pt;
		begin
			#(period / 2);
			opt = inopt;
			optPressed = 1;
			# period;
			opt = 0;
			optPressed = 0;
			#(period / 2);
		end
	endtask

		task PressSubmit;
		begin
			#(period / 2);
			submit = 1;
			# period;
			submit = 0;
			#(period / 2);
		end
	endtask

	initial begin
		clk = 0;
		reset = 0;
		num = 0;
		numPressed = 0;
		opt = 0;
		optPressed = 0;
		submit = 0;
		# period;
		reset = 1;
	end

	initial begin
		#(period * 4);
		PressOpt(1,1);
		PressNum(3,2);
		PressSubmit();
		#(period * 5);
		PressOpt(2,1);
		PressNum(1,1);
		PressNum(2,1);
		PressNum(3,1);
		PressNum(4,1);
		PressSubmit();
	end

	always # 5 clk = ~clk;

endmodule
