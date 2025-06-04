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

% 2. 将 x_1(t) 分割成帧，然后反转每一帧，重新拼接成 x_2(t)
% 设置不同的帧长度 l，观察语义变化
frame_lengths = [500 2000 5000 20000];  % 帧长度，单位：样本数
for i = 1:length(frame_lengths)
    l = frame_lengths(i);
    num_frames = floor(length(y) / l);
    y_frames = reshape(y(1:num_frames*l), l, num_frames);  % 分割成帧
    
    % 反转每一帧并应用中值滤波
    for j = 1:num_frames
        y_frames(:, j) = medfilt1(y_frames(:, j), window_size);  % 中值滤波每一帧
    end
    
    % 重新拼接成 x_2(t)
    y_reconstructed = reshape(y_frames, [], 1);
    
    % 保存 x_2(t) 为 WAV 文件
    output_filename_reconstructed = sprintf('reconstructed_audio_%d_filtered.wav', l);
    audiowrite(output_filename_reconstructed, y_reconstructed, fs);
    
    disp(['Reconstructed and filtered audio (l = ' num2str(l) ') saved to: ' output_filename_reconstructed]);
end

% 输出滤波后的声音
figure;
subplot(2, 1, 1);
plot(y);
title('Original Signal');
xlabel('Time (samples)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(y_reconstructed);
title('Reconstructed and Filtered Signal');
xlabel('Time (samples)');
ylabel('Amplitude');

sgtitle('Signal Comparison: Original vs Reconstructed and Filtered');

% 设置图形大小
set(gcf, 'Position', [100, 100, 800, 600]);

