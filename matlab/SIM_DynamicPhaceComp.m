% 正弦波参数定义
fs = 1000;         % 采样率（Hz）
f = 5;             % 正弦波频率（Hz）
A = 1;             % 振幅
phi = 0;           % 相位（弧度）
t = 0:1/fs:1;      % 时间向量，从 0 到 1 秒

% 生成正弦波
y = A * sin(2*pi*f*t + phi);

% 添加高斯噪声
noise_std = 0.2;   % 噪声标准差，可调
noise = noise_std * randn(size(t));
y_noisy = y + noise;

% 计算信噪比
snr_value = snr(y, noise);

% 绘制带噪声的信号
subplot(2,1,1);
plot(t, y);
xlabel('时间 (秒)');
ylabel('幅度');
title('纯正弦波');
grid on;

subplot(2,1,2);
plot(t, y_noisy);
xlabel('时间 (秒)');
ylabel('幅度');
title(['带噪声的正弦波，SNR = ' num2str(snr_value) ' dB']);
grid on;
