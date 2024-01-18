# 相关依赖库: numpy, scipy, matplotlib
# pip install numpy scipy matplotlib


# 导入库和模块
import numpy as np
import matplotlib.pyplot as plt
from sine_wave_generator import generate_sine_wave
from gaussian_noise_adder import add_gaussian_noise
from power_spectrum_transformer import transform_to_power_spectrum
from max_peak_finder import find_max_peak


# 采样相关参数
samp_rate = 32e6        # 采样率 32MHz
samp_duration = 0.001   # 采样时间 0.001s


# 单频信号参数
frequency = 32e3    # 频率 32kHz
# 生成单频正弦信号
t, sine_wave = generate_sine_wave(samp_rate, frequency, samp_duration)


# 信号到达角参数（方位角和俯仰角）
real_azimuth_angle = 30     # 方位角为30度
real_pitch_angle = 45       # 俯仰角为45度
# 生成三路信号（采样参数均相同）
real_azimuth_radian = np.radians(real_azimuth_angle)
real_pitch_radian = np.radians(real_pitch_angle)
signal_ch1 = sine_wave * np.sin(real_pitch_radian) * np.cos(real_azimuth_radian)
signal_ch2 = sine_wave * np.sin(real_pitch_radian) * np.sin(real_azimuth_radian)
signal_ch3 = sine_wave * np.cos(real_pitch_radian)
# 输出仿真设定实际角度
print(f"实际方位角 = {real_azimuth_angle:.2f}°")
print(f"实际俯仰角 = {real_pitch_angle:.2f}°")


# 高斯噪声参数
noise_amplitude = 0.5    # 噪声幅值
# 添加高斯噪声
signal_ch1, snr_ch1 = add_gaussian_noise(signal_ch1, noise_amplitude)
signal_ch2, snr_ch2 = add_gaussian_noise(signal_ch2, noise_amplitude)
signal_ch3, snr_ch3 = add_gaussian_noise(signal_ch3, noise_amplitude)
# 输出信噪比
print(f"SNR_ch1 = {snr_ch1:.2f} dB")
print(f"SNR_ch2 = {snr_ch2:.2f} dB")
print(f"SNR_ch3 = {snr_ch3:.2f} dB")


# 计算三通道功率谱
freq, pspectrum_ch1 = transform_to_power_spectrum(signal_ch1, samp_rate)
freq, pspectrum_ch2 = transform_to_power_spectrum(signal_ch2, samp_rate)
freq, pspectrum_ch3 = transform_to_power_spectrum(signal_ch3, samp_rate)


# 查找功率谱峰及其对应频点
max_peak_freq_ch1, max_peak_power_ch1 = find_max_peak(freq, pspectrum_ch1)
max_peak_freq_ch2, max_peak_power_ch2 = find_max_peak(freq, pspectrum_ch2)
max_peak_freq_ch3, max_peak_power_ch3 = find_max_peak(freq, pspectrum_ch3)
# 输出功率谱
if max_peak_freq_ch1 is None:
    print("ch1未找到谱峰")
elif max_peak_freq_ch2 is None:
    print("ch2未找到谱峰")
elif max_peak_freq_ch3 is None:
    print("ch3未找到谱峰")
else:
    print(f"ch1最大谱峰频率: {max_peak_freq_ch1:.2f} Hz, 功率值: {max_peak_power_ch1:.2f}")
    print(f"ch2最大谱峰频率: {max_peak_freq_ch2:.2f} Hz, 功率值: {max_peak_power_ch2:.2f}")
    print(f"ch3最大谱峰频率: {max_peak_freq_ch3:.2f} Hz, 功率值: {max_peak_power_ch3:.2f}")


# 计算方位角和俯仰角
amplitude_ch1 = np.sqrt(max_peak_power_ch1)
amplitude_ch2 = np.sqrt(max_peak_power_ch2)
amplitude_ch3 = np.sqrt(max_peak_power_ch3)
azimuth_angle = np.rad2deg(np.arctan2(amplitude_ch2, amplitude_ch1))
pitch_angle = np.rad2deg(np.arctan2(np.sqrt(np.square(amplitude_ch1) + \
                                            np.square(amplitude_ch2)), \
                                    amplitude_ch3))
# 输出结果
print(f"测量方位角 = {azimuth_angle:.2f}°")
print(f"测量俯仰角 = {pitch_angle:.2f}°")


# 绘制相关信号
plt.figure(figsize=(8, 16))
# 时域
plt.subplot(2, 1, 1)
plt.plot(t, signal_ch1, label='ch1')
plt.plot(t, signal_ch2, label='ch2')
plt.plot(t, signal_ch3, label='ch3')
plt.legend()
plt.title("Rx Signals")
plt.xlabel("Time (seconds)")
plt.ylabel("Amplitude")
plt.grid(True)
# 功率谱
plt.subplot(2, 1, 2)
plt.plot(freq, pspectrum_ch1, label='ch1')
plt.plot(freq, pspectrum_ch2, label='ch2')
plt.plot(freq, pspectrum_ch3, label='ch3')
plt.legend()
plt.title("Power Spectrum of Rx Signals")
plt.xlabel("Frequency (Hz)")
plt.ylabel("Power Spectrum")
plt.grid(True)
plt.xlim(0, frequency * 4)
# 显示
plt.show()

