% 滤波器设计参数
samp_rate = 3200000;    % 采样频率 64 kHz
center_freq = 32000;  % 中心频率 32 kHz
bandwidth = center_freq*0.2;     % 带宽 4 kHz
n = samp_rate/center_freq*2;               % 滤波器阶数，可调整

% 计算归一化截止频率
f1 = (center_freq - bandwidth/2) / (samp_rate/2);
f2 = (center_freq + bandwidth/2) / (samp_rate/2);

% 设计带有 Hamming 窗的带通滤波器
filter_b = fir1(n, [f1, f2], 'bandpass', hamming(n+1));

% 可选：查看滤波器的频率响应
freqz(filter_b, 1, 1024, samp_rate);

% 假设 x 是您的带噪声的 32 kHz 正弦信号
% 应用滤波器
y_filtered = filter(filter_b, 1, x);
