% clc;
clear;
close all;

% 常量定义
samp_rate = 3.2e6;  % 采样率(Hz)
c = 299792458;      % 光速

% 绘图参数
subplot_N = 5;      % figure 1 子图数量



% ##########################基带信号##########################
% 正弦基带信号定义
frequency = 3.2e4;  % 频率（Hz）
amplitude = 1;      % 振幅
sim_duration = 1;                   % 正弦信号时长(s)
% 生成基带信号
[signal, t] = FUNC_GenerateSineSignal(frequency, amplitude, sim_duration, samp_rate);



% ##########################高斯加噪##########################
% 噪声参数定义
snr_value = 0;      % 信噪比SNR(dB)
% 添加噪声到信号
[signal_noisy, ~] = FUNC_AddGaussianNoise(signal, snr_value);

% 绘制信号
figure(1);
subplot(subplot_N, 1, 1);
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
xlim([0 100/frequency]);
ylim([-5 5]);
grid on;



% ##########################运动时延截取仿真##########################
% 仿真相关参数定义
distance_relative = 20*c/frequency;     % 相对距离
relative_DoA = 66                       % 相对角度
velocity_t = 1e4;                       % 卫星运动速度
baseline_coefficient = 16;               % 干涉仪基线长度系数（默认为2）
delta_t = c/frequency/velocity_t/baseline_coefficient;  % 比相时间间隔
sampling_points_retain = samp_rate/frequency * 100;     % 比相保留采样点数

% 计算采样点延迟数量
alpha_sin = sin(relative_DoA * pi / 180);
alpha_cos = cos(relative_DoA * pi / 180);
dis_at = velocity_t * delta_t;
distance_A = sqrt((distance_relative * alpha_cos - dis_at/2)^2 + (distance_relative * alpha_sin)^2);
distance_B = sqrt((distance_relative * alpha_cos + dis_at/2)^2 + (distance_relative * alpha_sin)^2);
delay_A = round((distance_A / c) * samp_rate);
delay_B = round((distance_B / c + delta_t) * samp_rate);
% 截取两次采样信号
signal_rxA = signal_noisy(delay_A : delay_A+sampling_points_retain);
signal_rxB = signal_noisy(delay_B : delay_B+sampling_points_retain);
t_rxA = t(delay_A : delay_A+sampling_points_retain);
t_rxB = t(delay_B : delay_B+sampling_points_retain);

% 绘制两次接收截取的信号
figure(1);
% 接收信号截取A
subplot(subplot_N, 1, 2);
plot(t_rxA, signal_rxA);
xlabel('时间（秒）');
ylabel('幅度');
title('接收信号截取A');
xlim([t_rxA(1) t_rxA(end)]);
ylim([-5 5]);
grid on;
% 接收信号截取B
subplot(subplot_N, 1, 3);
plot(t_rxB, signal_rxB);
xlabel('时间（秒）');
ylabel('幅度');
title('接收信号截取B');
xlim([t_rxB(1) t_rxB(end)]);
ylim([-5 5]);
grid on;



% ##########################带通滤波##########################
% 滤波
[sigA_filtered, filter_b] = FUNC_BandpassFilter(signal_rxA, frequency, samp_rate);
[sigB_filtered, ~] = FUNC_BandpassFilter(signal_rxB, frequency, samp_rate);

% 查看滤波器的频率响应
% figure(2)
% freqz(filter_b, 1, 1024, samp_rate);

% 绘制滤波后的信号
figure(1);
% 接收信号截取A
subplot(subplot_N, 1, 4);
plot(t_rxA, sigA_filtered);
xlabel('时间（秒）');
ylabel('幅度');
title('接收信号截取A');
xlim([t_rxA(1) t_rxA(end)]);
ylim([-2 2]);
grid on;
% 接收信号截取B
subplot(subplot_N, 1, 5);
plot(t_rxB, sigB_filtered);
xlabel('时间（秒）');
ylabel('幅度');
title('接收信号截取B');
xlim([t_rxB(1) t_rxB(end)]);
ylim([-2 2]);
grid on;



% ##########################时延比相测向##########################
distance = velocity_t * delta_t;
[~, doa_angle] = FUNC_DF2D_SignalDelayPhaseComparing(sigB_filtered, sigA_filtered, frequency, delta_t, distance, c);
doa_angle
