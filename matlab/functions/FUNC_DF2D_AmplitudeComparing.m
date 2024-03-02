function [radian, angle, frequency_ch1, frequency_ch2] = ...
    FUNC_DF2D_AmplitudeComparing( ...
    signal_ch1, signal_ch2, samp_rate)
% 基于双通道比幅测向算法测量信号方位角
% 参数:
% - signal_ch1: X轴天线通道信号
% - signal_ch2: Y轴天线通道信号
% - samp_rate: 信号的采样率(Hz)
% 返回值:
% - radian: 方位弧度
% - angle: 方位角度
% - frequency_ch1: 通道1信号比较频点
% - frequency_ch2: 通道2信号比较频点

% 计算双通道功率谱
[freq, pspectrum_ch1] = FUNC_TransForm2PowerSpectrum( ...
    signal_ch1, samp_rate);
[~, pspectrum_ch2] = FUNC_TransForm2PowerSpectrum( ...
    signal_ch2, samp_rate);

% 查找功率谱峰及其对应频点
[frequency_ch1, max_peak_power_ch1] = ...
    FUNC_FindMaxPeak(freq, pspectrum_ch1);
[frequency_ch2, max_peak_power_ch2] = ...
    FUNC_FindMaxPeak(freq, pspectrum_ch2);
if isnan(max_peak_power_ch1)
    max_peak_power_ch1 = 0;
    frequency_ch1 = frequency_ch2;
end
if isnan(max_peak_power_ch2)
    max_peak_power_ch2 = 0;
    frequency_ch2 = frequency_ch1;
end

% 计算方位角
amplitude_ch1 = sqrt(max_peak_power_ch1);
amplitude_ch2 = sqrt(max_peak_power_ch2);
radian = atan2(amplitude_ch2, amplitude_ch1);
angle = rad2deg(radian);

end
