%Compute aRRMSE of all datasets
clear

fnArray{1}='andro';
fnArray{2}='slump';
fnArray{3}='atp7d';
fnArray{4}='enb';
fnArray{5}='jura';
fnArray{6}='oes10';
fnArray{7}='oes97';
fnArray{8}='scm1d';
fnArray{9}='scm20d';
fnArray{10}='atp1d';
%Parameter configuration.
newOption.keepOrgDime=0;
newOption.selectMinErrDime=0;
newOption.laglanri=0.5;
newOption.toSingleRegrss=0;
newOption.minTD=0.15;
kFold=4;
for ik=1:2
    fn=['mat\' fnArray{ik}];
    clear Xtr Ytr
    load(fn);
    
    %Vector normalizing.
    [normX meanVectX boundVectX]=zeroMeanNorm(Xtr,0);
    [normY meanVectY boundVectY]=zeroMeanNorm(Ytr,0);
    X=Xtr;
    Y=Ytr;
    
    randIdx=randperm(size(X,1));
    randIdxArray{ik}=randIdx;
    %testing in the way of cross valitation
     for iTime=1:kFold
        testNum=size(X,1)/kFold;%Number of testing sample
        %Assignment of training and testing examples
        testIdx=randIdx((round((iTime-1)*testNum)+1):round(iTime*testNum)); 
        trainIdx=randIdx([1:round((iTime-1)*testNum) round(iTime*testNum)+1:size(X,1)]); 
        %Training samples
        Xtr=normX(trainIdx,:);
        Ytr=normY(trainIdx,:);  
        %Testing samples
        testXtr=normX(testIdx,:);
        testYtr=normY(testIdx,:);
        YMean=mean(Ytr);    
        tic
        %Piecewise linear fitting for training sample.
        cmpLineKnot;
        %Model building
        model= aresbuildLineSeg(Xtr, Ytr, newOption,KnotList);
        singleModel{ik,iTime}=model;
        trainingTime(ik,iTime)=toc;
        %Output predicting for training samples
        yPr= arespredictLineSeg(singleModel{ik,iTime},Xtr,newOption);
        %Output predicting for testing samples
        tic
        testYPr= arespredictLineSeg(singleModel{ik,iTime},testXtr,newOption);
        predictTime(ik)=toc;
        predictTime(ik)= predictTime(ik)/length(testIdx);
        %aRRMSE computing
        [rrmseTrain aRrmseTrain] =cmpRRMSE(Ytr,yPr,YMean);
        [rrmseTest aRrmseTest]=cmpRRMSE(testYtr,testYPr,YMean);

        aRrmseArray(ik,iTime)=aRrmseTest;
        rrmseArray{ik,iTime}=rrmseTest;
        save('testResult\newRRMSE-test');
    end
 end
%Display aRrmse
mean(aRrmseArray')


