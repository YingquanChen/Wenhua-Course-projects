clc
clear all
close all
load noise.mat      % load the special noise if needed
% for the special noise, the odd lines are the opposite of the even lines

fig=0;                      % Figure ID
[sig_ori,FS]=audioread('test_audio.wav');  % read the original speech, you can use anything you like
% The sig_ori is the discrete type signal with a sampling rate FS
% Here, FS=16000 means that in 1 second, there are 16000 samples of the speech
sig_ori = sig_ori';
Lsig = length(sig_ori);     % detect the length of the signal
dt=1/FS;    % the dt is the samping interval, which is, for dt second, there will be one sample of the speech
t=0:dt:Lsig/FS;
t=t(1:Lsig);    % how many seconds; for example, for a sampling rate 16000, 32000 samples means 2 seconds
% SNR_dB = 1000; % this indicate the Signal_to_Noise_Ratio = 10 * log_10(signal_power / noise_power)
% SNR_dB = 0; % this indicate the Signal_to_Noise_Ratio = 10 * log_10(signal_power / noise_power)
SNR_dB = 30; % this indicate the Signal_to_Noise_Ratio = 10 * log_10(signal_power / noise_power)
Is_add_special_noise = 1;   % if 0, add random noise; otherwise, add predefined noise
% assume Gaussian Noise
% note that the SNR_dB = 1000 refers to no noise approximately; SNR_dB = 20 is large noise in speech processing

% this code is for ploting the FFT of the signal ------------------------
% we can see that for a speech, The energy is mainly concentrated in low frequency
f=linspace(0,FS/2,Lsig/2);
f=f';
Y=fft(sig_ori,Lsig);
inputy=Y(1:Lsig/2);
yabs=abs(Y); 
yy=yabs(1:Lsig/2);

fig=fig+1;
figure(fig)
plot(f,yy);
title('FFT')
%----------------------------------------------------------------------------------

% % this code place the microphones and source ------------------------
% M=4;        % 4 microphones
% c=340;     % The speed at which sound travels through the air is 340m/s
% % We now place four microphones in four different places
% Loc(1,:)=[0, 20, 0, 20]; 
% Loc_M_x=Loc(1,:);
% Loc(2,:)=[0, 0, 10, 10];
% Loc_M_y=Loc(2,:);
% % the location of the microphones are in Loc above, in this example, the
% % locations are in (0,0)m, (25,5)m, (50,0)m and (75,5)m

% this code place the microphones and source ------------------------ another setting
M=2;        % 2 microphones
c=340;     % The speed at which sound travels through the air is 340m/s
% We now place two microphones in two different places
Loc(1,:)=[0, 50]; 
Loc_M_x=Loc(1,:);
Loc(2,:)=[0, 10];
Loc_M_y=Loc(2,:);
% the location of the microphones are in Loc above, in this example, the
% locations are in (0,0)m and (50,10)m

xs=1;
ys=1;
% source located in (1, 1)m
%----------------------------------------------------------------------------------

% distance between microphones and source ---------------------
Rsm=[];
 for q=1:M
     rsm=sqrt((xs-Loc_M_x(q))^2+(ys-Loc_M_y(q))^2);
     Rsm=[Rsm rsm];  % distance between microphones and source
 end
TD=Rsm/c; 
% time delay between microphones and source, for example, if the distance
% between source and microphone is 3.4m, then the time delay is 0.01s,
% which is, when a signal is sent out from the source, after 0.01s, the
% microphone will receive the signal.
% note that in this case, given a sampling rate of FS=16000, 0.01s means
% 160 samples, which is, the L_TD below
L_TD=TD/dt;
L_TD=fix(L_TD);
%----------------------------------------------------------------------------------

%----------------------------------------------------------------------------------
Signal_Received=[];
Lsig_end = Lsig - max(L_TD);
signal_power = sig_ori*sig_ori'/Lsig;       % calculate signal power
% noise_power = srm_power/(10^(0/10));      % 0dB noise
noise_power = signal_power/(10^(SNR_dB/10));   % noise
for p=1:M    
    % adding noise
    noise = sqrt(noise_power)*randn(1, Lsig);    % assume noize is zero, or says, no noise
    if Is_add_special_noise==0
        sig_noise =  sig_ori + noise;
    else
        sig_noise =  sig_ori + sqrt(noise_power)*noise_default(p, 1:Lsig);
    end   
    % adding noise finished
    
    Signal_with_noise=[sqrt(noise_power)*randn(1, L_TD(p)), sig_noise, sqrt(noise_power)*randn(1, max(L_TD)-L_TD(p))]; % add the time delay with noise 
    % Note that the way the time delay added here is not correct in real
    % world engineering, the correct one is as below, which is, when the
    % speech reach the microphone, the longer the distance, the small the
    % values - Sound is attenuated by Rsm(p)
    % however, here is only one simplified example, therefore we ignore
    % this attenuation
