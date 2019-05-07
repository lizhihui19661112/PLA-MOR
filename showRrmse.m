%Program to validate all regression model then show aRRMSE results
clear
load('testResult\newRRMSE-kFold.mat')
for ik=1:10
    %Dataset loading.
    fn=['mat\' fnArray{ik}];
    clear Xtr Ytr
    load(fn);
    %Vector normalizing.
    [normX meanVectX boundVectX]=zeroMeanNorm(Xtr,0);
    [normY meanVectY boundVectY]=zeroMeanNorm(Ytr,0);
    X=Xtr;
    Y=Ytr;
    
    randIdx=randIdxArray{ik};
     for iTime=1:kFold
        testNum=size(X,1)/kFold;
        %Assignment of training and testing examples
        testIdx=randIdx((round((iTime-1)*testNum)+1):round(iTime*testNum)); 
        trainIdx=randIdx([1:round((iTime-1)*testNum) round(iTime*testNum)+1:size(X,1)]);         

        Xtr=normX(trainIdx,:);
        Ytr=normY(trainIdx,:);                                                                                                                                                                                           
        testXtr=normX(testIdx,:);
        testYtr=normY(testIdx,:);
        YMean=mean(Ytr);    
        %Output predicting for testing samples
        tic
        testYPr= arespredictLineSeg(singleModel{ik,iTime},testXtr,newOption);
        predictingTime(ik)=toc;
        predictingTime(ik)= predictingTime(ik)/length(testIdx);
        %aRRMSE computing
        [rrmseTest1 aRrmseTest1]=cmpRRMSE(testYtr,testYPr,YMean);

        aRrmseArray(ik,iTime)=aRrmseTest1;
        rrmseArray{ik,iTime}=rrmseTest1;
    end
end
aRRMSE=mean(aRrmseArray');

fnArray{1}='andro ';
fnArray{2}='slump ';
fnArray{3}='atp7d ';
fnArray{4}='enb   ';
fnArray{5}='jura  ';
fnArray{6}='oes10 ';
fnArray{7}='oes97 ';
fnArray{8}='scm1d ';
fnArray{9}='scm20d';
fnArray{10}='atp1d ';
%Displaying of predicting results and time
for ik=1:10
    str=['dataset:' fnArray{ik} '  aRRMSE:' num2str(aRRMSE(ik)) '  Predicting time:' num2str(predictingTime(ik)*1000) 'ms\n'];
    fprintf(str);
end


num=0;
for ik=1:10
    clear rrmseDime
    for iTime=1:kFold
        rrmseDime(iTime,:)=rrmseArray{ik,iTime};
    end
    meanRrmse=mean(rrmseDime);
    for iTime=1:length(meanRrmse)
        num=num+1;
        name(num,1:6)=fnArray{ik};
        avgRrmse(num)=meanRrmse(iTime);
    end
end
%Drawing of box plot
boxplot(avgRrmse,name);
return


