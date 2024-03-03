% clc;
clear;
% close all;

% 计时开始
tic;

%% ##########################可视化选择##########################
is_plot_phase = 1;
is_plot_amplitude = 0;
is_plot_fusion = 1;

is_plot_angle = 0;
is_plot_angle_ave = 0;
is_plot_angle_error = 1;

% 比幅法是否只计算90度以下误差
is_amplitude_errorlessthan90 = 1;

%% ##########################读取数据文件##########################
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
    exist('sim_num', 'var') && ...
    exist('snr_value', 'var') && ...
    exist('coherent_integration_number', 'var') && ...
    exist('samp_rate', 'var'))
    error('Missing required variables.');
end

%% ##########################确定二维变量##########################
if length(snr_value) > 1
    var_list = snr_value;
    var_displayname = '%d dB';
    var_titlename = '信噪比';
elseif length(coherent_integration_number) > 1
    var_list = coherent_integration_number;
    var_displayname = 'N_{CI} = %d';
    var_titlename = '相干积累数';
elseif length(samp_rate) > 1
    var_list = samp_rate./1e6;
    var_displayname = '%0.1f MHz';
    var_titlename = '采样率';
end



%% ##########################测向融合##########################
if not(exist('doa_fusion_angle', 'var'))
    doa_fusion_angle = ...
        zeros(length(alpha_angle), length(var_list), sim_num);
    
    for i = 1 : length(alpha_angle)
        for j = 1 : length(var_list)
            for k = 1 : sim_num
                angle_amp = doa_amplitude_angle(i, j, k);
                angle_dyp = doa_phase_angle(i, j, k);
                doa_fusion_angle(i, j, k) = ...
                    FUNC_DF2D_DirectionFindingFusionModel(angle_amp, angle_dyp);
            end
        end
    end
    doa_fusion_angle_ave = mean(doa_fusion_angle, 3);
end



%% ##########################单次角度关系图##########################
if is_plot_angle
    if is_plot_phase
        % 绘制时延比相测向结果与预期角度的关系图
        figure;
        hold on;
        for i = 1:length(var_list)
            plot(alpha_angle, doa_phase_angle(:, i), ...
                'LineWidth', 1, ...
                'DisplayName', sprintf(var_displayname, var_list(i)));
        end
        hold off;
        title(['不同' var_titlename '下动态比相测向结果与预期角度的关系']);
        xlabel('预期角度（°）');
        ylabel('动态比相测向结果（°）');
        legend('show');
        grid on;
    end
    
    if is_plot_amplitude
        % 绘制比幅测向结果与预期角度的关系图
        figure;
        hold on;
        for i = 1:length(var_list)
            plot(alpha_angle, doa_amplitude_angle(:, i), ...
                'LineWidth', 1, ...
                'DisplayName', sprintf(var_displayname, var_list(i)));
        end
        hold off;
        title(['不同' var_titlename '下比幅测向结果与预期角度的关系']);
        xlabel('预期角度（°）');
        ylabel('比幅测向结果（°）');
        legend('show');
        grid on;
    end
    
    if is_plot_fusion
        % 绘制动态融合测向结果与预期角度的关系图
        figure;
        hold on;
        for i = 1:length(var_list)
            plot(alpha_angle, doa_fusion_angle(:, i), ...
                'LineWidth', 1, ...
                'DisplayName', sprintf(var_displayname, var_list(i)));
        end
        hold off;
        title(['不同' var_titlename '下动态融合测向结果与预期角度的关系']);
        xlabel('预期角度（°）');
        ylabel('动态融合测向结果（°）');
        legend('show');
        grid on;
    end
end

%% ##########################平均角度关系图##########################
% 仿真次数>1
if is_plot_angle_ave && (sim_num > 1)
    % 检查是否含有需要的变量
    if not(exist('doa_phase_angle_ave', 'var') && ...
        exist('doa_amplitude_angle_ave', 'var'))
        error('Missing doa_phase_angle_ave or doa_amplitude_angle_ave.');
    end

    if is_plot_phase
        % 绘制时延比相测向平均结果与预期角度的关系图
        figure;
        hold on;
        for i = 1:length(var_list)
            plot(alpha_angle, doa_phase_angle_ave(:, i), ...
                'LineWidth', 1, ...
                'DisplayName', sprintf(var_displayname, var_list(i)));
        end
        hold off;
        title(['不同' var_titlename '下动态比相平均测向结果与预期角度的关系']);
        xlabel('预期角度（°）');
        ylabel('动态比相平均测向结果（°）');
        legend('show');
        grid on;
    end

    if is_plot_amplitude
        % 绘制比幅测向平均结果与预期角度的关系图
        figure;
        hold on;
        for i = 1:length(var_list)
            plot(alpha_angle, doa_amplitude_angle_ave(:, i), ...
                'LineWidth', 1, ...
                'DisplayName', sprintf(var_displayname, var_list(i)));
        end
        hold off;
        title(['不同' var_titlename '下比幅平均测向结果与预期角度的关系']);
        xlabel('预期角度（°）');
        ylabel('比幅平均测向结果（°）');
        legend('show');
        grid on;
    end

    if is_plot_fusion
        % 绘制动态融合测向平均结果与预期角度的关系图
        figure;
        hold on;
        for i = 1:length(var_list)
            plot(alpha_angle, doa_fusion_angle_ave(:, i), ...
                'LineWidth', 1, ...
                'DisplayName', sprintf(var_displayname, var_list(i)));
        end
        hold off;
        title(['不同' var_titlename '下比动态融合测向结果与预期角度的关系']);
        xlabel('预期角度（°）');
        ylabel('动态融合测向结果（°）');
        legend('show');
        grid on;
    end
