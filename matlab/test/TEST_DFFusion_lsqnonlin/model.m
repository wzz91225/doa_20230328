function predicted = polynomialModel(params, xData)
    % 例如，一个五次多项式模型
    predicted = params(1) + params(2) * xData + params(3) * xData.^2 + params(4) * xData.^3 + params(5) * xData.^4 + params(6) * xData.^5;
end
