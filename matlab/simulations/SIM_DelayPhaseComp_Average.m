clc;
clear;

snr_value = 0;
average_num = 1;
sampling_periods = 10;

i = 0;
for relative_DoA = 0:1:179
    sum = 0;
    for j = 1:average_num
        sum = sum + FUNC_SIM_DelayPhaceComp(relative_DoA, snr_value, sampling_periods);
    end
    i = i+1;
    doa_angle(i) = sum / average_num
end
figure(1);
plot(doa_angle);
hold on;
plot((0:1:179));
hold off;
axis([0 180 0 180]);
grid on;
