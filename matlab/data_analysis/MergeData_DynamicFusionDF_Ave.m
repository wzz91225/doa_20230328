% clc;
% clear;
% close all;

% 使用uigetfile让用户选择两个.mat文件
[file1, path1] = uigetfile('matlab/simulation_results/*.mat', 'Select the first data file');
[file2, path2] = uigetfile('matlab/simulation_results/*.mat', 'Select the second data file'); % 假设两个文件在同一文件夹

% 检查用户是否取消选择
if isequal(file1, 0) || isequal(file2, 0)
    error('File selection canceled by the user');
end

% 完整路径
fullPath1 = fullfile(path1, file1);
fullPath2 = fullfile(path2, file2);

% 加载数据
data1 = load(fullPath1);
data2 = load(fullPath2);

% 假定相同变量直接从第一个数据文件中获取
c = data1.c;
frequency = data1.frequency;
samp_rate = data1.samp_rate;
d_relative = data1.d_relative;
v_rx = data1.v_rx;
snr_value = data1.snr_value;
coherent_integration_number = data1.coherent_integration_number;
coherent_integration_cycles = data1.coherent_integration_cycles;

% 计算新的sim_timing
sim_timing = data1.sim_timing + data2.sim_timing;

if isequal(data1.alpha_angle, data2.alpha_angle)
    % alpha_angle角度数组一致
    alpha_angle = data1.alpha_angle;

    % 计算新的sim_num
    sim_num = data1.sim_num + data2.sim_num;

    % 合并doa_phase_angle和doa_amplitude_angle变量
    doa_phase_angle = cat(3, data1.doa_phase_angle, data2.doa_phase_angle);
    doa_amplitude_angle = cat(3, data1.doa_amplitude_angle, data2.doa_amplitude_angle);
else
    % alpha_angle角度数组不同（假定小在前大在后），则合并alpha_angle
    alpha_angle = [data1.alpha_angle, data2.alpha_angle];

    % 如何仿真次数不同
    if data1.sim_num ~= data2.sim_num
        error('data1.sim_num ~= data2.sim_num');
    else
        sim_num = data1.sim_num;
    end

    % 根据新的alpha_angle长度更新doa_phase_angle和doa_amplitude_angle
    % 由于第一维（alpha_angle的长度）不同，我们需要在这一维进行合并
    doa_phase_angle = cat(1, data1.doa_phase_angle, data2.doa_phase_angle);
    doa_amplitude_angle = cat(1, data1.doa_amplitude_angle, data2.doa_amplitude_angle);
end

% 计算新的平均角度变量
doa_phase_angle_ave = mean(doa_phase_angle, 3);
doa_amplitude_angle_ave = mean(doa_amplitude_angle, 3);

% 保存所有变量到新的文件，这次也让用户选择保存位置
savePath = uigetdir(path1, 'Select folder to save merged data file');
if savePath == 0
    error('Save folder selection canceled by the user');
end
% 获取当前系统时间
currentTime = datetime('now', 'TimeZone', 'local', ...
    'Format', 'yyMMdd_HHmmss');
newFileName = fullfile(savePath, ...
    sprintf('SIMDATA-%s-DynamicFusionDF_Ave_merged.mat', currentTime));
save(newFileName, 'sim_num', 'sim_timing', ...
    'doa_phase_angle', 'doa_amplitude_angle', ...
    'doa_phase_angle_ave', 'doa_amplitude_angle_ave', ...
    'c', 'frequency', 'samp_rate', 'alpha_angle', ...
    'd_relative', 'v_rx', 'snr_value', ...
    'coherent_integration_number', 'coherent_integration_cycles');
