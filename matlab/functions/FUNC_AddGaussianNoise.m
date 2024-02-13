function [signal_noisy, noise] = FUNC_AddGaussianNoise(signal, snr_value)
%FUNC_AddGaussianNoise 高斯加噪
%   signal_noisy    输出加噪信号
%   noise           输出噪声
%   noise           输入信号
%   snr_value       输入信噪比SNR(dB)

% 计算信号功率
signal_power = bandpower(signal);
% 计算噪声功率
noise_power = signal_power / (10^(snr_value/10));
% 生成高斯噪声
noise = sqrt(noise_power) * randn(size(signal));
% 添加噪声到信号
signal_noisy = signal + noise;

end