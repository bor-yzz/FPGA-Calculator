//同步按键时钟，输入按键值，输出运算符定义值，没有按下运算符是默认输出3‘b111
module sign_reg(clk, flag,key_value, out_sign);
	input 				clk,flag;
	input 		[4:0] 	key_value;
	output 	reg [2:0] 	out_sign= 3'b111;
/*按键运算符号寄存模块*/
//宏定义运算符输出值
 parameter add 		=3'b000;
 parameter minus 	=3'b001;
 parameter multiply =3'b010;
 parameter division =3'b011;
 parameter reset 	=3'b100;
 parameter equal 	=3'b101;
always @(posedge clk)begin
	if (flag)
	case(key_value) 
//按键值对应运算符
		5'd3 :	out_sign <=  add;
		5'd7 :	out_sign <=  minus;
		5'd11:	out_sign <=  multiply;
		5'd12:	out_sign <=  reset;
		5'd14:	out_sign <=  equal;
		5'd15:	out_sign <=  division;
		default: out_sign <= 3'b111;
	endcase
	end
endmodule
