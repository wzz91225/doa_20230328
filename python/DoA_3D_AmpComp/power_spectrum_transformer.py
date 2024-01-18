import numpy as np

def transform_to_power_spectrum(signal, samp_rate):
    """
    计算信号的功率谱，并只返回正频率部分。

    参数:
    - signal (numpy数组): 输入信号
    - samp_rate (float): 信号的采样率

    返回值:
    - freq (numpy数组): 频率轴的正频率值
    - power_spectrum (numpy数组): 信号的功率谱（仅正频率部分）
    """
    # 计算信号的FFT
    fft_result = np.fft.fft(signal)
    
    # 计算频率轴
    freq = np.fft.fftfreq(len(signal), 1 / samp_rate)
    
    # 只取正频率部分
    n = len(signal)
    if n % 2 == 0:
        # 如果信号长度是偶数，取一半长度的频率和FFT结果
        freq = freq[:n//2]
        fft_result = fft_result[:n//2]
    else:
        # 如果信号长度是奇数，取一半长度加一的频率和FFT结果
        freq = freq[:(n//2) + 1]
        fft_result = fft_result[:(n//2) + 1]

    # 计算功率谱（频谱的平方模）
    power_spectrum = np.abs(fft_result)**2
    
    return freq, power_spectrum
