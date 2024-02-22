function [signal_integration] = ...
    FUNC_SignalCoherentIntegration( ...
    signal, coherent_integration_length, coherent_integration_number)
% 信号相干积累
% 参数:
% - signal: 原始信号
% - coherent_integration_length: 相干积累信号长度
% - coherent_integration_number: 接收机比相相干积累序列数
% 返回值:
% - signal_integration: 相干积累信号

% 初始化相干积累信号数组
signal_integration = zeros(1, coherent_integration_length);

% 相干积累
for i = 1 : coherent_integration_length
    for j = 1 : coherent_integration_number
        idx = coherent_integration_length * (j-1) + i;

        signal_integration(i) = signal_integration(i) + signal(idx);
    end
    signal_integration(i) = signal_integration(i) / ...
        coherent_integration_number;
end

end
