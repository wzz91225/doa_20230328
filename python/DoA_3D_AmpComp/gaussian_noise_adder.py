import numpy as np

def add_gaussian_noise(signal, noise_amplitude):
    """
    给信号添加指定幅值大小的高斯噪声并计算信噪比 (SNR)。

    参数:
    - signal (numpy数组): 原始信号
    - noise_amplitude (float): 噪声的幅值大小

    返回值:
    - noisy_signal (numpy数组): 带噪声的信号
    - snr (float): 信噪比 (SNR)
    """
    # 生成高斯噪声
    noise = np.random.normal(0, noise_amplitude, len(signal))
    
    # 添加噪声到信号
    noisy_signal = signal + noise
    
    # 计算信号功率
    signal_power = np.mean(signal**2)
    
    # 计算噪声功率
    noise_power = np.mean(noise**2)
    
    # 计算信噪比（SNR）
    snr = 10 * np.log10(signal_power / noise_power)
    
    return noisy_signal, snr
