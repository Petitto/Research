function [Magangle1,Magangle2, Magtime] = process_mag_data(MagData,w)

Magangle    = MagData(:,2);
Magangle1   = MagData(:,2);
%% chnage data range
%way 1: change (0,-pi) to (pi,2*pi)
% change (0,-pi) to (pi,2*pi)
Q             = find(Magangle1<0);         
Magangle1(Q)  = Magangle1(Q)+2*pi;
Magangle1     = Magangle1/pi*180;
Q1            = find(Magangle1>350);
Magangle1(Q1) = 0;
% Magangle1   = Magangle1/pi*180;
%%%way 2: change (0,-pi) -> (0,pi) and (0,pi)-> (0,-pi)
% Magangle1  = Magangle1+2*pi;

%% LPF to filter out noise
% w = 50; 
b = (1/w)*ones(1,w);
a = 1;
Magangle2 = filter(b,a,Magangle1);


Magangle2(Q)  = Magangle2(Q)-2*pi;


[gd,~]    = grpdelay(b,a);             %%% avg group delay
w1        = round(mean(gd));            %%% compensate for delay
Magangle1 = Magangle1(1:end-w1);
Magangle2 = Magangle2(w1+1:end);


figure
subplot(3,1,1)
plot(Magangle)
subplot(3,1,2)
plot(Magangle1)
subplot(3,1,3)
plot(Magangle2)
%% return Magtime according to window size
Magtime =  MagData(w1+1:end,1);
