function [phase_difference] = FUNC_ComparePhase(signal_cmp, signal_ref)
%FUNC_PhaseComparing 时延比相测向
%   phase_difference 输出范围为[-pi, pi]
%   signal_cmp 输入比较信号
%   signal_ref 输入参考信号
%   两个输入信号长度应相同

% 计算相位差
N = length(signal_cmp); % 两个信号长度应相同
halfN = floor(N/2) + 1; % 确保为整数
% 执行 FFT
Y1 = fft(signal_cmp);
Y2 = fft(signal_ref);
% 计算单边频谱的幅度
P1 = abs(Y1/N);
P2 = abs(Y2/N);
P1 = P1(1:halfN);
P2 = P2(1:halfN);
% 计算单边频谱的相位
phase1 = angle(Y1(1:halfN));
phase2 = angle(Y2(1:halfN));
% 找到主要频率成分（即幅度最大的频率）
[~, idx1] = max(P1);
[~, idx2] = max(P2);
% 比较两个信号在主要频率处的相位
phase_difference = phase1(idx1) - phase2(idx2);
% 将相位差转换到 [-pi, pi] 范围
phase_difference = mod(phase_difference + pi, 2*pi) - pi;

end