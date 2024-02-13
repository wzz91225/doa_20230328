function [radian, angle] = FUNC_DF2D_PhaceComparing(delta_phi, frequency, distance_antenna, c)
%FUNC_DF2D_PhaceComparing 二维比相测向算法
%   

radian = acos(delta_phi * c / frequency / 2 / pi / distance_antenna);
angle = rad2deg(radian);

end