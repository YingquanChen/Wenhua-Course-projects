clc
clear all
close all


% Define different SNR values
SNR_values = [30, 10, -10];
fig=0;

% Loop three different SNR values
for snr_idx = 1:length(SNR_values)
    SNR_dB = SNR_values(snr_idx); % Select the current SNR value

    [sig_ori,FS]=audioread("test_audio.wav");  % read the original speech, you can use anything you like

    sig_ori = sig_ori';
    Lsig = length(sig_ori);    
    dt=1/FS;    
    t=0:dt:Lsig/FS;
    t=t(1:Lsig);   


    
    M=4;        % 4 microphones
    c=340;     % The speed at which sound travels through the air is 340m/s

    % % We now place four microphones in four different places
    Loc(1,:)=[0, 20, 0, 20]; 
    Loc_M_x=Loc(1,:);
    Loc(2,:)=[0, 0, 10, 10];
    Loc_M_y=Loc(2,:);
    
    xs=1;
    ys=1;
    % source located in (1, 1)m
    
    Rsm=[];
    for q=1:M
        rsm=sqrt((xs-Loc_M_x(q))^2+(ys-Loc_M_y(q))^2);
        Rsm=[Rsm rsm];  % distance between microphones and source
    end
  
    TD=Rsm/c; 
    
    L_TD=TD/dt;
    L_TD=fix(L_TD);
    
    
    Signal_Received=[];
    Lsig_end = Lsig - max(L_TD);
    signal_power = sig_ori*sig_ori'/Lsig;       % calculate signal power
    noise_power = signal_power/(10^(SNR_dB/10));   % noise
    

    for p=1:M    
        % adding noise
        noise = sqrt(noise_power)*randn(1, Lsig);    % assume noize is zero, or says, no noise
    
        sig_noise =  sig_ori + noise;

        % adding noise finished
        
        Signal_with_noise=[sqrt(noise_power)*randn(1, L_TD(p)), sig_noise, sqrt(noise_power)*randn(1, max(L_TD)-L_TD(p))]; % add the time delay with noise 

        Signal_Received=[Signal_Received; Signal_with_noise];
    end
    
    
    Signal_Re_Sum = sum(Signal_Received,1);       % directly sum the signal from the M microphones
    Signal_Re_1 = Signal_Received(1,:);                 % the signal received in the first microphone
    Signal_Received_size = size(Signal_Received);
    plot_time=0:dt:(Signal_Received_size(2)-1)/FS;
    %----------------------------------------------------------------------------------
    
    % plot all the received signal in one figure
    fig=fig+1;
    figure(fig)
    plot(plot_time, Signal_Received','DisplayName','Signal_Received')
    title(['All Signal SNR=' num2str(SNR_dB) 'dB'])
    
    % now we use xcorr, the cross-correlation, to detect the difference between
    % the microphones, and thus can add the signal correctly.  
    x1 = Signal_Received(1,:);  % microphone 1
    x2 = Signal_Received(2,:);  % microphone 2
    x3 = Signal_Received(3,:);  % microphone 1
    x4 = Signal_Received(4,:);  % microphone 2
    Max_lag = 8000; 	               % we assume that the maximum distance between any two microphones is less than 170m, which is 0.5s, which is 8000 samples
    % note that in this case, the 0 lag, which is, the lag corresponding to 0
    % time difference, is Max_lag+1 = 8001
    R_12 = xcorr(x1, x2, Max_lag, 'coeff'); 
    R_13 = xcorr(x1, x3, Max_lag, 'coeff'); 
    R_14 = xcorr(x1, x4, Max_lag, 'coeff'); 
    
    
    
    % Find the maximum correlation index and estimate latency
    [~, Lag_12_index] = max(abs(R_12));
    [~, Lag_13_index] = max(abs(R_13));
    [~, Lag_14_index] = max(abs(R_14));
    Lag_12_estimate = Lag_12_index - (Max_lag + 1);
    Lag_13_estimate = Lag_13_index - (Max_lag + 1);
    Lag_14_estimate = Lag_14_index - (Max_lag + 1);
    
    % Align signal
    Length_x = max([length(x1), length(x2), length(x3), length(x4)]);
    x1_pad = [zeros(1, Max_lag), x1, zeros(1, Max_lag)];
    x2_pad = [zeros(1, Max_lag + Lag_12_estimate), x2, zeros(1, Max_lag - Lag_12_estimate)];
    x3_pad = [zeros(1, Max_lag + Lag_13_estimate), x3, zeros(1, Max_lag - Lag_13_estimate)];
    x4_pad = [zeros(1, Max_lag + Lag_14_estimate), x4, zeros(1, Max_lag - Lag_14_estimate)];
    
    % Signal after trimming and aligning
    x1_aligned = x1_pad(Max_lag+1 : Max_lag+Length_x);
    x2_aligned = x2_pad(Max_lag+1 : Max_lag+Length_x);
    x3_aligned = x3_pad(Max_lag+1 : Max_lag+Length_x);
    x4_aligned = x4_pad(Max_lag+1 : Max_lag+Length_x);
    
    % Superimposed signal
    Combined_Signal = x1_aligned + x2_aligned + x3_aligned + x4_aligned;
    
    plot_time=0:dt:(length(x1_aligned)-1)/FS;
    fig=fig+1;
    figure(fig)
    plot(plot_time,Combined_Signal)
    title(['Signal-Correct-Sum-1234 SNR=' num2str(SNR_dB) 'dB'])
   

end

