% clc;
clear;
% close all;

% 计时开始
tic;

% ##########################可视化选择##########################
is_plot_angle = 1;
is_plot_angle_ave = 0;
is_plot_angle_error = 0;

% ##########################读取数据文件##########################
% 指定.mat文件的路径
matFilePath = 'matlab/simulation_results/SIMDATA-240301_164630-DynamicPhaseComparingDF_Ave_SNR_180x1x1000x2e2_CI1x1_10dB.mat';

% 从.mat文件中加载数据
load(matFilePath);
% 检查是否含有需要的变量
if not(exist('doa_phase_angle', 'var') && ...
    exist('alpha_angle', 'var') && ...
    exist('sim_num', 'var') && ...
    exist('snr_value', 'var') && ...
    exist('coherent_integration_cycles', 'var') && ...
    exist('samp_rate', 'var'))
    error('Missing required variables.');
end

% ##########################确定二维变量##########################
if length(snr_value) > 1
    var_list = snr_value;
    var_displayname = '%d dB';
    var_titlename = '信噪比';
elseif length(coherent_integration_cycles) > 1
    var_list = coherent_integration_cycles;
    var_displayname = 'N_{Cyc} = %d';
    var_titlename = '信号周期数';
elseif length(samp_rate) > 1
    var_list = samp_rate./1e6;
    var_displayname = '%0.1f MHz';
    var_titlename = '采样率';
else
    var_list = snr_value;
    var_displayname = '%d dB';
    var_titlename = '信噪比';
end

% ##########################单次角度关系图##########################
if is_plot_angle
    % 绘制时延比相测向角度与角度的关系图
    figure;
    hold on;
    for i = 1:length(var_list)
        plot(alpha_angle, doa_phase_angle(:, i), ...
            'LineWidth', 1, ...
            'DisplayName', sprintf(var_displayname, var_list(i)));
    end
    hold off;
    xlabel('Expected (°)');
    ylabel('Result (°)');
    % legend('show');
    grid on;
    xlim([0 180]);
    ylim([0 180]);
    set(gcf, 'unit', 'centimeters', 'position', [10 5 12 10.2]);
end


% 计时结束
toc;
