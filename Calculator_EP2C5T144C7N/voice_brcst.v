//�궨������������Ӧ����SD���е����
//MP3��������YS-M3������ģʽ���31������
module voidce_brcst(clk, key_value, cnt_value, voice_choice_Y, BY);
	input             clk;
	input       [4:0] key_value;    //����ֵ
	input 			  BY;  			//�������������ʱΪ�͵�ƽ��δ����Ϊ�ߵ�ƽ
	input       [19:0] cnt_value;
	output 	reg [4:0] voice_choice_Y;
	
	reg         [31:0] i=0,t=0;
	wire		[23:0] num_4_digit;
	reg         [3:0] equal_ = 4'd15;
	reg         [4:0] r_value=5'd17;
parameter TIMER=32'd150000000;
 parameter zero 	=5'b11110;
 parameter one  	=5'b11101;
 parameter two  	=5'b11100;
 parameter three 	=5'b11011;
 parameter four 	=5'b11010;
 parameter five 	=5'b11001;
 parameter six 		=5'b11000;
 parameter seven 	=5'b10111;
 parameter eight 	=5'b10110;
 parameter nine 	=5'b10101;
 parameter add 		=5'b10100;
 parameter minus 	=5'b10011;
 parameter multiply =5'b10010;
 parameter division =5'b10001;
 parameter reset 	=5'b10000;
 parameter equal 	=5'b01111;
 parameter tens 	=5'b01110;
 parameter hundreds =5'b01101;
 parameter thousand 	=5'b01100;
 parameter ten_thousand =5'b01011;
assign  num_4_digit[23:20]  = cnt_value/20'd100000;       		//number���λ
assign  num_4_digit[19:16]  = cnt_value%20'd100000/20'd10000; 	//number 
assign  num_4_digit[15:12]  = cnt_value%20'd10000/20'd1000;   	//number 
assign  num_4_digit[11:8]   = cnt_value%20'd1000/20'd100;     	//number��λ
assign  num_4_digit[7 :4]   = cnt_value%20'd100/20'd10;		  	//numberʮλ
assign  num_4_digit[3 :0]   = cnt_value%20'd10;			  		//number��λ

//��ʱ��
always @(posedge clk)begin
	if(t < 20000000)
		t <= t+1;
	else
		t <= 20000000;
end
always @(*)begin
	if ( t ==20000000)begin
		if((equal_==5'd15)|(equal_==5'd0))
			case(r_value)      									//���ݰ�����������
				5'd0:  begin voice_choice_Y <=  seven;	end
				5'd1:  begin voice_choice_Y <=  eight;	end
				5'd2:  begin voice_choice_Y <=  nine;	end
				5'd3:  begin voice_choice_Y <=  add;	end
				5'd4:  begin voice_choice_Y <=  four;	end
				5'd5:  begin voice_choice_Y <=  five;	end
				5'd6:  begin voice_choice_Y <=  six;	end
				5'd7:  begin voice_choice_Y <=  minus;	end
				5'd8:  begin voice_choice_Y <=  one;	end
				5'd9:  begin voice_choice_Y <=  two;	end
				5'd10: begin voice_choice_Y <=  three;	end
				5'd11: begin voice_choice_Y <=  multiply;end
				5'd12: begin voice_choice_Y <=  reset;	end
				5'd13: begin voice_choice_Y <=  zero;	end
				5'd14: begin voice_choice_Y <=  equal;  end
				5'd15: begin voice_choice_Y <=  division;end
				default:voice_choice_Y <= 5'b11111;
			endcase	
		else
			case(r_value)      									//���ݰ�����������
				5'd0:  begin voice_choice_Y <=  zero;	end
				5'd1:  begin voice_choice_Y <=  one;;	end
				5'd2:  begin voice_choice_Y <=  two;	end
				5'd3:  begin voice_choice_Y <=  three;	end
				5'd4:  begin voice_choice_Y <=  four;	end
				5'd5:  begin voice_choice_Y <=  five;	end
				5'd6:  begin voice_choice_Y <=  six;	end
				5'd7:  begin voice_choice_Y <=  seven;	end
				5'd8:  begin voice_choice_Y <=  eight;  end
				5'd9:  begin voice_choice_Y <=  nine;   end
				5'd10: begin voice_choice_Y <=  tens;   end
				5'd11: begin voice_choice_Y <=  hundreds;end
				5'd12: begin voice_choice_Y <=  thousand;	 end
				5'd13: begin voice_choice_Y <=  ten_thousand;end
				default:voice_choice_Y <= 5'b11111;
			endcase	
	end	
	else
		voice_choice_Y <= 5'b11111;
