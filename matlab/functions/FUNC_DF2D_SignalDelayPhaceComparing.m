function [radian, angle] = FUNC_DF2D_SignalDelayPhaceComparing(signal_cmp, signal_ref, frequency, delta_t, distance, c)
%FUNC_DF2D_SignalDelayPhaceComparing 信号时延比相二维测向算法
%   

% 比相
phase_difference = FUNC_ComparePhace(signal_cmp, signal_ref);

% 测向
[radian, angle] = FUNC_DF2D_DelayPhaceComparing(phase_difference, frequency, delta_t, distance, c);

end