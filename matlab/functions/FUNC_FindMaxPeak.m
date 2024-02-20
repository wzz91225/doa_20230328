function [max_peak_frequency, max_peak_power] = ...
    FUNC_FindMaxPeak(freq, power_spectrum)
% 查找信号的功率谱中的最大谱峰及其对应的频率和功率值
% 参数:
% - freq: 频率轴的值
% - power_spectrum: 信号的功率谱
% 返回值:
% - max_peak_frequency: 最大谱峰的频率
% - max_peak_power: 最大谱峰的功率值

% [pks, locs] = findpeaks(power_spectrum, 'MinPeakHeight', 0); % 'MinPeakHeight'可根据实际情况调整
[pks, locs] = findpeaks(power_spectrum);

if ~isempty(locs)
    % 找到最大谱峰的索引
    [~, idx] = max(pks);
    
    % 获取最大谱峰的频率和功率值
    max_peak_frequency = freq(locs(idx));
    max_peak_power = pks(idx);
else
    max_peak_frequency = NaN;
    max_peak_power = NaN;
end

end
