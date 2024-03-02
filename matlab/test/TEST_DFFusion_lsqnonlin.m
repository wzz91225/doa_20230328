clear;

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
    exist('alpha_angle', 'var'))
    error('Missing required variables.');
end

if ~isequal(alpha_angle, (0:1:179))
    error('Variable alpha_angle is not equal (1:1:179).');
end

var_index = 1;
% 计算时延比相测向误差的平均值
meanErrorPhase = mean(abs(doa_phase_angle(:, var_index, :) - ...
    repmat(reshape(alpha_angle, [length(alpha_angle), 1, 1]), ...
    [1, 1, size(doa_phase_angle, 3)])), 3);
% 计算比幅测向误差的平均值，考虑全部范围
alpha_angle_amp = [(0:1:90) (89:-1:1)];
meanErrorAmplitude = mean(abs(doa_amplitude_angle(:, var_index, :) - ...
    repmat(reshape(alpha_angle_amp, [length(alpha_angle_amp), 1, 1]), ...
    [1, 1, size(doa_amplitude_angle, 3)])), 3);

% xData和yData
xData = alpha_angle; % 测向角度数据
yData1 = meanErrorPhase.'; % 第一个算法的MAE数据
yData2 = meanErrorAmplitude.'; % 第二个算法的MAE数据


% ##########################读取数据文件##########################
% 初始参数估计
initialParams = [1, 1, 1]; % 根据实际情况进行调整

% 定义匿名函数，以适配lsqnonlin的输入格式
errorFunc = @(params) errorFunction(params, xData, yData1, yData2);

% 调用lsqnonlin
options = optimoptions('lsqnonlin', 'Display', 'iter');
[paramsOptimized,~,residuals,~,output] = lsqnonlin(errorFunc, initialParams, [], [], options);

% 使用优化后的参数来计算模型预测值
predictedOptimized = model(paramsOptimized, xData);

% 可视化结果，比较原始MAE和优化后的MAE
plot(xData, yData1, 'b-', xData, yData2, 'g-', xData, predictedOptimized, 'r--');
legend('算法1 MAE', '算法2 MAE', '优化后MAE');
xlabel('测向角度');
ylabel('MAE');
title('MAE优化比较');

