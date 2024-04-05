% clc;
clear;
% close all;

% 计时开始
tic;

% ##########################可视化选择##########################
is_plot_angle_error = 1;

% ##########################读取数据文件##########################
% 指定.mat文件的路径
matFilePath = 'matlab/simulation_results/SIMDATA-240405_011756-DynamicPhaseComparingDF_Ave_Freq_180x4x1000x2e2_CI1x100_-15dB.mat';

% 从.mat文件中加载数据
load(matFilePath);

% ##########################确定二维变量##########################
var_list = frequency./1e3;
var_displayname = '%.0f kHz';
var_titlename = '信号频率';

% ##########################角度误差图##########################
if is_plot_angle_error
    figure;
    hold on; % 保持当前图形
    
    % 预定义颜色数组或使用MATLAB颜色图
    colors = lines(size(doa_phase_angle, 2)); % 'lines'是MATLAB内置的颜色图之一
    
    % 测向误差计算角度数量
    % meanErrorPhase_N = length(alpha_angle);

    % 总平均误差
    meanmeanErrorPhase = zeros(size(doa_phase_angle, 2), 1);

    linelist = ["-", "--", "-.", ":"];
    
    % 遍历第二维（如SNR或CIN或SR值）
    for var_index = 1 : size(doa_phase_angle, 2)-1
        % 计算时延比相测向误差的平均值
        meanErrorPhase = mean(abs(doa_phase_angle(:, var_index, :) - ...
            repmat(reshape(alpha_angle, [length(alpha_angle), 1, 1]), ...
            [1, 1, size(doa_phase_angle, 3)])), 3);
        % 绘制时延比相测向误差曲线
        plot(alpha_angle, meanErrorPhase, ...
            linelist(var_index), ...
            'Color', colors(var_index, :), ...
            'LineWidth', 1, ...
            'DisplayName', sprintf(var_displayname, var_list(var_index)));

        % 记录总平均误差
        meanmeanErrorPhase(var_index) = mean(meanErrorPhase);
    end
    
    hold off;
    xlabel('Expected (°)');
    ylabel('Average Absolute Error (°)');
    xlim([alpha_angle(1) alpha_angle(end)]);
    ylim([0 3]);
    grid on;
    
    % 美化
    title(' ');
    legend('show', ...
        'Location', 'southoutside', ...
        'NumColumns', 4, ...
        'box', 'off');
    set(gcf, 'unit', 'centimeters', 'position', [10 5 12 12]);
    
    % 打印总平均误差
    fprintf(['    ' var_titlename '   比相误差\n']);
    disp([var_list.' meanmeanErrorPhase]);
end


% 计时结束
toc;
