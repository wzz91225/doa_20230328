clc;
clear;

snr_value = 0;
average_num = 10;
sampling_periods = 100;

i = 0;
for relative_DoA = 0:1:179
    sum = 0;
    for j = 1:average_num
        sum = sum + FUNC_SIM_DelayPhaceComp(relative_DoA, snr_value, sampling_periods);
    end
    i = i+1;
    doa_angle(i) = sum / average_num
end
% doa_angle