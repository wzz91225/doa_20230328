% clc;
clear;
% close all;

% 初始化并行池（如果尚未启动）
if isempty(gcp('nocreate'))
    % 使用默认设置启动并行池
    parpool;
end

% 仿真计时开始
tic;

% ##########################参数定义##########################
% 信号源与接收机比相时相对角度alpha 范围[0, 180)
alpha_angle = (0:1:179);

% 光速 单位m/s
c = 299792458;


% 信号源频率 单位Hz
frequency = 3.2e4;
% 接收机信号采样率 单位Hz
samp_rate = frequency * 200;
% 信号源与接收机比相时相对距离d_r 单位m
d_relative = [2 20 200] .* c ./ frequency;    % 20倍正弦信号波长


% 接收机水平移动速度 单位m/s
v_rx = 10e3;

% 高斯加噪信噪比SNR 单位dB
snr_value = -15;

% 接收机比相相干积累序列数
coherent_integration_number = 1;
% 接收机比相相干积累每序列包含正弦信号序列周期数
coherent_integration_cycles = 100;

% (option) 是否使用带通滤波器（无输入则使用）
is_bandpassfilter = 0;
% % (option) 带通滤波器阶数（无输入或≤0则自动配置）
% filter_n = 200;

% ##########################仿真##########################
% 仿真次数
sim_num = 1000;

% 测向结果数组初始化
doa_phase_angle = ...
    zeros(length(alpha_angle), length(d_relative), sim_num);
doa_phase_angle_ave = ...
    zeros(length(alpha_angle), length(d_relative));

% 并行循环仿真
len_alpha_angle = length(alpha_angle);
len_d_relative = length(d_relative);
% for i = 1 : len_alpha_angle
parfor i = 1 : len_alpha_angle
    for j = 1 : len_d_relative
        tmp_doa_phase_angle = 0;
        tmp_d_relative = d_relative(j);
        
        
        for k = 1 : sim_num
            [tmp1] = ...
                FUNC_SIM_DynamicPhaseComparingDirectionFinding( ...
                c, frequency, samp_rate, alpha_angle(i), ...
                tmp_d_relative, v_rx, snr_value, ...
                coherent_integration_number, coherent_integration_cycles, ...
                is_bandpassfilter);
            
            doa_phase_angle(i, j, k) = tmp1;

            tmp_doa_phase_angle = tmp_doa_phase_angle + tmp1;
        end
        
        doa_phase_angle_ave(i, j) = tmp_doa_phase_angle / sim_num;
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
        'SIMDATA-%s-DynamicPhaseComparingDF_Ave_Dist.mat', ...
        currentTime);
    
    % 保存相关变量到文件
    save(fileName, 'sim_num', 'sim_timing', ...
        'doa_phase_angle', ...
        'doa_phase_angle_ave', ...
        'c', 'frequency', 'samp_rate', 'alpha_angle', ...
        'd_relative', 'v_rx', 'snr_value', ...
        'coherent_integration_number', 'coherent_integration_cycles', ...
        'is_bandpassfilter');
end
