function [idx_mag]   = match_gyro_gps(D,F)
% gyro: D, sample rate = 1/100  sec
%  mag: F, sample rate = 1      sec

t_gyro  = D(:,1);
t_gps   = F(:,1);
idx_mag = zeros(length(t_gps),1);
for i = 1:length(t_gps)
      [M I]       = min( abs(t_gyro - t_gps(i,1))); 
      idx_mag(i,1)= I;
end
    