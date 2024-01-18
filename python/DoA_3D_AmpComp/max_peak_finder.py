import numpy as np
from scipy.signal import find_peaks

def find_max_peak(freq, power_spectrum):
    """
    查找信号的功率谱中的最大谱峰及其对应的频率和功率值。

    参数:
    - freq (numpy数组): 频率轴的值
    - power_spectrum (numpy数组): 信号的功率谱

    返回值:
    - max_peak_frequency (float): 最大谱峰的频率
    - max_peak_power (float): 最大谱峰的功率值
    """
    # 查找最大谱峰
    peak_indices, _ = find_peaks(power_spectrum, height=0)  # height可根据实际情况调整
    
    if len(peak_indices) > 0:
        # 找到最大谱峰的索引
        max_peak_index = np.argmax(power_spectrum[peak_indices])
    
        # 获取最大谱峰的频率和功率值
        max_peak_frequency = freq[peak_indices[max_peak_index]]
        max_peak_power = power_spectrum[peak_indices[max_peak_index]]
    else:
        max_peak_frequency = None
        max_peak_power = None
    
    return max_peak_frequency, max_peak_power
