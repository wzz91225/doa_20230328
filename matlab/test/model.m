function predicted = model(params, xData)
    % 示例模型，实际模型应根据实际情况定义
    predicted = params(1) * xData.^2 + params(2) * xData + params(3);
end