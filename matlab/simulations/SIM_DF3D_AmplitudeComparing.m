% clc;
clear;
close all;

% 参数设置
samp_rate = 32e6;         % 采样率 32MHz
samp_duration = 0.001;    % 采样时间 0.001s
frequency = 32e3;         % 频率 32kHz
real_azimuth_angle = 30;  % 方位角为30度
real_pitch_angle = 45;    % 俯仰角为45度
noise_amplitude = 0.5;    % 噪声幅值

% 生成单频正弦信号
t = 0:1/samp_rate:samp_duration-1/samp_rate;
sine_wave = sin(2 * pi * frequency * t);

% 基于到达角度生成三路信号
real_azimuth_radian = deg2rad(real_azimuth_angle);
real_pitch_radian = deg2rad(real_pitch_angle);
signal_ch1 = sine_wave * sin(real_pitch_radian) * cos(real_azimuth_radian);
signal_ch2 = sine_wave * sin(real_pitch_radian) * sin(real_azimuth_radian);
signal_ch3 = sine_wave * cos(real_pitch_radian);

% 输出仿真设定实际角度
fprintf('实际方位角 = %.2f°\n', real_azimuth_angle);
fprintf('实际俯仰角 = %.2f°\n', real_pitch_angle);

% 添加高斯噪声
signal_ch1 = signal_ch1 + noise_amplitude * randn(size(signal_ch1));
signal_ch2 = signal_ch2 + noise_amplitude * randn(size(signal_ch2));
signal_ch3 = signal_ch3 + noise_amplitude * randn(size(signal_ch3));

% 计算信噪比 (SNR) 示例，根据实际情况进行调整
snr_ch1 = 10 * log10(var(signal_ch1) / var(noise_amplitude * randn(size(signal_ch1))));
snr_ch2 = 10 * log10(var(signal_ch2) / var(noise_amplitude * randn(size(signal_ch2))));
snr_ch3 = 10 * log10(var(signal_ch3) / var(noise_amplitude * randn(size(signal_ch3))));

% 输出信噪比
fprintf('SNR_ch1 = %.2f dB\n', snr_ch1);
fprintf('SNR_ch2 = %.2f dB\n', snr_ch2);
fprintf('SNR_ch3 = %.2f dB\n', snr_ch3);

% 三维比幅法测向
[azimuth_angle, pitch_angle] = FUNC_DF3D_AmplitudeComparing(signal_ch1, signal_ch2, signal_ch3, samp_rate);
fprintf('测量方位角 = %.2f°\n', azimuth_angle);
fprintf('测量俯仰角 = %.2f°\n', pitch_angle);

% 绘制时域信号
figure;
plot(t, signal_ch1, 'DisplayName', 'ch1');
hold on;
plot(t, signal_ch2, 'DisplayName', 'ch2');
plot(t, signal_ch3, 'DisplayName', 'ch3');
hold off;
legend('show');
title('Rx Signals');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;