%     srm=[sqrt(noise_power)*randn(1, L_TD(p)), sig_noise, sqrt(noise_power)*randn(1, max(L_TD)-L_TD(p))]/Rsm(p);
    Signal_Received=[Signal_Received; Signal_with_noise];
end
% the final output Signal_Received is of size Microphone_No*Signal_Length
% it refers to the signal received in the M microphones, for example,
% the first line is the signal received in the first microphone

Signal_Re_Sum = sum(Signal_Received,1);       % directly sum the signal from the M microphones
Signal_Re_1 = Signal_Received(1,:);                 % the signal received in the first microphone
Signal_Received_size = size(Signal_Received);
plot_time=0:dt:(Signal_Received_size(2)-1)/FS;
%----------------------------------------------------------------------------------
% plot and output the signal received in microphone 1
fig=fig+1;
figure(fig)
plot(plot_time,Signal_Re_1)
title('Signal-First')
Signal_Re_1=Signal_Re_1./max(Signal_Re_1);
audiowrite('Signal-First.wav',Signal_Re_1,FS);

%----------------------------------------------------------------------------------
% plot and output the Sum of the signal received from all microphones directly
fig=fig+1;
figure(fig)
plot(plot_time,Signal_Re_Sum)
title('Signal-Direct-Sum')
Signal_Re_Sum=Signal_Re_Sum./max(Signal_Re_Sum);
audiowrite('Signal-Direct-Sum.wav',Signal_Re_Sum,FS);

%----------------------------------------------------------------------------------
% plot all the received signal in one figure
fig=fig+1;
figure(fig)
plot(plot_time, Signal_Received','DisplayName','Signal_Received')
title('All Signal')

% now we use xcorr, the cross-correlation, to detect the difference between
% the microphones, and thus can add the signal correctly. 
% Here we only show an example: add the signals from the first two microphones 
x1 = Signal_Received(1,:);  % microphone 1
x2 = Signal_Received(2,:);  % microphone 2
Max_lag = 8000; 	               % we assume that the maximum distance between any two microphones is less than 170m, which is 0.5s, which is 8000 samples
% note that in this case, the 0 lag, which is, the lag corresponding to 0
% time difference, is Max_lag+1 = 8001
R_12 = xcorr(x1, x2, Max_lag, 'coeff'); 

% plot the Cross-Correlation
lag_list = -Max_lag:Max_lag;
fig=fig+1;
figure(fig)
plot(lag_list, R_12) 
title('the Cross-Correlation')
[Lag_12_value, Lag_12_index] = max(R_12);
Lag_12_estimate = Lag_12_index-(Max_lag+1)   % the lag between microphone 1 and 2

% just to see the real lag, cannot use Real_lag = L_TD(1)-L_TD(2) in your
% code when add the signal from different microphones
Real_lag = L_TD(1)-L_TD(2);
error = Lag_12_estimate - Real_lag
%----------------------------------------------------------------------------------

Length_x1 = length(x1);
x1_pad_zero = [zeros(1, abs(Lag_12_estimate)), x1, zeros(1, abs(Lag_12_estimate))];
x2_pad_zero = [zeros(1, abs(Lag_12_estimate)), x2, zeros(1, abs(Lag_12_estimate))];
x1_with_lag = x1_pad_zero(max(0, Lag_12_estimate)+1:end-max(0, -Lag_12_estimate));    % Align the two signals with correct lag
x2_with_lag = x2_pad_zero(max(0, -Lag_12_estimate)+1:end-max(0, Lag_12_estimate));
Correct_Sum_with_lag = x1_with_lag+x2_with_lag;
plot_time2=0:dt:(length(x2_with_lag)-1)/FS;
%----------------------------------------------------------------------------------
% plot and output the Sum of the signal received from microphones 1 and 2 with correct lag
fig=fig+1;
figure(fig)
plot(plot_time2,Correct_Sum_with_lag)
title('Signal-Correct-Sum-12')
Correct_Sum_with_lag=Correct_Sum_with_lag./max(Correct_Sum_with_lag);
audiowrite('Signal-Correct-Sum-12.wav',Correct_Sum_with_lag,FS);