end

%% ##########################角度误差图##########################
if is_plot_angle_error
    figure;
    hold on; % 保持当前图形
    
    % 预定义颜色数组或使用MATLAB颜色图
    colors = lines(size(doa_phase_angle, 2)); % 'lines'是MATLAB内置的颜色图之一
    
    % 测向误差计算角度数量（比幅法仅计算90度及以下部分角度）
    % meanErrorPhase_N = length(alpha_angle);
    meanErrorAmplitude_N = 0;
    for i = 1 : length(alpha_angle)
        if alpha_angle(i) > 90
            break;
        end
        meanErrorAmplitude_N = meanErrorAmplitude_N + 1;
    end

    % 总平均误差
    meanmeanErrorPhase = zeros(size(doa_phase_angle, 2), 1);
    meanmeanErrorAmplitude = zeros( size(doa_phase_angle, 2), 1);
    meanmeanErrorFusion = zeros( size(doa_phase_angle, 2), 1);
    
    % 遍历第二维（如SNR或CIN或SR值）
    for var_index = 1 : size(doa_phase_angle, 2)

        % 计算动态融合测向误差的平均值
        meanErrorFusion = mean(abs(doa_fusion_angle(:, var_index, :) - ...
            repmat(reshape(alpha_angle, [length(alpha_angle), 1, 1]), ...
            [1, 1, size(doa_fusion_angle, 3)])), 3);
        if is_plot_fusion
            % 绘制动态融合测向误差曲线
            plot(alpha_angle, meanErrorFusion, ...
                'Color', colors(var_index, :), ...
                'LineWidth', 1, ...
                'DisplayName', sprintf(var_displayname, var_list(var_index)));
                % 'DisplayName', ['动态融合 ' sprintf(var_displayname, var_list(var_index))]);
        end

        % 计算动态比相测向误差的平均值
        meanErrorPhase = mean(abs(doa_phase_angle(:, var_index, :) - ...
            repmat(reshape(alpha_angle, [length(alpha_angle), 1, 1]), ...
            [1, 1, size(doa_phase_angle, 3)])), 3);
        if is_plot_phase
            % 绘制动态比相测向误差曲线
                plot(alpha_angle, meanErrorPhase, ...
                    ':', ...
                    'Color', colors(var_index, :), ...
                    'LineWidth', 1, ...
                    'HandleVisibility', 'off');
                    % 'DisplayName', ['动态比相 ' sprintf(var_displayname, var_list(var_index))]);
        end
        
        if is_amplitude_errorlessthan90
            % 计算比幅测向误差的平均值，只考虑≤90度范围
            tmp = meanErrorAmplitude_N;
            meanErrorAmplitude = mean(abs(doa_amplitude_angle(1:tmp, var_index, :) - ...
                repmat(reshape(alpha_angle(1:tmp), [tmp, 1, 1]), ...
                [1, 1, size(doa_amplitude_angle, 3)])), 3);
            if is_plot_amplitude
                % 绘制比幅测向误差曲线
                plot(alpha_angle(1:tmp), meanErrorAmplitude, ...
                    ':', ...
                    'Color', colors(var_index, :), ...
                    'LineWidth', 1, ...
                    'DisplayName', ['传统比幅 ' sprintf(var_displayname, var_list(var_index))]);
                    % 'HandleVisibility', 'off');
            end
        else
            % 计算比幅测向误差的平均值，考虑全部范围
            meanErrorAmplitude = mean(abs(doa_amplitude_angle(:, var_index, :) - ...
                repmat(reshape(alpha_angle, [length(alpha_angle), 1, 1]), ...
                [1, 1, size(doa_amplitude_angle, 3)])), 3);
            if is_plot_amplitude
                % 绘制比幅测向误差曲线
                plot(alpha_angle, meanErrorAmplitude, ...
                    ':', ...
                    'Color', colors(var_index, :), ...
                    'LineWidth', 1, ...
                    'DisplayName', ['传统比幅 ' sprintf(var_displayname, var_list(var_index))]);
                    % 'HandleVisibility', 'off');
            end
        end

        % 记录总平均误差
        meanmeanErrorFusion(var_index) = mean(meanErrorFusion);
        meanmeanErrorPhase(var_index) = mean(meanErrorPhase);
        meanmeanErrorAmplitude(var_index) = mean(meanErrorAmplitude);
    end
    
    hold off;
    title(['不同' var_titlename '下测向结果的平均绝对误差']);
    xlabel('预期角度（°）');
    ylabel('平均绝对误差（°）');
    xlim([alpha_angle(1) alpha_angle(end)]);
    ylim([0 5]);
    % legend('show');
    grid on;
    
    % 美化
    title(' ');
    legend('show', ...
        'Location', 'southoutside', ...
        'NumColumns',length(var_list), ...
        'box', 'off');
    set(gcf, 'unit', 'centimeters', 'position', [10 5 20 12]);
    % set(gcf, 'unit', 'centimeters', 'position', [10 5 20 13]);

    
    % 打印总平均误差
    fprintf(['    ' var_titlename '   比相误差' '   比幅误差' '   融合误差\n']);
    disp([var_list.' meanmeanErrorPhase meanmeanErrorAmplitude meanmeanErrorFusion]);
end


% 计时结束
toc;
