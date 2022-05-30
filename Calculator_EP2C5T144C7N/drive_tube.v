//同步时钟脉冲clk
//enable：74hc138译码器使能输出口
//number：实时当前显示数字[9:0]输入
//sign：实时当前显示运算符[2:0]输入
//duan_reg：数码管段选值寄存器输出
//wei_reg：数码管位选值寄存器输出
module drive_tube(clk, enable, number, sign, duan_reg, wei_reg);
	input       clk;
	output      enable;
	output 	reg	[7:0] duan_reg;
	output   	[2:0] wei_reg;
	input  		[19:0] number;
	input       [2:0] sign;
	
	wire		[23:0] num_4_digit;
	reg			[3:0]  duan_statu=4'd0;
	reg			sign_or_number_key;	
	reg         [2:0]  flag=3'b000;
	reg         [31:0] cnt=32'd0;
parameter TIMER=32'd50000;	
//宏定义数码管显示数字0~9对应段选值
 parameter zero =8'b0011_1111;
 parameter one  =8'b0000_0110;
 parameter two  =8'b0101_1011;
 parameter three=8'b0100_1111;
 parameter four =8'b0110_0110;
 parameter five =8'b0110_1101;
 parameter six  =8'b0111_1101;
 parameter seven=8'b0000_0111;
 parameter eight=8'b0111_1111;
 parameter nine =8'b0110_1111;
//宏定义数码管显示运算符+ - * / 对应的段选值
 parameter add 		=8'b0111_0000;
 parameter minus 	=8'b0100_0000;
 parameter multiply =8'b0111_0110;
 parameter division =8'b0100_1001;
 parameter reset 	=8'b0011_1111;
 parameter equal 	=8'b0100_0001;
//138译码器使能，计算4位number值将个、十、百、千四位数字对应存储在num_4_digit对应位	
assign  enable = 1'b1;	
assign  num_4_digit[23:20]  = number/20'd100000;       			//number最高位
assign  num_4_digit[19:16]  =(number%20'd100000)/20'd10000; 	//number 
assign  num_4_digit[15:12]  =(number%20'd10000 )/20'd1000;   	//number 
assign  num_4_digit[11:8]   =(number%20'd1000  )/20'd100;     	//number百位
assign  num_4_digit[7 :4]   =(number%20'd100   )/20'd10;	   	//number十位
assign  num_4_digit[3 :0]   = number%20'd10;		   			//number个位
assign wei_reg=~flag;

always @(posedge clk)begin
	if(cnt<TIMER-1'b1)
		cnt<=cnt+1'b1;
	else
		begin
		if (flag==3'b101)
			flag<=3'b000;
		else
			flag<=flag+1'b1;		
		
		cnt<= 32'd0;
		end
end


//数码管位选扫描，使得数码管四位显示，有符号位信号时位选赋值为3‘b111
always @(posedge clk)begin
	if (cnt==TIMER-1'b1)
	begin	
		if(sign >= 3'b101)
		case(flag)
			3'b101: begin 			           duan_statu <= num_4_digit[3 :0 ] ;     				   end
			3'b000: begin if(number >20'd9)    duan_statu <= num_4_digit[7 :4 ] ;else duan_statu <= 4'd10;end
			3'b001: begin if(number >20'd99)   duan_statu <= num_4_digit[11:8 ] ;else duan_statu <= 4'd10;end
			3'b010: begin if(number >20'd999)  duan_statu <= num_4_digit[15:12] ;else duan_statu <= 4'd10;end
			3'b011: begin if(number >20'd9999) duan_statu <= num_4_digit[19:16] ;else duan_statu <= 4'd10;end
			3'b100: begin if(number >20'd99999)duan_statu <= num_4_digit[23:20] ;else duan_statu <= 4'd10;end
			default: duan_statu<=duan_statu; 
		endcase
		else
		case(flag)
			3'b101: begin duan_statu <= 4'd11;end 
			3'b000: begin duan_statu <= 4'd10;end
			3'b001: begin duan_statu <= 4'd10;end
			3'b010: begin duan_statu <= 4'd10;end
			3'b011: begin duan_statu <= 4'd10;end
			3'b100: begin duan_statu <= 4'd10;end
			default: ; 
		endcase		
	end 
	else
		duan_statu<=duan_statu; 
end

//数码管段选值赋值显示
always @(clk) 
	if(sign >= 3'b101)
	case (duan_statu)
			4'd0:begin		duan_reg	<=	 zero;	end
			4'd1:begin		duan_reg	<=	 one;	end
			4'd2:begin		duan_reg	<=	 two;	end			
			4'd3:begin		duan_reg	<=	 three; end
			4'd4:begin		duan_reg	<=	 four;	end
			4'd5:begin		duan_reg	<=	 five;	end
			4'd6:begin		duan_reg	<=	 six;	end
			4'd7:begin		duan_reg	<=	 seven;	end
			4'd8:begin		duan_reg	<=	 eight; end
			4'd9:begin		duan_reg	<=	 nine;	end
			4'd10:begin     duan_reg	<=	8'b0000_0000;	end
	endcase
	else
	begin
	if(duan_statu==4'd11)
		case(sign)
			3'b000:	begin 	duan_reg <=  add; 		  	end
			3'b001:	begin 	duan_reg <=  minus; 	  	end
			3'b010: begin	duan_reg <=  multiply;   	end
			3'b011: begin 	duan_reg <=  division;  	end
			3'b100: begin 	duan_reg <=  reset; 	  	end
			3'b101: begin 	duan_reg <= 8'b0000_0000; 	end
			3'b111: begin 	duan_reg <=  zero; 		    end
		endcase
	else
		duan_reg	<=	8'b0000_0000;
	end
	
endmodule
