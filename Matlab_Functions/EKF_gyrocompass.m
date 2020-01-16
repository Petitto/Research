function [X_corr, Kgain] = EKF_gyrocompass(GyroData , TimeData, Magangle2,IMUidx)

IMUDataBody   = [GyroData(:,1:3)];
IntRoll       =  0;
IntPitch      =  0;
IntYaw        =  0;   

g             = 9.8;                              % gravity
rad2deg       = 180/pi;                           % rad to deg conversion
deltaT        = 0.00871;
StateNum      = 3;                                % number of state members
Tstart        = 1;
Tend          = length(GyroData(:,1));
%--------------------------------------------------------------------------
IMUBias       = [0,0,0];
%--------------------------------------------------------------------------
% EKF Intialization
P1             = zeros(StateNum,StateNum,Tend-Tstart+1);       % variable space initilaization  
P1_pred        = zeros(StateNum,StateNum,Tend-Tstart+1);
Kgain          = zeros(StateNum,1,Tend-Tstart+1);
S1             = zeros(1,1,Tend-Tstart+1);
VelError1      = zeros(1,Tend-Tstart+1);
u              = zeros(3,Tend-Tstart+1);
X_hat          = zeros(3,Tend-Tstart+1);
X_corr         = zeros(3,Tend-Tstart+1);

X_corr(:,1)    = [IntRoll IntPitch IntYaw]';                    % State Vector ( roll/pitch/yaw)
                                       
Rvar1          = 5e6;

Q = eye(3);
Q(1,1) = 5e-5;
Q(2,3) = 5e-5;
Q(2,3) = 5e-5;
Q = Q*Q;

         

H1       = [ 0 0 1 ];               
F0       = eye(3);                  

 %initalize obervation functions  
h = zeros(1, 3);
h(1, 3) = 1;
                  
[C,ii,ic] = intersect(1:Tend,IMUidx);
Iobs      = zeros(length(1:Tend),1);
Comobs    = zeros(length(1:Tend),1);
Iobs(ii)  = 1;
Comobs(ii)= Magangle2(ic);
for i = 2: Tend

     %Bias removal if needed     
     u(:,i-1)       = IMUDataBody(i-1,:)' - IMUBias';

     deltaT = (TimeData (i) - TimeData (i-1))/1000;
     E_B_2_I = transfCg_jas(X_corr(1,i-1),X_corr(2,i-1),X_corr(3,i-1));
     

     F_theta = zeros(3);
     F_theta(1,1) = (u(2, i-1)*cos(X_corr(1,i-1)) - u(3, i-1)*sin(X_corr(1,i-1)))*tan(X_corr(2,i-1));
     F_theta(1,2) = (u(2, i-1)*sin(X_corr(1,i-1)) + u(3, i-1)*cos(X_corr(1,i-1)))/(cos(X_corr(2,i-1))*cos(X_corr(2,i-1)));
     F_theta(2,1) = -u(2, i-1)*sin(X_corr(1,i-1)) - u(3, i-1)*cos(X_corr(1,i-1));
     F_theta(3,1) = (u(2, i-1)*cos(X_corr(1,i-1)) - u(3, i-1)*sin(X_corr(1,i-1)))/cos(X_corr(2,i-1));
     F_theta(3,2) = (u(2, i-1)*sin(X_corr(1,i-1)) + u(3, i-1)*cos(X_corr(1,i-1)))*tan(X_corr(2,i-1))/cos(X_corr(2,i-1));
     
     F = [ eye(3)+deltaT*F_theta];              

             

     % EKF Prediction (from i-1 to i)
     X_hat(1:3, i) = X_corr(1:3,i-1) + deltaT*E_B_2_I*u(1:3,i-1);     
     
     P1_pred(:,:,i) = F*P1(:,:,i-1)*F'+ Q;
 
     % EKF Update
     H1 =[0,0,1];
     S1(:,:,i)      = H1*P1_pred(:,:,i)*H1' + Rvar1;
     Kgain(:,:,i)   = P1_pred(:,:,i)*H1'/S1(:,:,i);
     
     %update observation function h
     
     if Iobs(i) ==1
        VelError1(:,i) = [Comobs(i)] -  [0,0,1]*X_hat(:,i);
     else
        VelError1(:,i) = 0;
     end
     X_corr(:,i)  =  X_hat(:,i);%+ Kgain(:,:,i)*VelError1(:,i);
     P1(:,:,i)    = (eye(3)-Kgain(:,:,i)*H1)*P1_pred(:,:,i)*(eye(3)-Kgain(:,:,i)*H1)'+Kgain(:,:,i)*Rvar1*Kgain(:,:,i)';
                   
end