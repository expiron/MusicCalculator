module CU(
	input            clk,
	input            reset,
	input      [3:0] num,
	input            numPressed,
	input      [2:0] opt,
	input            optPressed,
	input            submit,
	input            control,
	output reg [3:0] num1,
	output reg [3:0] num2,
	output reg [3:0] num3,
	output reg [3:0] num4,
	output reg       sign,
	output           cmpSign,
	output           clcZero,
	output           clcCo,
	output reg       complete
);

/* Work Frequency of the CU */
	parameter workFreq = 12500000;
/* Constant of the SM */
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;
/* Registers */
	reg       erase;
	reg [3:0] state;
	reg [15:0]ans;
	reg [15:0]tmp;
	reg [15:0]optValue;
	reg [2:0] operation;
	reg [7:0] numa;
	reg [7:0] numb;
	reg       ci;
	reg       ct;
	reg       co1, co2;
	reg       zero1, zero2;
	reg [7:0] sh;
	reg [7:0] sl;
/* Wires */
	wire      workClk;
	wire[3:0] regNum1;
	wire[3:0] regNum2;
	wire[3:0] regNum3;
	wire[15:0]regValue;

	wire[7:0] s;
	wire      zero;
	wire      co;

	wire      ansSign;
	wire[3:0] ansNum1;
	wire[3:0] ansNum2;
	wire[3:0] ansNum3;
	wire[3:0] ansNum4;

	assign ctrl = reset & ~state[1] & ~state[2];
	assign cmpSign = operation[2] & operation[0] & sign;
	assign clcCo   = ctrl & (co1 | co2);
	assign clcZero = ctrl & (zero1 & zero2);

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

	ALU Alu(
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
		if (!reset)
			state <= S0;
		else
			case (state)
				S0:	if (numPressed)
							state <= S1;
						else if (optPressed)
							state <= S4;
						else if (submit)
							state <= S7;
						else
							state <= S0;
				S1:	if (optPressed)
							state <= S2;
						else
							state <= S1;
				S2:		state <= (workClk ? S3 : S2);
				S3:		state <= (workClk ? S4 : S3);
				S4:	if (numPressed)
							state <= S5;
						else
							state <= S4;
				S5:		state <= ((submit || optPressed) ? S6 : S5);
				S6:		state <= (workClk ? S7 : S6);
				S7:		state <= (workClk ? S8 : S7);
				S8:		state <= (workClk ? S9 : S8);
				S9:		state <= (!submit ? S0 : S9);
			endcase
	end

	always @ (posedge workClk or negedge reset) begin
		if (!reset)
			operation <= 0;
		else
			case (state)
				S0, S2, S3, S4:
					if (optPressed)
						operation <= opt;
				S1:	operation <= 0;
				default:;
			endcase
	end

	always @ (state) begin
		case (state)
			S3, S8:
				erase <= 1;
			default:
				erase <= 0;
		endcase
	end

	always @ (state) begin
		case (state)
			S0, S9: begin
				num1 <= ansNum1;
				num2 <= ansNum2;
				num3 <= ansNum3;
				num4 <= ansNum4;
				sign <= ansSign;
			end
			default: begin
				num1 <= 0;
				num2 <= regNum1;
				num3 <= regNum2;
				num4 <= regNum3;
				sign <= 0;
			end
		endcase
	end

	always @ (posedge workClk or negedge reset) begin
		if(!reset) begin
			ans <= 0;
//			clcCo <= 0;
//			clcZero <= 0;
		end
		else begin
			case (state)
				S2: begin
					ans <= regValue;
//					clcCo <= 0;
//					clcZero <= 0;
				end
				S9: begin
					ans <= tmp;
//					clcCo <= co1 | co2;
//					clcZero <= zero1 & zero2;
//cmpSign <= operation[2] & operation[0] & ansSign;
//					if(operation == 5)
//						cmpSign <= ansSign;
//					else
//						cmpSign <= 0;
				end
				default: begin
					ans <= ans;
				end
			endcase
		end
//		if (state == S2)
//			ans = regValue;
//		else if (state == S9)
//			ans = {sh, sl};
//		else
//			ans = ans;
	end

//	always @ (posedge workClk or negedge reset) begin
//		if (!reset) begin
//			clcCo <= 0;
//			clcZero <= 0;
//		end
//		else
//			case (state)
//				S0, S9: begin
//					clcCo <= co1 | co2;
//					clcZero <= zero1 & zero2;
//				end
//				default: begin
//					clcCo <= 0;
//					clcZero <= 0;
//				end
//			endcase
//	end

	always @ (posedge workClk) begin
		if (!reset)
			complete <= 0;
		else
			case (state)
				S0: complete <= (control ? complete : 0);
				S9: complete <= 1;
				default: complete <= 0;
			endcase
//		if(!reset)
//			complete <= 0;
//		else
//		case ({state,control,reset})
//			6'b100111: complete <= 1;
//			6'b000011: complete <= complete;
//			default: complete <= 0;
//		endcase
//		if (!reset)
//			complete <= 0;
//		else
//			if (!control)
//				complete <= 0;
//			else
//				case (state)
//					S0, S9:	complete <= 1;
//					default:	complete <= complete;
//				endcase
	end

	always @ (state or reset) begin
		if (!reset) begin
			co1 <= 0;
			co2 <= 0;
			zero1 <= 0;
			zero2 <= 0;
		end
		else
		case (state)
//			S0: begin
//				clcCo <= co1 | co2;
//				clcZero <= zero1 & zero2;
//			end
//			S1, S2, S3, S4, S5: begin
//				clcCo <= 0;
//				clcZero <= 0;
//			end
//			S0, S1, S3, S4, S5: begin
//				ans <= tmp;
//			end
//			S2:ans <= regValue;
			S6: begin
				optValue <= regValue;
			end
			S7: begin
				numa  <= ans[7:0];
				numb  <= optValue[7:0];
				ci    <= 0;
				sl    <= s;
				ct    <= co;
				zero1 <= zero;
				co1   <= co;
			end
			S8: begin
				numa  <= ans[15:8];
				numb  <= optValue[15:8];
				ci    <= ct;
				sh    <= s;
				zero2 <= zero;
				co2   <= co;
			end
			S9: begin
				tmp <= {sh, sl};
			end
//			default: begin
//				zero1 <= 0;
//				zero2 <= 0;
//				co1 <= 0;
//				co2 <= 0;
//			end
		endcase
	end

//	always @ (posedge workClk or negedge reset) begin
//		if (!reset) begin
//			state <= S0;
//			operation <= 0;
//			erase1 <= 1;
//			erase2 <= 1;
//		end
//		else case (state)
//			S0: begin
//				if (numPressed)
//					state <= S1;
//				else if (optPressed) begin
//					state <= S2;
//					operation <= opt;
//				end
//				else if (submit)
//					state <= S4;
//				else
//					state <= S0;
//				erase1 <= 0;
//			end
//			S1: begin
//				if (optPressed) begin
//					state <= S7;
//					operation <= opt;
//				end
//				else
//					state <= S1;
//			end
//			S2: begin
//				if (numPressed) begin
//					state <= S3;
//				end
//				else if (optPressed) begin
//					state <= S2;
//					operation <= opt;
//				end
//				erase2 <= 0;
//			end
//			S3:
//				state <= ((submit || optPressed) ? S4 : S3);
//			S4:
//				state <= (workClk ? S5 : S4);
//			S5:
//				state <= (workClk ? S6 : S5);
//			S6: begin
//				state <= (!submit ? S0 : S6);
//				erase1 <= 1;
//				erase2 <= 1;
//			end
//			S7: begin
//				state <= (workClk ? S8 : S7);
//			end
//			S8: begin
//				state <= (workClk ? S2 : S8);
//				erase1 <= 1;
//			end
//		endcase
//	end

//	always @ (state) begin
//		case (state)
//			S0, S6: begin
//				num1 <= ansNum1;
//				num2 <= ansNum2;
//				num3 <= ansNum3;
//				num4 <= ansNum4;
//				sign <= ansSign;
//			end
//			S1, S7, S8: begin
//				num1 <= 0;
//				num2 <= regNum11;
//				num3 <= regNum12;
//				num4 <= regNum13;
//				sign <= 0;
//			end
//			S2, S3, S4, S5: begin
//				num1 <= 0;
//				num2 <= regNum21;
//				num3 <= regNum22;
//				num4 <= regNum23;
//				sign <= 0;
//			end
//		endcase
//	end
//	
//	always @ (state or reset) begin
//		if (!reset) begin
//			ans <= 0;
//			clcZero <= 0;
//			clcCo <= 0;
//		end
//		else
//			case (state)
//				S0: begin
//				end
//				S1: begin
//					clcCo <= 0;
//					clcZero <= 0;
//				end
//				S2: begin
//					clcCo <= 0;
//					clcZero <= 0;
//					//ans <= regValue1;
//				end
//				S4: begin
//					optValue <= regValue2;
//					numa <= ans[7:0];
//					numb <= optValue[7:0];
//					ci <= 0;
//					sl <= s;
//					ct <= co;
//					zero1 <= zero;
//					co1 <= co;
//				end
//				S5: begin
//					numa <= ans[15:8];
//					numb <= optValue[15:8];
//					ci <= ct;
//					sh <= s;
//					zero2 <= zero;
//					co2 <= co;
//				end
//				S6: begin
//					ans <= {sh, sl};
//					clcZero <= zero1 & zero2;
//					clcCo <= co1 | co2;
//				end
//				S7: begin
//					ans <= regValue1;
//				end
//			endcase
//	end
//
//	always @ (state or reset) begin
//		if (!reset)
//			cmpSign <= 0;
//		else
//			case (state)
//				S0, S6:
//					if(operation == 5)
//						cmpSign <= ans[15];
//					else
//						cmpSign <= 0;
//				S1, S2, S3, S4, S5:
//					cmpSign <= 0;
//			endcase
//	end

endmodule
