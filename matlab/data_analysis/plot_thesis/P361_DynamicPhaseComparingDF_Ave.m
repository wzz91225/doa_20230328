% clc;
clear;
% close all;

% 计时开始
tic;

% ##########################可视化选择##########################
is_plot_angle = 1;
is_plot_angle_ave = 0;
is_plot_angle_error = 1;

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
    % subplot(1,2,1);
    hold on;
    for i = 1:length(var_list)
        plot(alpha_angle, doa_phase_angle(:, i), ...
            'LineWidth', 1.5, ...
            'DisplayName', sprintf(var_displayname, var_list(i)));
    end
    hold off;
    xlabel('\fontname{宋体}期望角度 \fontname{Times New Roman}(°)', 'FontSize', 10.5);
    ylabel('\fontname{宋体}动态比相算法测向结果 \fontname{Times New Roman}(°)', 'FontSize', 10.5);
    xticks((0:30:180));
    yticks((0:30:180));
    xlim([0 180]);
    ylim([0 180]);
    grid on;
    box on;
    set(gca, ...
        'FontName', 'Times New Roman', ...
        'FontSize', 10.5, ...
        'LineWid', 1);
    set(gcf, 'unit', 'centimeters', 'position', [10 5 12 10.2]);
    % set(gcf, 'unit', 'centimeters', 'position', [10 5 24 10]);
end


% ##########################角度误差图##########################
if is_plot_angle_error
    figure;
    % subplot(1,2,2);
    hold on; % 保持当前图形
    
    % 预定义颜色数组或使用MATLAB颜色图
    colors = lines(size(doa_phase_angle, 2)); % 'lines'是MATLAB内置的颜色图之一
    
    % 测向误差计算角度数量
    % meanErrorPhase_N = length(alpha_angle);

    % 总平均误差
    meanmeanErrorPhase = zeros(size(doa_phase_angle, 2), 1);

    linelist = ["-", "--", "-.", ":"];
    
    % 遍历第二维（如SNR或CIN或SR值）
    for var_index = 1 : 1 : 1
        % 计算时延比相测向误差的平均值
        meanErrorPhase = mean(abs(doa_phase_angle(:, var_index, :) - ...
            repmat(reshape(alpha_angle, [length(alpha_angle), 1, 1]), ...
            [1, 1, size(doa_phase_angle, 3)])), 3);
        % 绘制时延比相测向误差曲线
        plot(alpha_angle, meanErrorPhase, ...
            linelist(var_index), ...
            'Color', colors(var_index, :), ...
            'LineWidth', 1.5, ...
            'DisplayName', sprintf(var_displayname, var_list(var_index)));

        % 记录总平均误差
        meanmeanErrorPhase(var_index) = mean(meanErrorPhase);
    end
    
    hold off;
    xlabel('\fontname{宋体}期望角度 \fontname{Times New Roman}(°)', 'FontSize', 10.5);
    ylabel('\fontname{宋体}平均绝对误差 \fontname{Times New Roman}(°)', 'FontSize', 10.5);
    xticks((0:30:180));
    yticks((0:0.5:3));
    xlim([alpha_angle(1) alpha_angle(end)+1]);
    ylim([0 3]);
    grid on;
    box on;
    set(gca, ...
        'FontName', 'Times New Roman', ...
        'FontSize', 10.5, ...
        'LineWid', 1);
    set(gcf, 'unit', 'centimeters', 'position', [10 5 12 10.2]);
    
    % 打印总平均误差
    fprintf(['    ' var_titlename '   比相误差\n']);
    disp([var_list.' meanmeanErrorPhase]);
end

% 计时结束
toc;
