module Router_synchronizer(clk,rst,detect_add,wr_en_reg,din,e0,e1,e2,f0,f1,f2,re0,re1,re2,we,fifofull,srst0,srst1,srst2,vldout0,vldout1,vldout2);
input clk,rst,detect_add,wr_en_reg,e0,e1,e2,f0,f1,f2,re0,re1,re2;
input [1:0]din;
output reg [2:0]we;
output reg fifofull,srst0,srst1,srst2;
output vldout0,vldout1,vldout2;
reg [1:0] temp_reg;
reg [4:0] timer_0,timer_1,timer_2;
wire flag_0=(timer_0==5'd29);
wire flag_1=(timer_1==5'd29);
wire falg_2=(timer_2==5'd29); //Counting 30 clock cycle
// internal address logic
always @(posedge clk)
begin
if(!rst)
temp_reg<=1'b0;
else if(detect_add)
temp_reg<=din;
end
//write_enb logic
always @ (posedge clk)
begin
if (wr_en_reg)
begin
case(temp_reg)
2'b00 : we <= 3'b001; //One hot encoding
2'b01 : we <= 3'b010;
2'b10 : we <= 3'b100;
default: we <= 3'b000;
endcase
end
end
//fifo full logic
always@(posedge clk)
begin
case(temp_reg)
2'b00 : fifofull <= f0;
2'b01 : fifofull <= f1;
2'b10 : fifofull <= f2;
default: fifofull <= 1'b0;
endcase
end
//soft reset logics
// soft reset1
always @(posedge clk)
begin
if(!rst)
begin
timer_0<=1'b0;
srst0<=1'b0;
end
else if(vldout0)
begin
if((~re0) && (flag_0))
begin
srst0<=1'b1;
timer_0<=5'b0;
end
end
else
begin
srst0<=1'b0;
timer_0<=timer_0+1'b1;
end
end
//soft reset 2
always @(posedge clk)
begin
if(!rst)
begin
timer_1<=1'b0;
srst1<=1'b0;
end
else if(vldout1)
begin
if((~re1) && (flag_1))
begin
srst1<=1'b1;
timer_1<=5'b0;
end
end
else
begin
srst1<=1'b0;
timer_1<=timer_1+1'b1;
end
end
// soft reset 3
always @(posedge clk)
begin
if(!rst)
begin
timer_2<=1'b0;
srst2<=1'b0;
end
else if(vldout2)
begin
if((~re2) && (flag_2))
begin
srst2<=1'b1;
timer_2<=5'b0;
end
end
else
begin
srst2<=1'b0;
timer_2<=timer_2+1'b1;
end
end
// valid out is of net type or wire type
assign vldout0 = ~e0;
assign vldout1 = ~e1;
assign vldout2 = ~e2;
endmodule