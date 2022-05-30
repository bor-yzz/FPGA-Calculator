/*����ģ�飬���ݵ�ǰnumberֵ���������Ž��в�ͬ���ͼ��㣬��������*/
//������궨�帳ֵ
//key_value����ǰ����ֵ����
//number����ǰԤ����ֵ����
//sign����������
//display_number���������ʾֵ���
//diaplay_sign���������ʾ�������
//rest��number_regģ���ʼ�������Ϊ1��numberֵ������
module processor(key_value, number,flag,sign, display_number, display_sign, rest);
	input 		[9:0] number;
	input         flag   ;
	input       [4:0] key_value;
	input 		[2:0] sign;
	output 	 	[19:0] display_number;
	output reg 	[2:0] display_sign=3'b111;
	output reg        rest;

	reg         [9:0] num_msk=10'd0;
	reg         [2:0] sign_flg = 3'b111;
	reg   		[19:0]r_number=20'd0,r_number2=20'd0;
	reg     	countiue=1'b0;
parameter add 		=3'b000;
parameter minus     =3'b001;
parameter multiply 	=3'b010;
parameter division 	=3'b011;
parameter reset 	=3'b100;
parameter equal 	=3'b101;

assign display_number =countiue?r_number:{10'd0,number};
//������ֵ�仯ʱִ�и�ģ�飬����ʱ�����		
	always @(posedge flag)begin	
		display_sign <= sign;	
		if(sign != 3'b111)begin
			case(sign)			
//�������ɨ��
				add     :begin sign_flg <= add;     if(rest !=1'b1) begin num_msk <= number; rest <= 1'b1;end end    
				minus   :begin sign_flg <= minus;   if(rest !=1'b1) begin num_msk <= number; rest <= 1'b1;end end
				multiply:begin sign_flg <= multiply;if(rest !=1'b1) begin num_msk <= number; rest <= 1'b1;end end
				division:begin sign_flg <= division;if(rest !=1'b1) begin num_msk <= number; rest <= 1'b1;end end
				reset   :begin sign_flg <= reset;countiue<=1'b0;r_number <=20'd0; rest <= 1'b1;  ;end
				equal   :begin 
							if(!countiue)begin
							countiue<=1'b1;
							if(sign_flg == add)
								r_number <= num_msk + number; 
							else if(sign_flg == minus)
								r_number <= num_msk - number; 
							else if(sign_flg == multiply)
								r_number <= num_msk * number; 
							else if(sign_flg == division)
								r_number <= num_msk / number;	
							end 
							else if(countiue)begin					
							if(sign_flg == add)
								r_number <= r_number + number; 
							else if(sign_flg == minus)
								r_number <= r_number - number; 
							else if(sign_flg == multiply)
								r_number <= r_number * number; 
							else if(sign_flg == division)
								r_number <= r_number / number;	
							end 
							
							
				          end
				default:begin end				
			endcase
		end
		else begin
			rest <= 1'b0;
// if(!countiue)  //��û��equal����ʱ�������ʵʱ��ʾ��ǰnumberֵ
// display_number <= {10'd0,number};
// else
// display_number <= r_number;
			end		
		
	end
endmodule	