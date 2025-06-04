% 读取采样率为16kHz的语音信号
[y, fs] = audioread('output_audio_16kHz.wav');

% 确保信号长度为5秒（如果超过5秒则截取前5秒，不足5秒则填充0）
desired_duration = 5;  % 目标信号长度为5秒
num_samples_target = desired_duration * fs;
y = y(1:min(length(y), num_samples_target));  % 截取前5秒或补零

% 初始化滤波器参数
window_size = 5;  % 中值滤波窗口大小

% 1. 反转信号 x_1(t) 得到 x_1(-t)
y_flipped = flipud(y);  % flipud 函数用于反转向量

% 保存反转声音为 WAV 文件
output_filename_flipped = 'flipped_audio.wav';
audiowrite(output_filename_flipped, y_flipped, fs);
disp(['Flipped audio saved to: ' output_filename_flipped]);

% 中值滤波处理直接反转的声音
y_flipped_filtered = medfilt1(y_flipped, window_size);  % 中值滤波

% 保存滤波后的直接反转声音为 WAV 文件
output_filename_flipped_filtered = 'flipped_audio_filtered.wav';
audiowrite(output_filename_flipped_filtered, y_flipped_filtered, fs);
disp(['Filtered flipped audio saved to: ' output_filename_flipped_filtered]);

% 输出反转声音和滤波后的声音进行比较
figure;
subplot(2, 1, 1);
plot(y_flipped);
title('Flipped Signal');
xlabel('Time (samples)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(y_flipped_filtered);
title('Filtered Flipped Signal');
xlabel('Time (samples)');
ylabel('Amplitude');

sgtitle('Signal Comparison: Flipped vs Filtered Flipped');

% 设置图形大小
set(gcf, 'Position', [100, 100, 800, 600]);

% 播放直接反转声音和滤波后的声音进行比较
sound(y_flipped, fs);
pause(6);  % 暂停6秒，确保播放完成
sound(y_flipped_filtered, fs);
