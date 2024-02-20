% clc;
clear;
close all;



% ##########################常数定义##########################
% 光速 单位m/s
c = 299792458;
% pi MATLAB中pi为3.141592653589793


% ##########################信号源&接收机参数设计##########################
% 信号源频率 单位Hz
frequency = 3.2e4;

% 接收机信号采样率 单位Hz
samp_rate = 3.2e6;
% 接收机水平移动速度 单位m/s
v_rx = 10e3;

% 接收机比相相干积累序列数
coherent_integration_number = 10;
% 接收机比相相干积累正弦信号序列周期数
coherent_integration_cycles = 10;
% 接收机比相单次采样正弦信号总周期数
single_sampling_cycles = coherent_integration_number * ...
    coherent_integration_cycles;
% 接收机比相单次采样时长 单位s
single_sampling_duration = single_sampling_cycles / frequency;
% 接收机比相单次采样经过的距离 单位s
single_sampling_distance = single_sampling_duration / v_rx;

% 接收机比相间隔距离 单位m
sampling_interval = c / frequency / 2;  % 半波长
% 接收机比相间隔时间 单位s
delta_t = sampling_interval / v_rx;

% 信号采样总时长 单位s
sampling_duration = delta_t + single_sampling_duration;
% 信号采样总时长对应的距离 单位m
sampling_distance = sampling_duration / v_rx;

% 信号源与接收机比相时相对角度alpha 范围[0, 180)
alpha_angle = 66;
alpha_radian = deg2rad(alpha_angle);    % 弧度
alpha_sin = sin(alpha_radian);
alpha_cos = cos(alpha_radian);
% 信号源与接收机比相时相对距离d_r 单位m
d_relative = 20 * c / frequency;    % 20倍正弦信号波长

% 信号源投影在接收机移动方向上的距离d_v  单位m
d_vertical = d_relative * alpha_sin;
% 接收机比相首次采样完成时与信号源的相对距离d'_r 单位m
d_prime_relative = sqrt(d_vertical^2 + ...
    (sampling_interval + d_relative * alpha_cos)^2);

% 接收机比相最终采样开始时与信号源的相对距离d_start 单位m
d_start = sqrt(d_vertical^2 + ...
    (sampling_interval + d_relative * alpha_cos)^2);
% 接收机比相首次采样开始时与信号源的相对距离d'_start 单位m
d_prime_start = sqrt(d_vertical^2 + ...
    (sampling_distance + d_relative * alpha_cos)^2);

% 信号源坐标
[x_s, y_s] = deal(d_relative * alpha_cos + sampling_distance, ...
    d_vertical);


% ##########################仿真时域参数设计##########################
% 仿真时长 单位s
sim_duration = sampling_duration;
% 信号源传播至接收机首次采样开始时间点
t_prime_start = d_prime_start / c;
% 仿真时间间隔 单位s
sim_time_interval = 1 / samp_rate;
% 仿真时间向量 单位s
time_vector = t_prime_start : sim_time_interval : ...
    t_prime_start+sim_duration;



% ##########################空间网格设计##########################
% 最大采样间隔距离 单位m
d_max = v_rx / samp_rate;
% 仿真网格长度 单位m
grid_width = sampling_distance;
% 仿真网格点数
num_points_width = ceil(grid_width / d_max);



% ##########################实时仿真##########################
% 接收机初始空间坐标
[x_rx, y_rx] = deal(0, 0);

% 初始化接收到的信号数组
sig_rx = zeros(1, length(time_vector));

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
end



% 绘图
figure(1);
subplot(2, 1, 1);
plot(time_vector(1:1000), sig_rx(1:1000));
xlabel('时间 (s)');
ylabel('幅值');
title('接收信号');
xlim([time_vector(1) time_vector(1000)]);
ylim([-2 2]);
grid on;



% ##########################高斯加噪##########################
% 噪声参数定义
snr_value = 10;     % 信噪比SNR(dB)
% 添加噪声到信号
[sig_rx_noisy, ~] = FUNC_AddGaussianNoise(sig_rx, snr_value);



