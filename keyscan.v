//模块名及输入输出端口的定义  real_number输出按键值
module keyscan(clk,keyscan,flag,keyin,real_number);
 input 	clk;
 input 	[3:0]	keyin;
 output [3:0] 	keyscan;
 output reg     flag   ;
 output [4:0] 	real_number; 
 reg 	[3:0] 	state=4'd0;
 reg 	[3:0] 	four_state= 4'b0000; 
 reg 	[3:0] 	scancode=4'b0000,scan_state=4'b0000;
 reg 	[4:0] 	numberout= NoKeyIsPressed,number_reg= NoKeyIsPressed,number_reg1= NoKeyIsPressed, real_number= NoKeyIsPressed;   
 reg 			AnyKeyPressed=  NO ;
 reg    [31:0]t=32'd0;
 parameter TIMER=32'd5000000;
 parameter OK =1'b1;				//定义OK代表1
 parameter NO =1'b0;				//定义NO代表0
 parameter NoKeyIsPressed=5'd17;	//定义NoKeyIsPressed代表17
 
 
 
assign keyscan = scancode;
 
always @(posedge clk)  				//矩阵按键行扫描
     if(AnyKeyPressed)
        case (scan_state)
			4'b0000: begin scancode<=4'b1110; scan_state<= 4'b0001; end
			4'b0001: begin scancode <= {scancode[0],scancode[3:1]}; end      
        endcase
     else 
        begin
			scancode <=4'b0000;
			scan_state<= 4'b0000;
        end
///////////////////////////////////////////////////////////////////

 always @(posedge clk)				//矩阵按键列扫描 
 if( !(&keyin))
	begin
	 AnyKeyPressed <=  OK ;  
	 four_state <= 4'b0000;
	end
 else 
	if(AnyKeyPressed)
	   case(four_state)
		 4'b0000: begin  AnyKeyPressed <=  OK ;  four_state<=4'b0001; end
		 4'b0001: begin  AnyKeyPressed <=  OK ;  four_state<=4'b0010; end
		 4'b0010: begin  AnyKeyPressed <=  OK ;  four_state<=4'b0100; end
		 4'b0100: begin  AnyKeyPressed <=  OK ;  four_state<=4'b1000; end
		 4'b1000: begin  AnyKeyPressed <=  NO ;   end
		 default: AnyKeyPressed <=  NO ;
	   endcase
	else 
		 four_state <= 4'b0000;
////////////////////////////////////////////////////////////////////////
         
always @(posedge clk) 					//计算矩阵按键输出值0~15
  casex({scancode,keyin})
    8'b0111_1110: numberout <= 5'd1-1;
    8'b1011_1110: numberout <= 5'd5-1;  
    8'b1101_1110: numberout <= 5'd9-1;
    8'b1110_1110: numberout <= 5'd13-1; 
    
    8'b0111_1101: numberout <= 5'd2-1;
    8'b1011_1101: numberout <= 5'd6-1;  
    8'b1101_1101: numberout <= 5'd10-1;
    8'b1110_1101: numberout <= 5'd14-1; 
        
    8'b0111_1011: numberout <= 5'd3-1;
    8'b1011_1011: numberout <= 5'd7-1; 
    8'b1101_1011: numberout <= 5'd11-1;
    8'b1110_1011: numberout <= 5'd15-1; 
    
    8'b0111_0111: numberout <= 5'd4-1;
    8'b1011_0111: numberout <= 5'd8-1;  
    8'b1101_0111: numberout <= 5'd12-1;
    8'b1110_0111: numberout <= 5'd16-1;
    default: numberout <= NoKeyIsPressed;
   endcase
////////////////////////////////////////////////////////////////////////
   
always @(posedge clk) 					//判断是否有按键按下
begin
		if( numberout<=5'd15 && numberout>=5'd0)
			begin
				 number_reg <= numberout;  
			end
		else
			begin
				if(AnyKeyPressed ==  NO)
					number_reg <=  NoKeyIsPressed;  
			end		   
end
/////////////////////////////////////////////////////////////////
         
always @(posedge clk)  					//按键消抖
	case (state)
4'd0: begin   
			flag  <=1'b0;
			number_reg1 <= number_reg;
			if (number_reg1!=number_reg)
				t<=1;
							
			if (t==TIMER-1'b1)
				begin
				t<=32'd0;
				state <=4'd1;
				end
			else if(t>=1)
				t<=t+1;
		end
4'd1: begin 
			t<=32'd0;
			if(number_reg == number_reg1)
				state <= 4'd2;
			else
				state <= 4'd0;
		end
4'd2: begin
			if (number_reg == number_reg1)                  
				state <= 4'd3;
			else
				state <= 4'd0;
		end                     
4'd3: begin
			if (number_reg == number_reg1)                
				state <= 4'd4;
			else
				state <= 4'd0;   
		end          
4'd4: begin   
			 if(number_reg == number_reg1)
				state <=4'd5;
			 else
				state <= 4'd0; 
		end
4'd5: begin 
			if(number_reg == number_reg1)
				state <= 4'd6;
			else
				state <= 4'd0;
		end
4'd6: begin
			if (number_reg == number_reg1)                  
				state <= 4'd7;
			else
				state <= 4'd0;
		end                     
4'd7: begin
			if (number_reg == number_reg1)                
				  state <= 4'd8;
			else
				  state <= 4'd0;   
		end          
4'd8: begin 
			if (number_reg == number_reg1)    
				  state <=4'd9;
			else
				  state <= 4'd0;  
		end
4'd9: begin 
			if(number_reg == number_reg1)
				  state <= 4'd10;
			else
				  state <= 4'd0;
		end
4'd10: begin
			if (number_reg == number_reg1)                  
				  state <= 4'd11;
			else
				 state <= 4'd0;
		end                     
4'd11: begin
			if (number_reg == number_reg1)                
				 state <= 4'd12;
			else
				 state <= 4'd0;   
		end          
4'd12: begin 
			if(number_reg == number_reg1)
			  state <= 4'd13;
			else
			  state <= 4'd0;
		end
4'd13: begin
			if (number_reg == number_reg1)                  
				  state <= 4'd14;
			else
				 state <= 4'd0;
		end                     
4'd14: begin
			if (number_reg == number_reg1)                
			 state <= 4'd15;
			else
			 state <= 4'd0;   
		end                 
4'd15: begin
			if (number_reg == number_reg1 ) 
				begin  
					flag  <=1'b1;
					state <= 4'd0;
					real_number <= number_reg; 
				end
			else
						 state <= 4'b0000;   
		end                        
  default:   state <= 4'b0000;   
  endcase
/////////////////////////////////////////////////////
   
endmodule
