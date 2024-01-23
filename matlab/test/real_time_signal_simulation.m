function real_time_signal_simulation
    % 创建图形界面和轴
    hFig = figure('Name', '实时信号仿真', 'NumberTitle', 'off');
    hAx = axes('Parent', hFig, 'Position', [0.1 0.3 0.8 0.6]);
    grid on;

    % 初始参数
    fs = 1000;        % 采样率
    t = 0:1/fs:1;     % 时间向量

    % 创建滑块和标签 - 频率
    hSliderFreq = uicontrol('Parent', hFig, 'Style', 'slider', 'Min', 1, 'Max', 10, 'Value', 5, ...
        'Position', [100 50 120 20], 'Callback', @(src, evt) updateSignal);
    uicontrol('Parent', hFig, 'Style', 'text', 'Position', [100 75 120 20], 'String', '频率');

    % 创建滑块和标签 - 噪声
    hSliderNoise = uicontrol('Parent', hFig, 'Style', 'slider', 'Min', 0, 'Max', 1, 'Value', 0.2, ...
        'Position', [300 50 120 20], 'Callback', @(src, evt) updateSignal);
    uicontrol('Parent', hFig, 'Style', 'text', 'Position', [300 75 120 20], 'String', '噪声标准差');

    % 更新信号和绘图
    function updateSignal
        f = get(hSliderFreq, 'Value');
        noise_std = get(hSliderNoise, 'Value');

        y = sin(2*pi*f*t);  % 正弦波
        noise = noise_std * randn(size(t));  % 高斯噪声
        y_noisy = y + noise;  % 带噪声的信号

        plot(hAx, t, y_noisy);
        xlabel(hAx, '时间 (秒)');
        ylabel(hAx, '幅度');
        title(hAx, ['频率: ' num2str(f) ' Hz, 噪声标准差: ' num2str(noise_std)]);
        grid on;
    end

    % 初始绘图
    updateSignal;
end
