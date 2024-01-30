
% 正弦基带信号定义
frequency = 3.2e4;  % 频率（Hz）
amplitude = 1;      % 振幅
% 生成基带信号
y1 = amplitude * sin(2*pi*frequency*t + 0);
phi = -pi/6
y2 = amplitude * sin(2*pi*frequency*t + phi);

N = length(y1); % 两个信号长度相同
halfN = floor(N/2) + 1; % 确保为整数
% 执行 FFT
Y1 = fft(y1);
Y2 = fft(y2);
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
phase_difference = phase2(idx2) - phase1(idx1);
% 将相位差转换到 [-pi, pi] 范围
phase_difference = mod(phase_difference + pi, 2*pi) - pi
