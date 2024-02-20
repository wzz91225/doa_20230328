function [radian, angle] = FUNC_DF2D_DelayPhaseComparing(delta_phi, frequency, delta_t, distance_antenna, c)
%FUNC_DF2D_DelayPhaseComparing 时延比相二维测向算法
%   

% 相位修正
actual_delta_phi = delta_phi - 2 * pi * frequency * delta_t;
actual_delta_phi = mod(actual_delta_phi + pi, 2 * pi) - pi;

% 角度计算
radian = acos(actual_delta_phi * c / frequency / 2 / pi / distance_antenna);
angle = rad2deg(radian);

end