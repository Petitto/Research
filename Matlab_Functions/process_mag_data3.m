function [Mnew] = process_mag_data3(MagData)

%% define data range / multiply
Magangle1  = -MagData(:,2)/pi*180;  % pi_pos_right
Mnew       = zeros(length(Magangle1),1);
Mnew(1,1)  = Magangle1(1,1); 

for i = 2:length(Magangle1)
   signchange(i,1) = sign(Magangle1(i-1,1))*sign(Magangle1(i,1));
   delta_angle = abs(Magangle1(i,1)-Magangle1(i-1,1));
   if (delta_angle>10) && (signchange(i,1)==-1)
       if  sign(Mnew(i-1,1))==1
           d1      = pi-Magangle1(i-1,1);
           d2      = -pi-Magangle1(i,1);
           d_angle = d1+d2; 
       else
           d1      = -pi-Magangle1(i-1,1);
           d2      = pi-Magangle1(i,1);
           d_angle = -(d1+d2);
       end
       Mnew(i,1) = Mnew(i-1,1)+ d_angle;
   else
       d_angle   = Magangle1(i,1)-Magangle1(i-1,1);
       Mnew(i,1) = Mnew(i-1,1)+ d_angle;
   end
end
Mnew = Mnew/180*pi;
% % filter
% b = (1/w)*ones(1,w);
% a = 1;
% Magangle2 = filter(b,a,Mnew);
% [gd,~]    = grpdelay(b,a);             %%% avg group delay
% w1        = round(mean(gd));           %%% compensate for delay
% Magangle1 = Mnew(1:end-w1);
% Magangle2 = Magangle2(w1+1:end);
% 
% figure
% plot(Magangle1)
% hold on
% plot(Magangle2)
% title('Compass Reading')
% legend('Original Data','Filtered')

