function mse = calculateMSE(params, result1, result2, trueDirections)
    fusedResults = fuseModels(params, result1, result2);
    mse = mean((fusedResults - trueDirections).^2);
end
