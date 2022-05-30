/*按键数字输出模块，根据按键实时数码管显示，且可以自动进位*/
//rst对应processor里rest输入，实现number的使能清零功能
//out_d_number:最大值999十进制数字按键输出
module number_reg(clk, rest, key_value, out_d_number);
	input 				clk;
	input				rest;
	input 		[4:0] 	key_value;
	output 	reg [9:0]	out_d_number;
	
	reg [18:0]  statu= 19'd0;
	reg 		flag= 1'b0;

//功能：通过检测按键实现三位十进制数字输出	
always @(posedge clk) begin
	if(key_value == 5'd17)begin   			//按键消抖			
			if(statu > 19'd99999 && key_value == 5'd17)begin
				flag = 1'b1;statu = 19'd0;
			end
			else if(statu <= 19'd99999)
				statu = statu+1'b1;
			else if	(statu == 19'd100000)
				statu = 19'd100000;
		end
	if(rest)begin							//rst清零使能
		out_d_number <= 10'd0;
	end
	else if( (flag))begin  					//限幅输出最大值999
		if(key_value != 5'd17)begin
				flag = 1'b0;
				end
		case(key_value)
		5'd0:  begin 
				if (out_d_number/10'd100==10'd0 )out_d_number=out_d_number*10'd10+10'd7; else  out_d_number=(out_d_number%10'd100)*4'd10+4'd7; 
				end
		5'd1:  begin 
				if (out_d_number/10'd100==10'd0 )out_d_number=out_d_number*4'd10+4'd8; else  out_d_number=(out_d_number%10'd100)*4'd10+4'd8; end
		5'd2:  begin                          
				if (out_d_number/10'd100==10'd0 )out_d_number=out_d_number*4'd10+4'd9; else  out_d_number=(out_d_number%10'd100)*4'd10+4'd9; end
		5'd4:  begin                          
				if (out_d_number/10'd100==10'd0 )out_d_number=out_d_number*4'd10+4'd4; else  out_d_number=(out_d_number%10'd100)*4'd10+4'd4; end
		5'd5:  begin                          
				if (out_d_number/10'd100==10'd0 )out_d_number=out_d_number*4'd10+4'd5; else  out_d_number=(out_d_number%10'd100)*4'd10+4'd5; end
		5'd6: begin                           
				if (out_d_number/10'd100==10'd0 )out_d_number=out_d_number*4'd10+4'd6; else  out_d_number=(out_d_number%10'd100)*4'd10+4'd6; end
		5'd8: begin                           
				if (out_d_number/10'd100==10'd0 )out_d_number=out_d_number*4'd10+4'd1; else  out_d_number=(out_d_number%10'd100)*4'd10+4'd1; end
		5'd9: begin                           
				if (out_d_number/10'd100==10'd0 )out_d_number=out_d_number*4'd10+4'd2; else  out_d_number=(out_d_number%10'd100)*4'd10+4'd2; end
		5'd10:begin                           
				if (out_d_number/10'd100==10'd0 )out_d_number=out_d_number*4'd10+4'd3; else  out_d_number=(out_d_number%10'd100)*4'd10+4'd3; end
		5'd13: begin                          
				if (out_d_number/10'd100==10'd0 )out_d_number=out_d_number*4'd10+4'd0; else  out_d_number=(out_d_number%10'd100)*4'd10+4'd0; end
		5'd12: begin 
				out_d_number=10'd0; end			
		default:;
		endcase
		end
end	
endmodule		
