/*�����������ģ�飬���ݰ���ʵʱ�������ʾ���ҿ����Զ���λ*/
//rst��Ӧprocessor��rest���룬ʵ��number��ʹ�����㹦��
//out_d_number:���ֵ999ʮ�������ְ������
module number_reg(clk, rest, key_value, out_d_number);
	input 				clk;
	input				rest;
	input 		[4:0] 	key_value;
	output 	reg [9:0]	out_d_number;
	
	reg [18:0]  statu= 19'd0;
	reg 		flag= 1'b0;

//���ܣ�ͨ����ⰴ��ʵ����λʮ�����������	
always @(posedge clk) begin
	if(key_value == 5'd17)begin   			//��������			
			if(statu > 19'd99999 && key_value == 5'd17)begin
				flag = 1'b1;statu = 19'd0;
			end
			else if(statu <= 19'd99999)
				statu = statu+1'b1;
			else if	(statu == 19'd100000)
				statu = 19'd100000;
		end
	if(rest)begin							//rst����ʹ��
		out_d_number <= 10'd0;
	end
	else if( (flag))begin  					//�޷�������ֵ999
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
