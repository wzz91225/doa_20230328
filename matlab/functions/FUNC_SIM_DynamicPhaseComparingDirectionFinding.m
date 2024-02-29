function [doa_phase_angle] = ...
    FUNC_SIM_DynamicPhaseComparingDirectionFinding( ...
    c, frequency, samp_rate, alpha_angle, d_relative, v_rx, snr_value, ...
    coherent_integration_number, coherent_integration_cycles, ...
    is_bandpassfilter, filter_n)
%FUNC_SIM_DynamicPhaseComparingDirectionFinding 动态比相测向仿真
% 参数:
% - c: 光速 单位m/s
% - frequency: 信号源频率 单位Hz
% - samp_rate: 接收机信号采样率 单位Hz
% - alpha_angle: 信号源与接收机比相时相对角度alpha 范围[0, 180)
% - d_relative: 信号源与接收机比相时相对距离d_r 单位m
% - v_rx: 接收机水平移动速度 单位m/s
% - snr_value: 高斯加噪信噪比SNR 单位dB
% - coherent_integration_number: 接收机比相相干积累序列数
% - coherent_integration_cycles: 接收机比相相干积累正弦信号序列周期数
% - (option) is_bandpassfilter: 是否使用带通滤波器（无输入则使用）
% - (option) filter_n: 带通滤波器阶数（无输入或≤0则自动配置）
% 返回值:
% - doa_phase_angle: 动态比相测向角度 范围[0, 180)



% ##########################常数定义##########################
% % 光速 单位m/s
% c = 299792458;

% % 信号源频率 单位Hz
% frequency = 3.2e4;
% % 接收机信号采样率 单位Hz
% samp_rate = 3.2e6;

% % 信号源与接收机比相时相对角度alpha 范围[0, 180)
% alpha_angle = 67;
% % 信号源与接收机比相时相对距离d_r 单位m
% d_relative = 20 * c / frequency;    % 20倍正弦信号波长
% % 接收机水平移动速度 单位m/s
% v_rx = 10e3;

% % 高斯加噪信噪比SNR 单位dB
% snr_value = -15;

% % 接收机比相相干积累序列数
% coherent_integration_number = 10;
% % 接收机比相相干积累正弦信号序列周期数
% coherent_integration_cycles = 10;



% ##########################信号源&接收机参数计算##########################
% 接收机比相单次采样正弦信号总周期数
single_sampling_cycles = coherent_integration_number * ...
    coherent_integration_cycles;
% 接收机比相单次采样时长 单位s
single_sampling_duration = single_sampling_cycles / frequency;
% % 接收机比相单次采样经过的距离 单位s
% single_sampling_distance = single_sampling_duration / v_rx;

% 接收机比相间隔距离 单位m
sampling_interval = c / frequency / 2;  % 半波长
% 接收机比相间隔时间 单位s
delta_t = sampling_interval / v_rx;

% 信号采样总时长 单位s
sampling_duration = delta_t + single_sampling_duration;
% 信号采样总时长对应的距离 单位m
sampling_distance = sampling_duration / v_rx;

% 相对角度alpha相关参数
alpha_radian = deg2rad(alpha_angle);    % 弧度
alpha_sin = sin(alpha_radian);
alpha_cos = cos(alpha_radian);

% 信号源投影在接收机移动方向上的距离d_v  单位m
d_vertical = d_relative * alpha_sin;
% % 接收机比相首次采样完成时与信号源的相对距离d'_r 单位m
% d_prime_relative = sqrt(d_vertical^2 + ...
%     (sampling_interval + d_relative * alpha_cos)^2);

% % 接收机比相最终采样开始时与信号源的相对距离d_start 单位m
% d_start = sqrt(d_vertical^2 + ...
%     (sampling_interval + d_relative * alpha_cos)^2);
% 接收机比相首次采样开始时与信号源的相对距离d'_start 单位m
d_prime_start = sqrt(d_vertical^2 + ...
    (sampling_distance + d_relative * alpha_cos)^2);

% 接收机初始空间坐标
% [x_rx, y_rx] = deal(0, 0);
[x_rx, ~] = deal(0, 0);
% 信号源坐标
[x_s, y_s] = deal(d_relative * alpha_cos + sampling_distance, ...
    d_vertical);



