clear;



%% ##########################读取数据文件##########################
% % 指定.mat文件的路径
matFilePath = 'C:\projects\doa_20230328\matlab\simulation_results\SIMDATA-240225_220537-DynamicFusionDF_Ave_180x7x1000x2e2_merged.mat';

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
% 计算时延比相测向的平均值
meanPhase = mean(doa_phase_angle(:, var_index, :), 3);
% 计算比幅测向误差的平均值
alpha_angle_amp = [(0:1:90) (89:-1:1)];
meanAmplitude = mean(doa_amplitude_angle(:, var_index, :), 3);

% 对折
meanPhase = meanPhase.';
meanAmplitude = meanAmplitude.';
for i = (1:89)
    meanPhase(i) = (meanPhase(i) + 180-meanPhase(180-i)) / 2;
    meanAmplitude(i) = (meanAmplitude(i) + meanAmplitude(180-i)) / 2;
end



%% ##########################数据提取##########################
% algorithm1Results 和 algorithm2Results 分别是两组算法的测向结果
algorithm1Results = meanAmplitude(1:90);
algorithm2Results =meanPhase(1:90);
% trueDirections 是真实测向数据
trueDirections = alpha_angle(1:90);



%% ##########################优化参数##########################
% 初始参数猜测
initialParams = 0.5; % 假设最初等权重融合

% 优化
options = optimset('Display', 'iter');
[optimalParam, minMSE] = fminsearch(@(params) calculateMSE(params, algorithm1Results, algorithm2Results, trueDirections), initialParams, options);



%% ##########################应用最优融合模型##########################
finalFusedResult = fuseModels(optimalParam, algorithm1Results, algorithm2Results);



%% ##########################验证分析##########################
% 计算融合结果的MSE
finalMSE = calculateMSE(optimalParam, algorithm1Results, algorithm2Results, trueDirections);

% 可视化比较
plot(trueDirections, 'k', 'LineWidth', 1);
hold on;
plot(algorithm1Results, 'b--');
plot(algorithm2Results, 'r--');
plot(finalFusedResult, 'g', 'LineWidth', 1);
legend('True Directions', 'Algorithm 1', 'Algorithm 2', 'Fused Result');
title(sprintf('Fusion Result Comparison, Final MSE: %.4f', finalMSE));
