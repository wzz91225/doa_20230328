function [doa_angle] = FUNC_DelayPhaceComp(relative_DoA, snr_value, sampling_periods)
%FUNC_DELAYPHACECOMP Summary of this function goes here
%   Detailed explanation goes here


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
t = 0 : 1/samp_rate : sim_duration; % 时间向量
% 生成基带信号
signal = amplitude * sin(2*pi*frequency*t);



% ##########################高斯加噪##########################
% 噪声参数定义
% snr_value = 0;      % 信噪比SNR(dB)
% 计算信号功率
signal_power = bandpower(signal);
% 计算噪声功率
noise_power = signal_power / (10^(snr_value/10));
% 生成高斯噪声
noise = sqrt(noise_power) * randn(size(signal));
% 添加噪声到信号
signal_noisy = signal + noise;



% ##########################运动时延截取仿真##########################
% 仿真相关参数定义
distance_relative = 20*c/frequency;     % 相对距离
% relative_DoA = 66                       % 相对角度
velocity_t = 1e4;                       % 卫星运动速度
Delta_t = c/frequency/2/velocity_t;     % 比相时间间隔
% sampling_period = 100;                  % 比相保留采样周期
sampling_points_retain = samp_rate/frequency * sampling_periods; % 比相保留采样点数

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



% ##########################带通滤波##########################
% 滤波器参数定义
filter_f1 = frequency * 0.9;        % 低截止频率 (Hz)
filter_f2 = frequency * 1.1;        % 高截止频率 (Hz)
filter_n =  samp_rate/frequency*2;  % 滤波器阶数
% 计算归一化截止频率
filter_w1 = filter_f1 / (samp_rate / 2);
filter_w2 = filter_f2 / (samp_rate / 2);
% 设计带通滤波器系数
filter_b = fir1(filter_n, [filter_w1, filter_w2], 'bandpass', hamming(filter_n+1));
% % 查看滤波器的频率响应
% figure(2)
% freqz(filter_b, 1, 1024, samp_rate);

% 滤波
sigA_filtered = filter(filter_b, 1, signal_rxA);
sigB_filtered = filter(filter_b, 1, signal_rxB);



% ##########################时延比相测向##########################
% 计算相位差
N = length(sigA_filtered); % 两个信号长度相同
halfN = floor(N/2) + 1; % 确保为整数
% 执行 FFT
Y1 = fft(sigA_filtered);
Y2 = fft(sigB_filtered);
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
result_DoA = rad2deg(alpha);

doa_angle = result_DoA;
end