% ##########################仿真时域参数计算##########################
% 仿真时长 单位s
sim_duration = sampling_duration;
% 信号源传播至接收机首次采样开始时间点
t_prime_start = d_prime_start / c;
% 仿真时间间隔 单位s
sim_time_interval = 1 / samp_rate;
% 仿真时间向量 单位s
time_vector = t_prime_start : sim_time_interval : ...
    t_prime_start+sim_duration;

% 比相单次采样点数
single_sampling_points = round( ...
    single_sampling_duration / sim_time_interval);
% 比相间隔点数
interval_points =  round(delta_t / sim_time_interval);
% 相干积累信号采样点数
coherent_integration_points = single_sampling_points / ...
    coherent_integration_number;



% ##########################空间网格参数计算##########################
% % 最大采样间隔距离 单位m
% d_max = v_rx / samp_rate;
% % 仿真网格长度 单位m
% grid_width = sampling_distance;
% % 仿真网格点数
% num_points_width = ceil(grid_width / d_max);



% ##########################实时接收信号仿真##########################
% 初始化接收到的信号数组
sig_rx = zeros(1, length(time_vector));
sig_rx_ch1 = zeros(1, length(time_vector));

% 模拟接收机在每个时间点接收到的信号
for i = 1 : length(time_vector)
    % 计算接收机当前位置（从t=0开始沿X轴移动）
    x_rx = x_rx + v_rx * sim_time_interval;
    y_rx = 0;
    
    % 计算接收机和信号源的相对距离
    distance = sqrt((x_rx - x_s)^2 + (y_s - y_rx)^2);
    % 计算信号传播时间
    propagation_time = distance / c ;
    
    % 接收信号
    sig_rx(i) = sin(2 * pi * frequency * ...
        (time_vector(i) - propagation_time));
    
    % 单通道天线接收信号
    sig_rx_ch1(i) = sig_rx(i);
end



% ##########################高斯加噪##########################
% 添加噪声到信号
sig_rx_ch1_noisy = FUNC_AddGaussianNoise(sig_rx_ch1, snr_value);



% ##########################测向信号截取##########################
% % 信号A和B分别对应的时间向量
% tv_sigA = time_vector(1 : single_sampling_points);
% tv_sigB = time_vector((1 + interval_points) : ...
%     (interval_points + single_sampling_points));

% 信号截取索引
idx_A_head = 1;
idx_A_tail = single_sampling_points;
idx_B_head = 1 + interval_points;
idx_B_tail = interval_points + single_sampling_points;

% 截取信号
sigA_ch1 = sig_rx_ch1_noisy(idx_A_head : idx_A_tail);

sigB_ch1 = sig_rx_ch1_noisy(idx_B_head : idx_B_tail);



% ##########################带通滤波##########################
if nargin < 10 || is_bandpassfilter
    % 检查是否提供滤波器阶数
    if nargin < 11 || filter_n <= 0
        is_filter_n = 0 ;
    else
        is_filter_n = 1;
    end

    % 滤波
    if is_filter_n
        [sigA_ch1_filtered, ~] = FUNC_BandpassFilter( ...
            sigA_ch1, frequency, samp_rate, filter_n);

        [sigB_ch1_filtered, ~] = FUNC_BandpassFilter( ...
            sigB_ch1, frequency, samp_rate, filter_n);
    else
        [sigA_ch1_filtered, ~] = FUNC_BandpassFilter( ...
            sigA_ch1, frequency, samp_rate);

        [sigB_ch1_filtered, ~] = FUNC_BandpassFilter( ...
            sigB_ch1, frequency, samp_rate);
    end
else
    sigA_ch1_filtered = sigA_ch1;
    sigB_ch1_filtered = sigB_ch1;
end


% ##########################相干积累##########################
% % 相干积累信号对应的时间向量
% tv_sigA_integration = tv_sigA(end-coherent_integration_points+1 : end);
% tv_sigB_integration = tv_sigB(end-coherent_integration_points+1 : end);

% 相干积累
sigA_ch1_integration = FUNC_SignalCoherentIntegration( ...
    sigA_ch1_filtered, coherent_integration_points, coherent_integration_number);

sigB_ch1_integration = FUNC_SignalCoherentIntegration( ...
    sigB_ch1_filtered, coherent_integration_points, coherent_integration_number);



% ##########################时延比相测向##########################
% 时延比相测向算法
[~, doa_phase_angle] = FUNC_DF2D_SignalDelayPhaseComparing( ...
    sigB_ch1_integration, sigA_ch1_integration, frequency, ...
    delta_t, sampling_interval, c);

end
