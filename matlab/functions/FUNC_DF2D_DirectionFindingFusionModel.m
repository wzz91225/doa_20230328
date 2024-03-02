function [doa_angle] = FUNC_DF2D_DirectionFindingFusionModel( ...
    angle_AmplitudeComp, angle_DynamicPhaseComp)
    % 融合求解方位角
    % 参数:
    % - angle_AmplitudeComp: 比幅角度结果
    % - angle_DynamicPhaseComp: 比相角度结果
    % 返回值:
    % - doa_angle: 融合方位角度

% 融合系数
alpha = 1.021679687500001;

result1 = angle_AmplitudeComp;
if angle_DynamicPhaseComp > 90
    result2 = 180 - angle_DynamicPhaseComp;
else
    result2 = angle_DynamicPhaseComp;
end

fusedResult = alpha * result1 + (1 - alpha) * result2;

if angle_DynamicPhaseComp > 90
    doa_angle = 180 - fusedResult;
else
    doa_angle = fusedResult;
end

end
