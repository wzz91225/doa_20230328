% clc;
clear;
close all;

% 仿真计时开始
tic;


% ##########################仿真控制##########################
is_AddNoise = 0;



% ##########################参数定义##########################
% 光速 单位m/s
c = 299792458;

% 信号源频率 单位Hz
frequency = 315e6;
% 接收机信号采样率 单位Hz
samp_rate = 315e9;

% 信号源与接收机相对角度alpha 范围[0, 180)
alpha_angle = 112.5;
% 信号源与接收机相对距离d_r 单位m
d_relative = 20 * c / frequency;    % 20倍正弦信号波长

% 高斯噪声参数定义
snr_value = 30;     % 信噪比SNR(dB)

% 干涉仪基线长度
baseline_length = c / frequency / 2;

% 接收机采样正弦信号周期数
sampling_cycles = 10;
% 信号采样总时长 单位s
sampling_duration = sampling_cycles / frequency;



% ##########################仿真空间参数计算##########################
% 相对角度alpha相关参数
alpha_radian = deg2rad(alpha_angle);    % 弧度
alpha_sin = sin(alpha_radian);
alpha_cos = cos(alpha_radian);

% 空间坐标
[x_A, y_A] = deal(baseline_length, 0);
[x_B, y_B] = deal(-baseline_length, 0);
[x_S, y_S] = deal(d_relative * alpha_cos, d_relative * alpha_sin);

dis_AB = baseline_length;
dis_SA = sqrt((x_S - x_A)^2 + (y_S - y_A)^2);
dis_SB = sqrt((x_S - x_B)^2 + (y_S - y_B)^2);



% ##########################仿真时域参数计算##########################
% 仿真时长 单位s
sim_duration = sampling_duration;
% 信号源传播至接收机首次采样开始时间点
t_start = max(dis_SA, dis_SB) / c;
% 信号源传播至接收机首次采样开始时间点
t_end = max(dis_SA, dis_SB) / c + sim_duration;
% 仿真时间间隔 单位s
sim_time_interval = 1 / samp_rate;
% 仿真时间向量 单位s
time_vector = t_start : sim_time_interval : t_end;



% ##########################实时接收信号仿真##########################
% 初始化接收到的信号数组
sig_A = zeros(1, length(time_vector));
sig_B = zeros(1, length(time_vector));

% 模拟接收机在每个时间点接收到的信号
for i = 1 : length(time_vector)
    
    % 计算信号传播时间
    propagation_time_A = dis_SA / c ;
    propagation_time_B = dis_SB / c ;

    % 接收信号
    sig_A(i) = sin(2 * pi * frequency * ...
        (time_vector(i) - propagation_time_A));
    sig_B(i) = sin(2 * pi * frequency * ...
        (time_vector(i) - propagation_time_B));
end



% ##########################高斯加噪##########################
if is_AddNoise
% 添加噪声到信号
    sig_A_noisy = FUNC_AddGaussianNoise(sig_A, snr_value);
    sig_B_noisy = FUNC_AddGaussianNoise(sig_B, snr_value);
else
    sig_A_noisy = sig_A;
    sig_B_noisy = sig_B;
end



% ##########################测向算法##########################
% 比相
delta_phi = FUNC_ComparePhase(sig_A_noisy, sig_B_noisy);

[~, doa_angle] = FUNC_DF2D_PhaseComparing( ...
    delta_phi, frequency, baseline_length, c);



% ##########################输出结果##########################
delta_phi_angle = rad2deg(delta_phi);

fprintf('期望角度[0, 180) = %.2f°\n', alpha_angle);
fprintf('测向角度[0, 180) = %.2f°\n', doa_angle);
fprintf('相位差[-180, 180] = %.2f°\n', delta_phi_angle);



% ##########################绘图##########################
% 信号绘图统一点数
plot_points = floor(sim_duration / sim_time_interval);


% 原始信号和加噪信号
figure;

subplot(2, 1, 1);
plot(time_vector(1:plot_points), sig_A(1:plot_points), ...
    'DisplayName', '天线A');
hold on;
plot(time_vector(1:plot_points), sig_B(1:plot_points), ...
    'DisplayName', '天线B');
hold off;
legend('show');
xlabel('时间 (s)');
ylabel('幅值');
title('原始信号');
xlim([time_vector(1) time_vector(plot_points)]);
ylim([-2 2]);
grid on;

subplot(2, 1, 2);
plot(time_vector(1:plot_points), sig_A_noisy(1:plot_points), ...
    'DisplayName', '天线A');
hold on;
plot(time_vector(1:plot_points), sig_B_noisy(1:plot_points), ...
    'DisplayName', '天线B');
hold off;
legend('show');
xlabel('时间 (s)');
ylabel('幅值');
title(['加噪信号 (SNR = ' num2str(snr_value) ' dB) ']);
xlim([time_vector(1) time_vector(plot_points)]);
ymax = ceil(max(max(abs(sig_A_noisy)), max(abs(sig_B_noisy))));
ylim([-ymax ymax]);
grid on;



% 仿真计时结束
toc;
