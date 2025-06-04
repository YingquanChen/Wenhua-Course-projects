% 参数设置
fs = 50000; % 采样频率
f0 = 1000;   % 初始频率
k = 12000;   % 频率变化率
T_end = 0.1; % 信号持续时间
t = 0:1/fs:T_end-1/fs; % 时间向量

% 生成扫频信号
x = cos(2*pi*(f0*t + 0.5*k*t.^2));

% 匹配滤波器的脉冲响应
h = fliplr(x);

% 滤波器输出
y = filter(h, 1, x);
% 找到滤波器输出的峰值位置
[~,maxValue] = max(y);
endTimeIndex = find(y == maxValue, 1, 'last');
endTime = endTimeIndex * (1/fs);
% 初始化结果存储结构
results = struct;
periodogramResults = struct;

% 设计SNR范围
snrRange = 0:10:100;

% 测试匹配滤波器方法
for snr = snrRange
    testSNR(snr);
end

% 测试周期图方法
timeWindows = 0.11:0.01:1; % 定义可能的结束时间窗口
for snr = snrRange
    testPeriodogramMethod(snr);
end

% 绘制结果

% 测试函数
function testSNR(snr)
    % 根据SNR计算噪声功率谱密度
    Pr = var(x); % 信号的功率
    sigma2 = (10^(snr/10) - 1) * Pr / length(x);
    
    % 生成噪声
    noise = sqrt(sigma2) * randn(size(x));
    
    % 信号加噪声
    noisySignal = x + noise;
    
    % 应用匹配滤波器
    noisyFiltered = filter(h, 1, noisySignal);
    
    % 估计结束时间
    [~,maxValue] = max(noisyFiltered);
    endTimeIndexNoisy = find(noisyFiltered == maxValue, 1, 'last');
    endTimeNoisy = endTimeIndexNoisy * (1/fs);
    
    % 计算MSE和成功率
    mse = (endTimeNoisy - endTime)^2;
    success = abs(endTimeNoisy - endTime) < 0.03;
    
    % 存储结果
    results.snr(snr).mse = mse;
    results.snr(snr).success = success;
end
% 使用周期图分析信号
n = length(x);
window = rectwin(n); % 使用矩形窗
Pxx = periodogram(x, window, [], fs);

% 绘制功率谱
figure;
plot((0:n-1)*(fs/n), 10*log10(Pxx));
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectrum Estimation using Periodogram');