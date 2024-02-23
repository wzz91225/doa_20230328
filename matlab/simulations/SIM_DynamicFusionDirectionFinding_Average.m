% clc;
clear;
% close all;

% 初始化并行池（如果尚未启动）
if isempty(gcp('nocreate'))
    % 使用默认设置启动并行池(4 workers)
    parpool(4);
end

% 仿真计时开始
tic;

% ##########################常量定义##########################
% 光速 单位m/s
c = 299792458;

% 信号源频率 单位Hz
frequency = 3.2e4;
% 接收机信号采样率 单位Hz
samp_rate = 3.2e6;

% 信号源与接收机比相时相对距离d_r 单位m
d_relative = 20 * c / frequency;    % 20倍正弦信号波长
% 接收机水平移动速度 单位m/s
v_rx = 10e3;

% 接收机比相相干积累序列数
coherent_integration_number = 10;
% 接收机比相相干积累正弦信号序列周期数
coherent_integration_cycles = 10;

% ##########################变量定义##########################
% 信号源与接收机比相时相对角度alpha 范围[0, 180)
alpha_angle = (0:1:90);
% 高斯加噪信噪比SNR 单位dB
snr_value = (-25:5:0);

% ##########################仿真##########################
% 仿真次数
sim_num = 1000;

% 测向结果数组初始化
doa_phase_angle = ...
    zeros(length(alpha_angle), length(snr_value), sim_num);
doa_amplitude_angle = ...
    zeros(length(alpha_angle), length(snr_value), sim_num);
doa_phase_angle_ave = ...
    zeros(length(alpha_angle), length(snr_value));
doa_amplitude_angle_ave = ...
    zeros(length(alpha_angle), length(snr_value));

% 并行循环仿真
len_alpha_angle = length(alpha_angle);
len_snr_value = length(snr_value);
parfor i = 1 : len_alpha_angle
    for j = 1 : len_snr_value
        tmp_doa_phase_angle = 0;
        tmp_doa_amplitude_angle = 0;
        
        for k = 1 : sim_num
            [tmp1, tmp2] = ...
                FUNC_SIM_DynamicFusionDirectionFinding( ...
                c, frequency, samp_rate, alpha_angle(i), ...
                d_relative, v_rx, snr_value(j), ...
                coherent_integration_number, coherent_integration_cycles);
            
            doa_phase_angle(i, j, k) = tmp1;
            doa_amplitude_angle(i, j, k) = tmp2;

            tmp_doa_phase_angle = tmp_doa_phase_angle + tmp1;
            tmp_doa_amplitude_angle = tmp_doa_amplitude_angle + tmp2;
        end
        
        doa_phase_angle_ave(i, j) = tmp_doa_phase_angle / sim_num;
        doa_amplitude_angle_ave(i, j) = tmp_doa_amplitude_angle / sim_num;
    end
    % disp(i);
end

% 仿真计时结束
sim_timing = toc;
fprintf('仿真历时 %.6f 秒。\n', sim_timing);

% ##########################保存数据至文件##########################
if 1
    % 获取当前系统时间
    currentTime = datetime('now', 'TimeZone', 'local', ...
        'Format', 'yyMMdd_HHmmss');
    
    % 生成文件名，包含时间戳
    fileName = sprintf( ...
        'SIMDATA-%s-DynamicFusionDF_Ave.mat', ...
        currentTime);
    
    % 保存相关变量到文件
    save(fileName, 'sim_num', 'sim_timing', ...
        'doa_phase_angle', 'doa_amplitude_angle', ...
        'doa_phase_angle_ave', 'doa_amplitude_angle_ave', ...
        'c', 'frequency', 'samp_rate', 'alpha_angle', ...
        'd_relative', 'v_rx', 'snr_value', ...
        'coherent_integration_number', 'coherent_integration_cycles');
end
