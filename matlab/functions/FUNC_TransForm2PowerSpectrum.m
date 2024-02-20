function [freq, power_spectrum] = ...
    FUNC_TransForm2PowerSpectrum(signal, samp_rate)
% 计算信号的功率谱，并只返回正频率部分。
% 参数:
% - signal: 输入信号
% - samp_rate: 信号的采样率
% 返回值:
% - freq: 频率轴的正频率值
% - power_spectrum: 信号的功率谱（仅正频率部分）

% 计算信号的FFT
fft_result = fft(signal);

% 计算频率轴
n = length(signal);
freq = (0:n-1)*(samp_rate/n);
half_n = floor(n/2);

% 只取正频率部分
freq = freq(1:half_n+1);
fft_result = fft_result(1:half_n+1);

% 计算功率谱（频谱的平方模）
power_spectrum = abs(fft_result).^2;

end