end	
//ɨ�谴��ֵ���Ŷ�Ӧ����
always @(posedge clk)begin										//voice_choice_Y = 5'b11111;
	case(equal_)
		4'd15: 	begin
					r_value<=key_value;
					if (key_value==5'd14)
						equal_ <=4'd0;
				end
	
		4'd0: 	begin
				if (i==TIMER-1'b1)
					begin
					i<=32'd0;
					if (cnt_value<20'd10)
						begin
						equal_ <=4'd11;
						r_value<={1'b0,num_4_digit[3:0]};
						end
					else if((cnt_value>=20'd10)&(cnt_value<20'd100))
						equal_ <=4'd9;								
					else if((cnt_value>=20'd100)&(cnt_value<20'd1000))
						equal_ <=4'd7;
					else if((cnt_value>=20'd1000)&(cnt_value<20'd10000))
						equal_ <=4'd5;	
					else if((cnt_value>=20'd10000)&(cnt_value<20'd100000))
						equal_ <=4'd3;	
					else if(cnt_value>=20'd100000)
						equal_ <=4'd1;								
					end
				else
					begin
					if(!BY)
					r_value <= 5'd14;
					i <= i+1;
					end					
				end	
		4'd1: begin 
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=equal_+ 4'd1;
					end
				else
					begin				
					i <= i+1;
					r_value<={1'b0,num_4_digit[23:20]};				
					end
				end
		4'd2: begin
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=equal_+ 4'd1;
					end
				else
					begin				
					i <= i+1;
					r_value<=5'd11;				
					end
				end	
		4'd3: begin 
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=equal_+ 4'd1;
					end
				else
					begin				
					i <= i+1;
					r_value<={1'b0,num_4_digit[19:16]};				
					end
				end
		4'd4: begin
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=equal_+ 4'd1;
					end
				else
					begin				
					i <= i+1;
					r_value<=5'd12;				
					end
				end	
		4'd5:begin 
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=equal_+ 4'd1;
					end
				else
					begin				
					i <= i+1;
					r_value<={1'b0,num_4_digit[15:12]};				
					end
				end
		4'd6: begin
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=equal_+ 4'd1;
					end
				else
					begin				
					i <= i+1;
					r_value<=5'd13;				
					end
				end
		4'd7: begin 
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=equal_+ 4'd1;
					end
				else
					begin				
					i <= i+1;
					r_value<={1'b0,num_4_digit[11:8]};				
					end
				end			
		4'd8:  begin
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=equal_+ 4'd1;
					end
				else
					begin				
					i <= i+1;
					r_value<=5'd11;				
					end
				end
		4'd9: begin 
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=equal_+ 4'd1;
					end
				else
					begin				
					i <= i+1;
					r_value<={1'b0,num_4_digit[7:4]};				
					end
				end	
		4'd10:  begin
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=equal_+ 4'd1;
					end
				else
					begin				
					i <= i+1;
					r_value<=5'd10;				
					end
				end
				
		4'd11: begin
				if (i==TIMER-1'b1)
					begin
					i <= 0;	
					equal_ <=4'd15;
					r_value<=5'd7;
					end
				else
					begin				
					i <= i+1;
					if(!BY)
						r_value<=5'd7;							//num_4_digit[3:0]	
					end
				end	
		default:;	
	endcase
end
endmodule
