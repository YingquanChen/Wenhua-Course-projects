% 设置信号参数
fs = 100000; % 采样频率
t = 0:1/fs:0.001; % 一个方波周期（200个样本点）
f = 5000; % 方波频率
A = 1; % 方波振幅

% 生成周期方波信号
x = A * square(2 * pi * f * t);

% 设置RC电路的时间常数
R = 2200; % 电阻值，单位为Ω
C = 103; % 电容值，单位为F
RC = R * C;

% 生成冲激响应信号
h = (1 / RC) * exp(-t / RC);

% 计算卷积
y_full = conv(x, h);

% 截取卷积结果的一个周期长度
y_cycle_length = length(t); % 一个周期的长度
y = y_full(1:y_cycle_length);

% 循环重复周期长度的卷积结果
num_cycles = 1; % 设定重复循环的次数
y_repeated = repmat(y, 1, num_cycles);

% 调整时间轴范围以匹配 100us/div
time_repeated = t; % 已有的周期长度

% 绘制原始信号和卷积结果
figure;

% 1. 绘制输入信号
subplot(2, 1, 1);
plot(time_repeated, x, 'b');
title('输入信号 x(t)');
xlabel('时间 (s)');
ylabel('振幅 (V)');
xlim([0, 0.001]); % 控制显示的范围为 1ms

% 2. 绘制重复循环后的卷积结果
subplot(2, 1, 2);
plot(time_repeated, y, 'r');
title('卷积结果 y(t)');
xlabel('时间 (s)');
ylabel('振幅 (V)');
xlim([0, 0.001]); % 控制显示的范围为 1ms



