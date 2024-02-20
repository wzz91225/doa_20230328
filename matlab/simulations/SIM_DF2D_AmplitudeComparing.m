% clc;
clear;
close all;

% 参数设置
samp_rate = 32e6;         % 采样率 32MHz
samp_duration = 0.001;    % 采样时间 0.001s
frequency = 32e3;         % 频率 32kHz
real_azimuth_angle = 67;  % 方位角为30度
noise_amplitude = 0.5;    % 噪声幅值

% 生成单频正弦信号
t = 0:1/samp_rate:samp_duration-1/samp_rate;
sine_wave = sin(2 * pi * frequency * t);

% 基于到达角度生成两路信号
real_azimuth_radian = deg2rad(real_azimuth_angle);
signal_ch1 = sine_wave * cos(real_azimuth_radian); % X轴信号
signal_ch2 = sine_wave * sin(real_azimuth_radian); % Y轴信号

% 输出仿真设定实际角度
fprintf('实际方位角 = %.2f°\n', real_azimuth_angle);

% 添加高斯噪声
signal_ch1 = signal_ch1 + noise_amplitude * randn(size(signal_ch1));
signal_ch2 = signal_ch2 + noise_amplitude * randn(size(signal_ch2));

% 计算方位角
[~, azimuth_angle] = FUNC_DF2D_AmplitudeComparing( ...
    signal_ch1, signal_ch2, samp_rate);

fprintf('测量方位角 = %.2f°\n', azimuth_angle);

% 绘制时域信号
figure;
plot(t, signal_ch1, 'DisplayName', 'ch1 - X axis');
hold on;
plot(t, signal_ch2, 'DisplayName', 'ch2 - Y axis');
hold off;
legend('show');
title('Rx Signals - 2D Direction Finding');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;
