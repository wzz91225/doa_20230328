% clc;
clear;
% close all;

% 仿真计时开始
tic;



% ##########################仿真过程控制##########################
% 是否输出结果
is_fprintf = 1;
% 是否绘图
is_figure = 0;

% 是否加噪
is_addnoise = 0;
% 是否使用滤波器
is_bandpassfilter = 0;



% ##########################主要仿真参数定义##########################
% 光速 单位m/s
c = 299792458;

% 信号源频率 单位Hz
frequency = 3.2e4;
% 接收机信号采样率 单位Hz
samp_rate = 6.4e6;

% 信号源与接收机比相时相对角度alpha 范围[0, 180)
alpha_angle = 6;
% 信号源与接收机比相时相对距离d_r 单位m
d_relative = 20 * c / frequency;    % 20倍正弦信号波长
% 接收机水平移动速度 单位m/s
v_rx = 10e3;

% 高斯噪声参数定义
snr_value = 10;     % 信噪比SNR(dB)

% 接收机比相相干积累序列数
coherent_integration_number = 1;
% 接收机比相相干积累正弦信号序列周期数
coherent_integration_cycles = 100;

% % 滤波器阶数
% filter_n = 200;



% ##########################信号源&接收机参数计算##########################
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

% 相对角度alpha相关参数
alpha_radian = deg2rad(alpha_angle);    % 弧度
alpha_sin = sin(alpha_radian);
alpha_cos = cos(alpha_radian);

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

% 接收机初始空间坐标
[x_rx, y_rx] = deal(0, 0);
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
% 最大采样间隔距离 单位m
d_max = v_rx / samp_rate;
% 仿真网格长度 单位m
grid_width = sampling_distance;
% 仿真网格点数
num_points_width = ceil(grid_width / d_max);



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
if is_addnoise
    % 添加噪声到信号
    sig_rx_ch1_noisy = FUNC_AddGaussianNoise(sig_rx_ch1, snr_value);
else
    sig_rx_ch1_noisy = sig_rx_ch1;
end



% ##########################测向信号截取##########################
% 信号A和B分别对应的时间向量
tv_sigA = time_vector(1 : single_sampling_points);
tv_sigB = time_vector((1 + interval_points) : ...
    (interval_points + single_sampling_points));

% 信号截取索引
idx_A_head = 1;
idx_A_tail = single_sampling_points;
idx_B_head = 1 + interval_points;
idx_B_tail = interval_points + single_sampling_points;

% 截取信号
sigA_ch1 = sig_rx_ch1_noisy(idx_A_head : idx_A_tail);

sigB_ch1 = sig_rx_ch1_noisy(idx_B_head : idx_B_tail);



% ##########################频率检测##########################
% 双通道信号相加
sigA_sum = sigA_ch1;
sigB_sum = sigB_ch1;

% 计算信号功率谱及其对应频率向量
[fv_sigA, pspectrum_sigA] = FUNC_TransForm2PowerSpectrum( ...
    sigA_sum, samp_rate);
[fv_sigB, pspectrum_sigB] = FUNC_TransForm2PowerSpectrum( ...
    sigB_sum, samp_rate);

% 查找功率谱峰及其对应频点
[freq_sigA, ppower_sigA] = FUNC_FindMaxPeak(fv_sigA, pspectrum_sigA);
[freq_sigB, ppower_sigB] = FUNC_FindMaxPeak(fv_sigB, pspectrum_sigB);
if isnan(freq_sigA)
    freq_sigA = freq_sigB;
    ppower_sigA = 0;
end
if isnan(freq_sigB)
    freq_sigB = freq_sigA;
    ppower_sigB = 0;
end



% ##########################带通滤波##########################
if is_bandpassfilter
    % 滤波
    [sigA_ch1_filtered, filter_b] = FUNC_BandpassFilter( ...
        sigA_ch1, frequency, samp_rate);
    
    [sigB_ch1_filtered, ~] = FUNC_BandpassFilter( ...
        sigB_ch1, frequency, samp_rate);
else
    sigA_ch1_filtered = sigA_ch1;
    sigB_ch1_filtered = sigB_ch1;
end



% ##########################相干积累##########################
% 相干积累信号对应的时间向量
tv_sigA_integration = tv_sigA(end-coherent_integration_points+1 : end);
tv_sigB_integration = tv_sigB(end-coherent_integration_points+1 : end);

% 相干积累
sigA_ch1_integration = FUNC_SignalCoherentIntegration( ...
    sigA_ch1_filtered, coherent_integration_points, coherent_integration_number);

sigB_ch1_integration = FUNC_SignalCoherentIntegration( ...
    sigB_ch1_filtered, coherent_integration_points, coherent_integration_number);



