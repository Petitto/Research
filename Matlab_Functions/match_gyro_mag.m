function [idx_mag]   = match_gyro_mag(D,F)
% gyro: D, sample rate = 1/100 
%  mag: F, sample rate = 1/50

t_gyro  = D(:,1);
t_mag   = F(:,1);
idx_mag = zeros(length(t_mag),1);
for i = 1:length(t_mag)
      [M I]       = min( abs(t_gyro - t_mag(i,1))); 
      idx_mag(i,1)= I;
end
    