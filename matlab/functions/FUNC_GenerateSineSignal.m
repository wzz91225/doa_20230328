function [sine_signal, time_vector] = FUNC_GenerateSineSignal(frequency, amplitude, sim_duration, samp_rate)
%FUNC_GenerateSineSignal 生成正弦信号
%   sine_signal     输出正弦信号
%   time_vector     输出时间向量
%   frequency       输入信号频率
%   amplitude       输入信号幅值
%   sim_duration    输入信号时长
%   samp_rate       输入采样率

% 时间向量
time_vector = 0 : 1/samp_rate : sim_duration;
% 生成正弦信号
sine_signal = amplitude * sin(2*pi*frequency*time_vector);

end