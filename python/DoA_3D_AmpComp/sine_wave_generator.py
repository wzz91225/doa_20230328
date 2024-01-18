import numpy as np

def generate_sine_wave(samp_rate, frequency, duration):
    """
    根据给定的采样率、频率和持续时间生成正弦波。

    参数:
    - sampling_rate (float): 采样率，单位是赫兹(Hz)
    - frequency (float): 正弦波的频率，单位是赫兹(Hz)
    - duration (float): 信号的总持续时间，单位是秒

    返回值:
    - t (numpy数组): 时间轴的值
    - sine_wave (numpy数组): 生成的正弦波值
    """
    t = np.arange(0, duration, 1 / samp_rate)
    sine_wave = np.sin(2 * np.pi * frequency * t)
    return t, sine_wave
