clc; % 清除命令窗口
clear all; % 清除工作区中的所有变量
close all; % 关闭所有图形窗口

M = 8; % 麦克风数量
d = 0.085; % 麦克风之间的距离（米）
c = 340; % 空气中的声速（米/秒）
N = 44100; % 信号中的样本数

% 生成可能的到达方向（DOA）角度列表
DOAs_list = asind((-11:11) * c / (N * d));

num_trials = 100; % 每个SNR值的试验次数
correct_count = 0;

% 初始化数组以存储准确度和SNR值
SNR_range = -10:0; % SNR范围从-10 dB到0 dB
accuracy = zeros(size(SNR_range));

% 读取原始信号
[sig_ori, FS] = audioread('test_audio.wav');
sig_ori = sig_ori';
Lsig = length(sig_ori);
dt = 1 / N;
t = 0:dt:(Lsig - 1) * dt;

for snr_idx = 1:length(SNR_range)
    SNR_dB = SNR_range(snr_idx);
    correct_count = 0;

    rng(42); % 种子用于可重现性

    for trial = 1:num_trials
        random_index = randperm(length(DOAs_list), 1);
        theta = DOAs_list(random_index);
        
        % 计算信源到每个麦克风的距离
        delta_r = d * sin(deg2rad(abs(theta))); 
    
        % 基于theta设置Rsm
        if theta > 0
            if delta_r == 0
                Rsm = zeros(1, 8);
            else
                Rsm = (M - 1) * delta_r : -delta_r : 0;
            end
        else
            if delta_r == 0
                Rsm = zeros(1, 8);
            else
                Rsm = 0 : delta_r : (M - 1) * delta_r;
            end
        end
        
        % 计算每个麦克风的时间延迟（TD）
        TD = Rsm / c;
        L_TD = TD / dt;
        L_TD = round(L_TD);
        
        Signal_Received=[];
        Lsig_end = Lsig - max(L_TD);
        signal_power = sig_ori * sig_ori' / Lsig; % 计算信号功率
        noise_power = signal_power / (10^(SNR_dB / 10)); % 计算噪声功率
        
        % 为每个麦克风生成带噪声的接收信号
        for p = 1:M    
            noise = sqrt(noise_power) * randn(1, Lsig);    
            sig_noise =  sig_ori + noise;
            Signal_with_noise = [sqrt(noise_power) * randn(1, L_TD(p)), sig_noise, sqrt(noise_power) * randn(1, max(L_TD) - L_TD(p))]; 
            Signal_Received = [Signal_Received; Signal_with_noise];
        end
        
        % 使用互相关估计时间延迟
        Max_lag = 66; % 互相关的最大延迟
        Lag_estimates_xx = zeros(1, M-1);
        for i = 2:M-1
            [R, ~] = xcorr(Signal_Received(i, :), Signal_Received(i+1, :), Max_lag ,  'coeff');
            [~, idx] = max(R);
            Lag_estimates_xx(i-1) = idx - (Max_lag+1);
        end  
        
        % 确定最可能的延迟
        probable_lag = mode(Lag_estimates_xx);
        
        % 估计到达方向（DOA）
        r_estimated = probable_lag * c / N; % 将延迟转换为距离
        theta_estimated = asind(r_estimated / d); % 计算估计的角度
        error = abs(theta - theta_estimated);
        
        % 检查估计的角度是否在容差范围内
        tolerance = 1e-6;
        if error < tolerance
            correct_count = correct_count + 1;    
        end
    end

    % 计算准确度百分比
    accuracy(snr_idx) = 100 * correct_count / num_trials;

    % 打印准确度信息
    disp(['SNR ', num2str(SNR_dB), ' dB下的准确度: ', num2str(accuracy(snr_idx)), '%']);
end

% 绘制准确度条形图
bar(SNR_range, accuracy);
xlabel('SNR (dB)');
ylabel('准确度 (%)');
title('准确度 vs SNR');

