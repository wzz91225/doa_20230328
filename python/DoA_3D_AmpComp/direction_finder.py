# 相关依赖库: numpy, scipy, matplotlib
# pip install numpy scipy matplotlib

import numpy as np
from power_spectrum_transformer import transform_to_power_spectrum
from max_peak_finder import find_max_peak


def find_derection(signal_ch1, signal_ch2, signal_ch3, samp_rate):
    """
    基于三通道比幅测向算法测量信号方位角和俯仰角。

    参数:
    - signal_ch1 (numpy数组): X轴天线通道信号
    - signal_ch2 (numpy数组): Y轴天线通道信号
    - signal_ch3 (numpy数组): Z轴天线通道信号
    - samp_rate (float): 信号的采样率(Hz)

    返回值:
    - azimuth_angle (float): 信号方位角度
    - pitch_angle (float): 信号俯仰角度
    """
    # 计算三通道功率谱
    freq, pspectrum_ch1 = transform_to_power_spectrum(signal_ch1, samp_rate)
    freq, pspectrum_ch2 = transform_to_power_spectrum(signal_ch2, samp_rate)
    freq, pspectrum_ch3 = transform_to_power_spectrum(signal_ch3, samp_rate)

    # 查找功率谱峰及其对应频点
    max_peak_freq_ch1, max_peak_power_ch1 = find_max_peak(freq, pspectrum_ch1)
    max_peak_freq_ch2, max_peak_power_ch2 = find_max_peak(freq, pspectrum_ch2)
    max_peak_freq_ch3, max_peak_power_ch3 = find_max_peak(freq, pspectrum_ch3)

    # 计算方位角和俯仰角
    amplitude_ch1 = np.sqrt(max_peak_power_ch1)
    amplitude_ch2 = np.sqrt(max_peak_power_ch2)
    amplitude_ch3 = np.sqrt(max_peak_power_ch3)
    azimuth_angle = np.rad2deg(np.arctan2(amplitude_ch2, amplitude_ch1))
    pitch_angle = np.rad2deg(np.arctan2(np.sqrt(np.square(amplitude_ch1) + \
                                                np.square(amplitude_ch2)), \
                                        amplitude_ch3))

    return azimuth_angle, pitch_angle



# 仿真示例用法
if __name__ == "__main__":
    ###############################导入库及函数###############################
    import matplotlib.pyplot as plt
    
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


    ###############################参数设置###############################
    # 采样相关参数
    samp_rate = 32e6        # 采样率 32MHz
    samp_duration = 0.001   # 采样时间 0.001s
    # 单频信号参数
    frequency = 32e3    # 频率 32kHz
    # 信号到达角参数（方位角和俯仰角）
    real_azimuth_angle = 30     # 方位角为30度
    real_pitch_angle = 45       # 俯仰角为45度
    # 高斯噪声参数
    noise_amplitude = 0.5    # 噪声幅值


    ###############################生成单频正弦信号###############################
    # 生成单频正弦信号
    t, sine_wave = generate_sine_wave(samp_rate, frequency, samp_duration)


    ###############################基于到达角度生成三路信号###############################
    # 生成三路信号（采样参数均相同）
    real_azimuth_radian = np.radians(real_azimuth_angle)
    real_pitch_radian = np.radians(real_pitch_angle)
    signal_ch1 = sine_wave * np.sin(real_pitch_radian) * np.cos(real_azimuth_radian)
    signal_ch2 = sine_wave * np.sin(real_pitch_radian) * np.sin(real_azimuth_radian)
    signal_ch3 = sine_wave * np.cos(real_pitch_radian)
    # 输出仿真设定实际角度
    print(f"实际方位角 = {real_azimuth_angle:.2f}°")
    print(f"实际俯仰角 = {real_pitch_angle:.2f}°")


    ###############################添加高斯噪声###############################
    # 添加高斯噪声
    signal_ch1, snr_ch1 = add_gaussian_noise(signal_ch1, noise_amplitude)
    signal_ch2, snr_ch2 = add_gaussian_noise(signal_ch2, noise_amplitude)
    signal_ch3, snr_ch3 = add_gaussian_noise(signal_ch3, noise_amplitude)
    # 输出信噪比
    print(f"SNR_ch1 = {snr_ch1:.2f} dB")
    print(f"SNR_ch2 = {snr_ch2:.2f} dB")
    print(f"SNR_ch3 = {snr_ch3:.2f} dB")


    ###############################三维比幅法测向###############################
    azimuth_angle, pitch_angle = \
        find_derection(signal_ch1, signal_ch2, signal_ch3, samp_rate)
    print(f"测量方位角 = {azimuth_angle:.2f}°")
    print(f"测量俯仰角 = {pitch_angle:.2f}°")
    

    ###############################绘制时域信号###############################
    plt.figure(figsize=(8, 8))
    plt.plot(t, signal_ch1, label='ch1')
    plt.plot(t, signal_ch2, label='ch2')
    plt.plot(t, signal_ch3, label='ch3')
    plt.legend()
    plt.title("Rx Signals")
    plt.xlabel("Time (seconds)")
    plt.ylabel("Amplitude")
    plt.grid(True)
    plt.show()
    
