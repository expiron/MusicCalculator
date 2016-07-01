module MusicBuzz(
	input            clk,
	input            reset,
	input            control,
	input            complete,
	input            sign,
	output reg       buzz
);

	//integer   cnt;
	reg [15:0]divCnt;
	reg [15:0]origin;
	reg       co;
	reg [15:0] cnt;
	reg [3:0] high,med,low;
	reg       play;
	reg       played;
	reg       state;

	wire      clk_4hz;
	wire      clk_6mhz;

	FrequencyDivider # (.divFreq(4)) freDiv1(
		.clk(clk),
		.reset(reset),
		.divClk(clk_4hz)
	);

	FrequencyDivider # (.divFreq(6000000)) freDiv2(
		.clk(clk),
		.reset(reset),
		.divClk(clk_6mhz)
	);

	always @ (posedge clk_6mhz) begin
		if (divCnt == 16383) begin
			co <= 1;
			divCnt <= origin;
		end
		else begin
			divCnt <= divCnt + 1;
			co <= 0;
		end
	end

	always @ (posedge clk_6mhz) begin
		case ({control,complete,played})
			3'b100:	play <= 0;
			3'b101:	play <= 0;
			3'b110:	play <= 1;
			3'b111:	play <= 0;
			default:	play <= 0;
		endcase
	end

	always @ (posedge co) begin
		if (play)
			buzz <= ~buzz;
		else
			buzz <= 1;
	end

	always @ (posedge clk_4hz) begin
		case ({high,med,low})
			'h001:	origin <= 4915;		'h002:	origin <= 6168;
			'h003:	origin <= 7281;		'h004:	origin <= 7792;
			'h005:	origin <= 8730;		'h006:	origin <= 9565;
			'h007:	origin <= 10310;		'h010:	origin <= 10647;
			'h020:	origin <= 11272;		'h030:	origin <= 11831;
			'h040:	origin <= 12094;		'h050:	origin <= 12556;
			'h060:	origin <= 12974;		'h070:	origin <= 13346;
			'h100:	origin <= 13516;		'h200:	origin <= 13829;
			'h300:	origin <= 14109;		'h400:	origin <= 14235;
			'h500:	origin <= 14470;		'h600:	origin <= 14678;
			'h700:	origin <= 14864;		'h000:	origin <= 16383;
		endcase
	end

