module CU(
	input            clk,
	input            reset,
	input      [3:0] num,
	input            numPressed,
	input      [2:0] opt,
	input            optPressed,
	input            submit,
	output reg [3:0] num1,
	output reg [3:0] num2,
	output reg [3:0] num3,
	output reg [3:0] num4,
	output reg       sign,
	output reg       cmpSign,
	output reg       clcZero,
	output reg       clcCo
	//output           workClk
);

/* Work Frequency of the CU */
	parameter workFreq = 12500000;
/* Constant of the SM */
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;
/* Registers */
	reg       erase;
	reg [2:0] state;
	reg [2:0] operation;
	reg [7:0] numa;
	reg [7:0] numb;
	reg       ci;
	reg       ct;
	reg       co1, co2;
	reg       zero1, zero2;
	reg [7:0] sh;
	reg [7:0] sl;
	reg [15:0]ans;
/* Wires */
	wire      workClk;
	wire[3:0] regNum1;
	wire[3:0] regNum2;
	wire[3:0] regNum3;
	wire[15:0]regValue;
	wire      ansSign;
	wire[3:0] ansNum1;
	wire[3:0] ansNum2;
	wire[3:0] ansNum3;
	wire[3:0] ansNum4;
	wire[7:0] s;
	wire      zero;
	wire      co;

	FrequencyDivider # (.divFreq(workFreq)) freDiv(
		.clk(clk),
		.reset(reset),
		.divClk(workClk)
	);

	InputRegister inputRegister(
		.reset(reset),
		.erase(erase),
		.num(num),
		.numPressed(numPressed),
		.num1(regNum1),
		.num2(regNum2),
		.num3(regNum3),
		.value(regValue)
	);

	ALU alu(
		.opt(operation),
		.numa(numa),
		.numb(numb),
		.ci(ci),
		.s(s),
		.zero(zero),
		.co(co)
	);

	AnsDecoder ansDecoder(
		.ans(ans),
		.sign(ansSign),
		.num1(ansNum1),
		.num2(ansNum2),
		.num3(ansNum3),
		.num4(ansNum4)
	);

/* ControlUnit State Machine */
	always @ (posedge workClk or negedge reset) begin
		if (!reset) begin
			state <= S0;
			operation <= 0;
			erase <= 1;
		end
		else case (state)
			S0: begin
				if (optPressed) begin
					state <= S1;
					operation <= opt;
				end
				else if (submit)
					state <= S3;
				else
					state <= S0;
				erase <= 0;
			end
			S1:
				if (numPressed)
					state <= S2;
				else if (optPressed) begin
					state <= S1;
					operation <= opt;
				end
			S2:
				state <= ((submit || optPressed) ? S3 : S2);
			S3:
				state <= (workClk ? S4 : S3);
				//state <= S4;
			S4:
				state <= (workClk ? S5 : S4);
				//state <= S5;
			S5: begin
				state <= (!submit ? S0 : S5);
				erase <= 1;
			end
		endcase
	end

	always @ (state) begin
		case (state)
			S0, S1, S5: begin
				num1 <= ansNum1;
				num2 <= ansNum2;
				num3 <= ansNum3;
				num4 <= ansNum4;
				sign <= ansSign;
			end
			S2, S3, S4: begin
				num1 <= 0;
				num2 <= regNum1;
				num3 <= regNum2;
				num4 <= regNum3;
				sign <= 0;
			end
		endcase
	end
	
	always @ (state or reset) begin
		if (!reset) begin
			ans <= 0;
			cmpSign <= 0;
			clcZero <= 0;
			clcCo <= 0;
		end
		else
			case (state)
				S0: begin
					if (opt == 5)
						cmpSign <= ans[15];
					else
						cmpSign <= 0;
				end
				S1: begin
					clcCo <= 0;
					clcZero <= 0;
				end
				S2: begin
					clcCo <= 0;
					clcZero <= 0;
				end
				S3: begin
					numa <= ans[7:0];
					numb <= regValue[7:0];
					ci <= 0;
					sl <= s;
					ct <= co;
					zero1 <= zero;
					co1 <= co;
				end
				S4: begin
					numa <= ans[15:8];
					numb <= regValue[15:8];
					ci <= ct;
					sh <= s;
					zero2 <= zero;
					co2 <= co;
				end
				S5: begin
					ans <= {sh, sl};
					clcZero <= zero1 & zero2;
					clcCo <= co1 | co2;
				end
			endcase
	end

endmodule
