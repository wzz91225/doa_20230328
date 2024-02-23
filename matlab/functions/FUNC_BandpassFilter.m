function [signal_filtered, filter_b] = FUNC_BandpassFilter(signal, frequency, samp_rate, filter_n)
%FUNC_BandpassFilter 带通滤波器
%   signal_filtered 输出带通滤波信号
%   filter_b        输出带通滤波器分子系数（分母系数为1）
%   signal          输入信号
%   frequency       输入中心频率（Hz）
%   samp_rate       输入采样率（Hz）
%   filter_n        滤波器阶数

% 滤波器参数定义
filter_f1 = frequency * 0.9;        % 低截止频率 (Hz)
filter_f2 = frequency * 1.1;        % 高截止频率 (Hz)
% 检查是否提供滤波器阶数
if nargin < 4
    filter_n =  samp_rate / frequency * 2;  % 滤波器阶数
end
% 计算归一化截止频率
filter_w1 = filter_f1 / (samp_rate / 2);
filter_w2 = filter_f2 / (samp_rate / 2);
% 设计带通滤波器系数
filter_b = fir1(filter_n, [filter_w1, filter_w2], 'bandpass', hamming(filter_n+1));
% 滤波
signal_filtered = filter(filter_b, 1, signal);

% % 查看滤波器的频率响应
% figure
% freqz(filter_b, 1, 1024, samp_rate);

end