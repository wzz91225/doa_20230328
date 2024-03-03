function [doa_angle] = FUNC_DF2D_DirectionFindingFusionModel( ...
    angle_AmplitudeComp, angle_DynamicPhaseComp)
    % 融合求解方位角
    % 参数:
    % - angle_AmplitudeComp: 比幅角度结果
    % - angle_DynamicPhaseComp: 比相角度结果
    % 返回值:
    % - doa_angle: 融合方位角度

% 融合系数
alpha = 0.5;

result1 = angle_AmplitudeComp;
if angle_DynamicPhaseComp > 90
    result2 = 180 - angle_DynamicPhaseComp;
else
    result2 = angle_DynamicPhaseComp;
end

if result1 < 30
    fusedResult = result1;
elseif result1 < 80
    fusedResult = alpha * result1 + (1 - alpha) * result2;
else
    fusedResult = result1;
end

% if result1 < 30
%     fusedResult = result1;
% elseif result1 < 80
%     fusedResult = alpha * result1 + (1 - alpha) * result2;
% elseif result1 < 90
%     fusedResult = 0.8 * result1 + (1 - 0.8) * result2;
% else
%     fusedResult = result1;
% end

if 90 < angle_DynamicPhaseComp
    doa_angle = 180 - fusedResult;
else
    doa_angle = fusedResult;
end

end
