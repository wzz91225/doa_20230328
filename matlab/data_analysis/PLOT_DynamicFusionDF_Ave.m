% clc;
clear;
% close all;

% 计时开始
tic;

% ##########################读取数据文件##########################
% % 指定.mat文件的路径
% matFilePath = 'matlab/simulation_results/SIMDATA-240222_075811-DynamicFusionDF_Ave.mat';

% 弹出文件选择对话框让用户选择.mat文件
[fileName, filePath] = uigetfile('matlab/simulation_results/*.mat', ...
    'Select the MATLAB Data File');
% 完整的文件路径
matFilePath = fullfile(filePath, fileName);
% 检查用户是否取消了文件选择
if isequal(fileName, 0) || isequal(filePath, 0)
    error('User canceled file selection.');
end

% 从.mat文件中加载数据
load(matFilePath);
% 检查是否含有需要的变量
if not(exist('doa_phase_angle', 'var') && ...
    exist('doa_amplitude_angle', 'var') && ...
    exist('alpha_angle', 'var') && ...
    exist('snr_value', 'var') && ...
    exist('sim_num', 'var'))
    error('Missing required variables.');
end

% ##########################单次角度关系图##########################
% 绘制时延比相测向角度与角度的关系图
figure;
hold on;
for i = 1:length(snr_value)
    plot(alpha_angle, doa_phase_angle(:, i), ...
        'LineWidth', 1, ...
        'DisplayName', sprintf('%d dB', snr_value(i)));
end
hold off;
title('Phase DOA vs. Alpha Angle for Different SNR Values');
xlabel('Alpha Angle (degrees)');
ylabel('Phase DOA Angle Ave. (degrees)');
legend('show');
grid on;

% 绘制比幅测向角度与角度的关系图
figure;
hold on;
for i = 1:length(snr_value)
    plot(alpha_angle, doa_amplitude_angle(:, i), ...
        'LineWidth', 1, ...
        'DisplayName', sprintf('%d dB', snr_value(i)));
end
hold off;
title('Amplitude DOA vs. Alpha Angle for Different SNR Values');
xlabel('Alpha Angle (degrees)');
ylabel('Amplitude DOA Angle Ave. (degrees)');
legend('show');
grid on;

% ##########################平均角度关系图##########################
% 仿真次数>1
if sim_num > 1
    % 检查是否含有需要的变量
    if not(exist('doa_phase_angle_ave', 'var') && ...
        exist('doa_amplitude_angle_ave', 'var'))
        error('Missing doa_phase_angle_ave or doa_amplitude_angle_ave.');
    end

    % 绘制时延比相测向平均角度与角度的关系图
    figure;
    hold on;
    for i = 1:length(snr_value)
        plot(alpha_angle, doa_phase_angle_ave(:, i), ...
            'LineWidth', 1, ...
            'DisplayName', sprintf('%d dB', snr_value(i)));
    end
    hold off;
    title('Phase DOA vs. Alpha Angle Ave. for Different SNR Values');
    xlabel('Alpha Angle (degrees)');
    ylabel('Phase DOA Angle Ave. (degrees)');
    legend('show');
    grid on;

    % 绘制比幅测向平均角度与角度的关系图
    figure;
    hold on;
    for i = 1:length(snr_value)
        plot(alpha_angle, doa_amplitude_angle_ave(:, i), ...
            'LineWidth', 1, ...
            'DisplayName', sprintf('%d dB', snr_value(i)));
    end
    hold off;
    title('Amplitude DOA vs. Alpha Angle Ave. for Different SNR Values');
    xlabel('Alpha Angle (degrees)');
    ylabel('Amplitude DOA Angle Ave. (degrees)');
    legend('show');
    grid on;
end

% ##########################角度误差图##########################
figure;
hold on; % 保持当前图形

% 预定义颜色数组或使用MATLAB颜色图
colors = lines(size(doa_phase_angle, 2)); % 'lines'是MATLAB内置的颜色图之一

% 遍历所有SNR值
for snr_index = 1 : size(doa_phase_angle, 2)
    % 计算时延比相测向误差的平均值
    meanErrorPhase = mean(abs(doa_phase_angle(:, snr_index, :) - ...
        repmat(reshape(alpha_angle, [length(alpha_angle), 1, 1]), ...
        [1, 1, size(doa_phase_angle, 3)])), 3);
    % 绘制时延比相测向误差曲线
    plot(alpha_angle, meanErrorPhase, ...
        'Color', colors(snr_index, :), ...
        'LineWidth', 1, ...
        'DisplayName', sprintf('%d dB', snr_value(snr_index)));
    
    % 计算比幅测向误差的平均值，只考虑[0, 90]度的角度范围
    meanErrorAmplitude = mean(abs(doa_amplitude_angle(1:90, snr_index, :) - ...
        repmat(reshape(alpha_angle(1:90), [90, 1, 1]), ...
        [1, 1, size(doa_amplitude_angle, 3)])), 3);
    % 绘制比幅测向误差曲线
    plot(alpha_angle(1:90), meanErrorAmplitude, ...
        '--', ...
        'Color', colors(snr_index, :), ...
        'LineWidth', 1, ...
        'HandleVisibility', 'off');
end

hold off;
title('Mean Absolute Error of DOA Estimation for All SNR Values');
xlabel('Alpha Angle (degrees)');
ylabel('Mean Absolute Error (degrees)');
xlim([0 90]);
ylim([0 10]);
legend('show');
grid on;



% 计时结束
toc;
