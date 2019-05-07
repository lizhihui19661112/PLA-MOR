function Yq = arespredictLineSeg(model, Xq,newOption)
% Predict by MOR model built by aresbuildLineSeg.m
% Input:
% model :- MOR model,see the description in aresbuildLineSeg.m
% Xq :- Input variable for prediction.
% newOption :- options for model building,see the description in aresbuildLineSeg.m
%
% Output:
% Yq :- Predicted outputs according to MOR model

if nargin < 2
    error('Too few input arguments.');
end

if newOption.toSingleRegrss==1
    for iDime=1:length(model)
        predictX = makePredictXtLine(model{iDime}, Xq,newOption);
        Yq(:,iDime) = predictX * model{iDime}.coefs;       
    end
else
    predictX = makePredictXtLine(model, Xq,newOption);
    Yq = predictX * model.coefs;
end
return


