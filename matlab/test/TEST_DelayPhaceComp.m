% clc;
clear;
close all;

% 常量定义
samp_rate = 3.2e6;  % 采样率(Hz)
c = 299792458;      % 光速

% 仿真时间参数定义
sim_duration = 1;                   % 仿真时长(s)
t = 0 : 1/samp_rate : sim_duration; % 时间向量



% 正弦基带信号定义
frequency = 3.2e4;  % 频率（Hz）
amplitude = 1;      % 振幅
% 生成基带信号
signal = amplitude * sin(2*pi*frequency*t);

% 噪声参数定义
noise_amp = 1.0;    % 噪声幅值
% 生成高斯噪声
noise = noise_amp * randn(size(t));  % 高斯噪声
signal_noisy = signal + noise;
% 计算信噪比
snr_value = snr(signal, noise)

% 绘制信号
figure(1);
subplot(2,1,1);
% 绘制基带信号
plot(t, signal);
hold on;
% 绘制加噪后信号
plot(t, signal_noisy);
hold off;
legend('原始信号', '加噪信号');
xlabel('时间 (秒)');
ylabel('幅度');
title(['基带信号（SNR = ' num2str(snr_value) ' dB）']);
xlim([0 10/frequency]);
ylim([-2 2]);
grid on;



% 仿真相关参数定义
distance_relative = 10*c/frequency;     % 相对距离
relative_DoA = 66                       % 相对角度
velocity_t = 1e6;                       % 卫星运动速度
Delta_t = c/frequency/2/velocity_t;     % 比相时间间隔
sampling_points_retain = samp_rate/frequency * 10;     % 比相保留采样点数

% 计算采样点延迟数量
alpha_sin = sin(relative_DoA * pi / 180);
alpha_cos = cos(relative_DoA * pi / 180);
dis_at = velocity_t * Delta_t;
distance_A = sqrt((distance_relative * alpha_cos - dis_at/2)^2 + (distance_relative * alpha_sin)^2);
distance_B = sqrt((distance_relative * alpha_cos + dis_at/2)^2 + (distance_relative * alpha_sin)^2);
delay_A = round((distance_A / c) * samp_rate);
delay_B = round((distance_B / c + Delta_t) * samp_rate);
% 截取两次采样信号
signal_rxA = signal_noisy(delay_A : delay_A+sampling_points_retain);
signal_rxB = signal_noisy(delay_B : delay_B+sampling_points_retain);
t_rxA = t(delay_A : delay_A+sampling_points_retain);
t_rxB = t(delay_B : delay_B+sampling_points_retain);

% 绘制两次接收截取的信号
figure(1);
subplot(2,1,2);
plot(signal_rxA);
hold on;
plot(signal_rxB);
hold off;
legend('Rx A', 'Rx B');
xlabel('采样点');
ylabel('幅度');
title('接收信号截取');
ylim([-2 2]);
grid on;



% 计算相位差
N = length(signal_rxA); % 两个信号长度相同
halfN = floor(N/2) + 1; % 确保为整数
% 执行 FFT
Y1 = fft(signal_rxA);
Y2 = fft(signal_rxB);
% 计算单边频谱的幅度
P1 = abs(Y1/N);
P2 = abs(Y2/N);
P1 = P1(1:halfN);
P2 = P2(1:halfN);
% 计算单边频谱的相位
phase1 = angle(Y1(1:halfN));
phase2 = angle(Y2(1:halfN));
% 找到主要频率成分（即幅度最大的频率）
[~, idx1] = max(P1);
[~, idx2] = max(P2);
% 比较两个信号在主要频率处的相位
phase_difference = phase2(idx2) - phase1(idx1);
% 将相位差转换到 [-pi, pi] 范围
phase_difference = mod(phase_difference + pi, 2*pi) - pi;



% 计算到达角度
actual_delta_phi = phase_difference - 2 * pi * frequency * Delta_t;
actual_delta_phi = mod(actual_delta_phi + pi, 2 * pi) - pi;
alpha = acos(actual_delta_phi * c / frequency / 2 / pi / velocity_t / Delta_t);
result_DoA = rad2deg(alpha)
