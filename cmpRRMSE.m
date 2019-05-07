function [rrmse err2]=cmpRRMSE(Ytr,yPr,YMean)
%Compute RRMSE and aRRMSE of predicting value yPr to true value Ytr.
% Input:
% Ytr :- Output variable of regressor.
% yPr :- Predictiong value of regressor.
% YMean :- Mean value of Y of training samples.
% Output:
% rrmse :- RRMSE error of pridicting value.
% err2:- aRRMSE error of pridicting value.

for jy=1:size(Ytr,2)   
    err0(jy)=sum((Ytr(:,jy)-yPr(:,jy)) .^ 2);
    err1(jy)=sum((Ytr(:,jy) - YMean(jy)) .^ 2);
end
err2=sqrt(err0./err1);
rrmse=err2;
err2=mean(rrmse);
