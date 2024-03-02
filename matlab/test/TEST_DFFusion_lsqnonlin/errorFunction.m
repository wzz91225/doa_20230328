function err = errorFunction(params, xData, yData1, yData2)
    % params: 待优化的参数
    % xData: 测向角度数据
    % yData1: 第一个算法的MAE数据
    % yData2: 第二个算法的MAE数据

    % 用params和xData计算模型预测值
    % 这里假设模型是某种形式的组合，具体取决于你的应用需求
    predicted = model(params, xData);

    % 计算误差
    err = predicted - (yData1 + yData2); % 根据实际情况调整
end