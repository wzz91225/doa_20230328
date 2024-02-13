function [doa_angle] = FUNC_SIM_DelayPhaceComp(relative_DoA, snr_value, sampling_periods)
%FUNC_SIM_DelayPhaceComp Summary....
%   Detailed explanation....


% 常数定义
c = 299792458;      % 光速

% 参数定义
samp_rate = 3.2e6;  % 信号采样率(Hz)
frequency = 3.2e4;  % 正弦信号频率（Hz）
amplitude = 1;      % 正弦信号幅值
sim_duration = 1;   % 正弦信号时长(s)



% ##########################生成基带信号##########################
[signal, ~] = FUNC_GenerateSineSignal(frequency, amplitude, sim_duration, samp_rate);

% ##########################高斯加噪##########################
[signal_noisy, ~] = FUNC_AddGaussianNoise(signal, snr_value);



% ##########################运动时延截取仿真##########################
% 仿真相关参数定义
distance_relative = 20*c/frequency;     % 相对距离
% relative_DoA = 66                       % 相对角度
velocity_t = 1e4;                       % 卫星运动速度
delta_t = c/frequency/2/velocity_t;     % 比相时间间隔
% sampling_period = 100;                  % 比相保留采样周期
sampling_points_retain = samp_rate/frequency * sampling_periods; % 比相保留采样点数

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
% t_rxA = t(delay_A : delay_A+sampling_points_retain);
% t_rxB = t(delay_B : delay_B+sampling_points_retain);



% ##########################带通滤波##########################
[sigA_filtered, ~] = FUNC_BandpassFilter(signal_rxA, frequency, samp_rate);
[sigB_filtered, ~] = FUNC_BandpassFilter(signal_rxB, frequency, samp_rate);

% ##########################时延比相测向##########################
distance = velocity_t * delta_t;
[~, doa_angle] = FUNC_DF2D_SignalDelayPhaceComparing(sigB_filtered, sigA_filtered, frequency, delta_t, distance, c);

end