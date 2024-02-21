function [azimuth_angle, pitch_angle] = ...
    FUNC_DF3D_AmplitudeComparing( ...
    signal_ch1, signal_ch2, signal_ch3, samp_rate)
% 基于三通道比幅测向算法测量信号方位角和俯仰角
% 参数:
% - signal_ch1: X轴天线通道信号
% - signal_ch2: Y轴天线通道信号
% - signal_ch3: Z轴天线通道信号
% - samp_rate: 信号的采样率(Hz)
% 返回值:
% - azimuth_angle: 信号方位角度
% - pitch_angle: 信号俯仰角度

% 计算三通道功率谱
[freq, pspectrum_ch1] = FUNC_TransForm2PowerSpectrum(signal_ch1, samp_rate);
[~, pspectrum_ch2] = FUNC_TransForm2PowerSpectrum(signal_ch2, samp_rate);
[~, pspectrum_ch3] = FUNC_TransForm2PowerSpectrum(signal_ch3, samp_rate);

% 查找功率谱峰及其对应频点
[~, max_peak_power_ch1] = FUNC_FindMaxPeak(freq, pspectrum_ch1);
[~, max_peak_power_ch2] = FUNC_FindMaxPeak(freq, pspectrum_ch2);
[~, max_peak_power_ch3] = FUNC_FindMaxPeak(freq, pspectrum_ch3);
if isnan(max_peak_power_ch1)
    max_peak_power_ch1 = 0;
end
if isnan(max_peak_power_ch2)
    max_peak_power_ch2 = 0;
end
if isnan(max_peak_power_ch3)
    max_peak_power_ch3 = 0;
end

% 计算方位角和俯仰角
amplitude_ch1 = sqrt(max_peak_power_ch1);
amplitude_ch2 = sqrt(max_peak_power_ch2);
amplitude_ch3 = sqrt(max_peak_power_ch3);
azimuth_angle = rad2deg(atan2(amplitude_ch2, amplitude_ch1));
pitch_angle = rad2deg(atan2(sqrt(amplitude_ch1^2 + amplitude_ch2^2), ...
    amplitude_ch3));

end
