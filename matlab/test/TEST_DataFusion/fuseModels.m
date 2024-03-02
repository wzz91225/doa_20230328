function fusedResult = fuseModels(params, result1, result2)
    alpha = params(1); % 权重因子
    fusedResult = alpha * result1 + (1 - alpha) * result2;
end