% ##########################测向算法##########################
% 时延比相测向算法
sigA_integration_sum = sigA_ch1_integration;
sigB_integration_sum = sigB_ch1_integration;
[~, doa_phase_angle] = FUNC_DF2D_SignalDelayPhaseComparing( ...
    sigB_integration_sum, sigA_integration_sum, frequency, ...
    delta_t, sampling_interval, c);



% ##########################输出结果##########################
if is_fprintf
    fprintf('频率检测A = %.2fHz\n', freq_sigA);
    fprintf('频率检测B = %.2fHz\n', freq_sigB);
    fprintf('实际角度[0, 180) = %.2f°\n', alpha_angle);
    fprintf('比相算法角度[0, 180) = %.2f°\n', doa_phase_angle);
end



% ##########################绘图##########################
if is_figure
    % close all;
    % 信号绘图统一点数
    plot_points = coherent_integration_points;


    % 原始信号和加噪信号
    figure;

    subplot(2, 1, 1);
    plot(time_vector(1:plot_points), sig_rx_ch1(1:plot_points), ...
        'DisplayName', '接收信号');
    hold on;
    plot(time_vector(1:plot_points), sig_rx(1:plot_points), ...
        'DisplayName', '原始信号');
    hold off;
    legend('show');
    xlabel('时间 (s)');
    ylabel('幅值');
    title('时域信号');
    xlim([time_vector(1) time_vector(plot_points)]);
    ylim([-2 2]);
    grid on;

    subplot(2, 1, 2);
    plot(time_vector(1:plot_points), sig_rx_ch1_noisy(1:plot_points), ...
        'DisplayName', '通道1');
    legend('show');
    xlabel('时间 (s)');
    ylabel('幅值');
    title(['高斯加噪信号 (SNR = ' num2str(snr_value) ' dB) ']);
    xlim([time_vector(1) time_vector(plot_points)]);
    ymax = ceil(max(abs(sig_rx_ch1_noisy)));
    ylim([-ymax ymax]);
    grid on;


    % 截取信号A和B
    figure;

    subplot(2, 1, 1);
    plot(tv_sigA(1:plot_points), sigA_ch1(1:plot_points));
    xlabel('时间 (s)');
    ylabel('幅值');
    title('截取接收信号A');
    xlim([tv_sigA(1) tv_sigA(plot_points)]);
    ymax = ceil(max(abs(sigA_ch1)));
    ylim([-ymax ymax]);
    grid on;

    subplot(2, 1, 2);
    plot(tv_sigB(1:plot_points), sigB_ch1(1:plot_points));
    xlabel('时间 (s)');
    ylabel('幅值');
    title('截取接收信号B');
    xlim([tv_sigB(1) tv_sigB(plot_points)]);
    ymax = ceil(max(abs(sigB_ch1)));
    ylim([-ymax ymax]);
    grid on;

    
    % 截取信号A和B频谱
    figure;

    subplot(2, 1, 1);
    plot(fv_sigA, pspectrum_sigA);
    xlabel('频率 (Hz)');
    ylabel('幅值');
    title('截取接收信号A频谱');
    grid on;

    subplot(2, 1, 2);
    plot(fv_sigB, pspectrum_sigB);
    xlabel('频率 (Hz)');
    ylabel('幅值');
    title('截取接收信号B频谱');
    grid on;


if is_bandpassfilter
    % 滤波器频率响应和相位相应
    figure;
    freqz(filter_b, 1, 1024, samp_rate);


    % 带通滤波信号A和B
    figure;

    subplot(2, 1, 1);
    plot(tv_sigA(1:plot_points), sigA_ch1_filtered(1:plot_points));
    xlabel('时间 (s)');
    ylabel('幅值');
    title('带通滤波信号A');
    xlim([tv_sigA(1) tv_sigA(plot_points)]);
    ylim([-2 2]);
    grid on;

    subplot(2, 1, 2);
    plot(tv_sigB(1:plot_points), sigB_ch1_filtered(1:plot_points));
    xlabel('时间 (s)');
    ylabel('幅值');
    title('带通滤波信号B');
    xlim([tv_sigB(1) tv_sigB(plot_points)]);
    ylim([-2 2]);
    grid on;
end


    % 相干积累信号A和B
    figure;

    subplot(2, 1, 1);
    plot(tv_sigA_integration, sigA_ch1_integration);
    xlabel('时间 (s)');
    ylabel('幅值');
    title('相干积累信号A');
    xlim([tv_sigA_integration(1) tv_sigA_integration(end)]);
    ylim([-2 2]);
    grid on;

    subplot(2, 1, 2);
    plot(tv_sigB_integration, sigB_ch1_integration);
    xlabel('时间 (s)');
    ylabel('幅值');
    title('相干积累信号B');
    xlim([tv_sigB_integration(1) tv_sigB_integration(end)]);
    ylim([-2 2]);
    grid on;
end

% 仿真计时结束
toc;