% 绘图
figure(1);
subplot(2, 1, 2);
plot(time_vector(1:1000), sig_rx_noisy(1:1000));
xlabel('时间 (s)');
ylabel('幅值');
title(['高斯加噪信号 (SNR = ' num2str(snr_value) ' dB) ']);
xlim([time_vector(1) time_vector(1000)]);
ylim([-2 2]);
grid on;



% ##########################测向信号截取##########################
% 比相单次采样点数
single_sampling_points = round( ...
    single_sampling_duration / sim_time_interval);
% 比相间隔点数
interval_points =  round(delta_t / sim_time_interval);

% 截取比相信号A和B
sigA = sig_rx_noisy(1 : single_sampling_points);
sigB = sig_rx_noisy((1 + interval_points) : ...
    (interval_points + single_sampling_points));
% 信号A和B分别对应的时间向量
tv_sigA = time_vector(1 : single_sampling_points);
tv_sigB = time_vector((1 + interval_points) : ...
    (interval_points + single_sampling_points));



% 绘图
figure(2);

subplot(2, 1, 1);
plot(tv_sigA, sigA);
xlabel('时间 (s)');
ylabel('幅值');
title('截取接收信号A');
xlim([tv_sigA(1) tv_sigA(end)]);
ylim([-2 2]);
grid on;

subplot(2, 1, 2);
plot(tv_sigB, sigB);
xlabel('时间 (s)');
ylabel('幅值');
title('截取接收信号B');
xlim([tv_sigB(1) tv_sigB(end)]);
ylim([-2 2]);
grid on;



% ##########################带通滤波##########################
% 滤波
[sigA_filtered, filter_b] = FUNC_BandpassFilter(sigA, frequency, samp_rate);
[sigB_filtered, ~] = FUNC_BandpassFilter(sigB, frequency, samp_rate);



% 绘图

% 滤波器频率响应
figure(3);
freqz(filter_b, 1, 1024, samp_rate);

% 滤波后的信号
figure(4);

subplot(2, 1, 1);
plot(tv_sigA, sigA_filtered);
xlabel('时间 (s)');
ylabel('幅值');
title('带通滤波信号A');
xlim([tv_sigA(1) tv_sigA(end)]);
ylim([-2 2]);
grid on;

subplot(2, 1, 2);
plot(tv_sigB, sigB_filtered);
xlabel('时间 (s)');
ylabel('幅值');
title('带通滤波信号B');
xlim([tv_sigB(1) tv_sigB(end)]);
ylim([-2 2]);
grid on;



% ##########################相干积累##########################
% 相干积累信号采样点数
coherent_integration_points = single_sampling_points / ...
    coherent_integration_cycles;
% 初始化相干积累信号数组
sigA_integration = zeros(1, coherent_integration_points);
sigB_integration = zeros(1, coherent_integration_points);
% 相干积累信号对应的时间向量
tv_sigA_integration = tv_sigA(end-coherent_integration_points+1 : end);
tv_sigB_integration = tv_sigB(end-coherent_integration_points+1 : end);

% 相干积累
for i = 1 : coherent_integration_points
    for j = 1 : coherent_integration_cycles
        point = coherent_integration_points * (j-1) + i;
        sigA_integration(i) = sigA_integration(i) + sigA_filtered(point);
        sigB_integration(i) = sigB_integration(i) + sigB_filtered(point);
    end
    sigA_integration(i) = sigA_integration(i) / ...
        coherent_integration_cycles;
    sigB_integration(i) = sigB_integration(i) / ...
        coherent_integration_cycles;
end


% 绘图
figure(5);

subplot(2, 1, 1);
plot(tv_sigA_integration, sigA_integration);
xlabel('时间 (s)');
ylabel('幅值');
title('相干积累滤波信号A');
xlim([tv_sigA_integration(1) tv_sigA_integration(end)]);
ylim([-2 2]);
grid on;

subplot(2, 1, 2);
plot(tv_sigB_integration, sigB_integration);
xlabel('时间 (s)');
ylabel('幅值');
title('相干积累滤波信号B');
xlim([tv_sigB_integration(1) tv_sigB_integration(end)]);
ylim([-2 2]);
grid on;



% ##########################时延比相测向##########################
[~, doa_phase_angle] = FUNC_DF2D_SignalDelayPhaseComparing( ...
    sigB_integration, sigA_integration, frequency, ...
    delta_t, sampling_interval, c)