//	always @ (posedge complete or posedge played) begin
//		case ({control,played})
//			4'b00:	play <= 0;
//			4'b01:	play <= 0;
//			4'b10:	play <= 1;
//			4'b11:	play <= 0;
//		endcase
//	end

	always @ (posedge clk_4hz or negedge reset) begin
		if (!reset) begin
			cnt <= 29;
			{high,med,low} <= 'h000;
		end
		else begin
			if(play) begin
				if (cnt == 30)
					played <= 1;
				cnt <= cnt + 1;
					//if (sign == 1)
				case ({sign,cnt})
					'h00000:	{high,med,low} <= 'h500;
					'h00001:	{high,med,low} <= 'h500;
					'h00002:	{high,med,low} <= 'h300;
					'h00003:	{high,med,low} <= 'h400;
					'h00004:	{high,med,low} <= 'h500;
					'h00005:	{high,med,low} <= 'h500;
					'h00006:	{high,med,low} <= 'h300;
					'h00007:	{high,med,low} <= 'h400;
					'h00008:	{high,med,low} <= 'h500;
					'h00009:	{high,med,low} <= 'h050;
					'h0000a:	{high,med,low} <= 'h060;
					'h0000b:	{high,med,low} <= 'h070;
					'h0000c:	{high,med,low} <= 'h100;
					'h0000d:	{high,med,low} <= 'h200;
					'h0000e:	{high,med,low} <= 'h300;
					'h0000f:	{high,med,low} <= 'h400;
					'h00010:	{high,med,low} <= 'h300;
					'h00011:	{high,med,low} <= 'h300;
					'h00012:	{high,med,low} <= 'h100;
					'h00013:	{high,med,low} <= 'h200;
					'h00014:	{high,med,low} <= 'h300;
					'h00015:	{high,med,low} <= 'h030;
					'h00016:	{high,med,low} <= 'h040;
					'h00017:	{high,med,low} <= 'h050;
					'h00018:	{high,med,low} <= 'h060;
					'h00019:	{high,med,low} <= 'h050;
					'h0001a:	{high,med,low} <= 'h040;
					'h0001b:	{high,med,low} <= 'h050;
					'h0001c:	{high,med,low} <= 'h030;
					'h0001d:	{high,med,low} <= 'h040;
					'h0001e:	{high,med,low} <= 'h050;
					'h0001f:	{high,med,low} <= 'h040;
					'h00020:	{high,med,low} <= 'h040;
					'h00021:	{high,med,low} <= 'h060;
					'h10000:	{high,med,low} <= 'h100;
					'h10001:	{high,med,low} <= 'h100;
					'h10002:	{high,med,low} <= 'h100;
					'h10003:	{high,med,low} <= 'h100;
					'h10004:	{high,med,low} <= 'h500;
					'h10005:	{high,med,low} <= 'h500;
					'h10006:	{high,med,low} <= 'h500;
					'h10007:	{high,med,low} <= 'h500;
					'h10008:	{high,med,low} <= 'h600;
					'h10009:	{high,med,low} <= 'h600;
					'h1000a:	{high,med,low} <= 'h600;
					'h1000b:	{high,med,low} <= 'h600;
					'h1000c:	{high,med,low} <= 'h500;
					'h1000d:	{high,med,low} <= 'h500;
					'h1000e:	{high,med,low} <= 'h500;
					'h1000f:	{high,med,low} <= 'h500;
					'h10010:	{high,med,low} <= 'h400;
					'h10011:	{high,med,low} <= 'h400;
					'h10012:	{high,med,low} <= 'h400;
					'h10013:	{high,med,low} <= 'h400;
					'h10014:	{high,med,low} <= 'h300;
					'h10015:	{high,med,low} <= 'h300;
					'h10016:	{high,med,low} <= 'h300;
					'h10017:	{high,med,low} <= 'h300;
					'h10018:	{high,med,low} <= 'h200;
					'h10019:	{high,med,low} <= 'h200;
					'h1001a:	{high,med,low} <= 'h200;
					'h1001b:	{high,med,low} <= 'h200;
					'h1001c:	{high,med,low} <= 'h100;
					'h1001d:	{high,med,low} <= 'h100;
					'h1001e:	{high,med,low} <= 'h100;
					'h1001f:	{high,med,low} <= 'h100;
					'h10020:	{high,med,low} <= 'h500;
					'h10021:	{high,med,low} <= 'h000;
					default: {high,med,low} <= 'h000;
				endcase
//				else
//					case (cnt)
//					'h0000:	{high,med,low} <= 'h500;
//					'h0001:	{high,med,low} <= 'h500;
//					'h0002:	{high,med,low} <= 'h300;
//					'h0003:	{high,med,low} <= 'h400;
//					'h0004:	{high,med,low} <= 'h500;
//					'h0005:	{high,med,low} <= 'h500;
//					'h0006:	{high,med,low} <= 'h300;
//					'h0007:	{high,med,low} <= 'h400;
//					'h0008:	{high,med,low} <= 'h500;
//					'h0009:	{high,med,low} <= 'h050;
//					'h000a:	{high,med,low} <= 'h060;
//					'h000b:	{high,med,low} <= 'h070;
//					'h000c:	{high,med,low} <= 'h100;
//					'h000d:	{high,med,low} <= 'h200;
//					'h000e:	{high,med,low} <= 'h300;
//					'h000f:	{high,med,low} <= 'h400;
//					'h0010:	{high,med,low} <= 'h300;
//					'h0011:	{high,med,low} <= 'h300;
//					'h0012:	{high,med,low} <= 'h100;
//					'h0013:	{high,med,low} <= 'h200;
//					'h0014:	{high,med,low} <= 'h300;
//					'h0015:	{high,med,low} <= 'h030;
//					'h0016:	{high,med,low} <= 'h040;
//					'h0017:	{high,med,low} <= 'h050;
//					'h0018:	{high,med,low} <= 'h060;
//					'h0019:	{high,med,low} <= 'h050;
//					'h001a:	{high,med,low} <= 'h040;
//					'h001b:	{high,med,low} <= 'h050;
//					'h001c:	{high,med,low} <= 'h030;
//					'h001d:	{high,med,low} <= 'h040;
//					'h001e:	{high,med,low} <= 'h050;
//					'h001f:	{high,med,low} <= 'h040;
//					'h0020:	{high,med,low} <= 'h040;
//					'h0021:	{high,med,low} <= 'h060;
//					endcase
			end
			else begin
				cnt <= 0;
				if (!complete)
					played <= 0;
			end
		end
	end

endmodule
