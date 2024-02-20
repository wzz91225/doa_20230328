function [radian, angle] = FUNC_DF2D_SignalDelayPhaseComparing(signal_cmp, signal_ref, frequency, delta_t, distance, c)
%FUNC_DF2D_SignalDelayPhaseComparing 信号时延比相二维测向算法
%   

% 比相
phase_difference = FUNC_ComparePhase(signal_cmp, signal_ref);

% 测向
[radian, angle] = FUNC_DF2D_DelayPhaseComparing(phase_difference, frequency, delta_t, distance, c);

end