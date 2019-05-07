%Demo of regression program in  multiple output regression based on piecewise linear approximation(PLA-MOR).
clear
fnName='andro';
load(['mat\' fnName]);
%Parameter configuration.
kFold=4;
newOption.keepOrgDime=0;
newOption.selectMinErrDime=1;
newOption.laglanri=0.5;
newOption.toSingleRegrss=0;
newOption.threshold=0.01;
newOption.minTD=0.05;
%Vector normalizing.
[normX meanVectX boundVectX]=zeroMeanNorm(Xtr,0);
[normY meanVectY boundVectY]=zeroMeanNorm(Ytr,0);
X=Xtr;
Y=Ytr;
%Assignment of training and testing examples
randIdx=randperm(size(X,1));
trainNum=round(size(X,1)*(kFold-1)/kFold);
trainIdx=randIdx(1:trainNum);
testIdx=randIdx(trainNum+1:end);
Xtr=normX(trainIdx,:);%Training samples
Ytr=normY(trainIdx,:);                                                                                                                                                                                        
testXtr=normX(testIdx,:);%Testing samples  
testYtr=normY(testIdx,:);
YMean=mean(Ytr);   
%Piecewise linear fitting for training sample.
tic
cmpLineKnot;
%Model building
singleModel= aresbuildLineSeg(Xtr, Ytr, newOption,KnotList);
trainTime=toc;
%Output predicting for training samples
yPr= arespredictLineSeg(singleModel,Xtr,newOption);
tic
%Output predicting for testing samples
testYPr= arespredictLineSeg(singleModel,testXtr,newOption);
predictTime=toc
%aRRMSE computing
[rrmseTrain aRrmseTrain] =cmpRRMSE(Ytr,yPr,YMean);
[rrmseTest aRrmseTest]=cmpRRMSE(testYtr,testYPr,YMean);
aRrmseTest
%Recovering to orginal data range.
vectYPr=inverseZeroNorm(yPr, meanVectY, boundVectY,0);



