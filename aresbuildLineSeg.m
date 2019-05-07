function model= aresbuildLineSeg(Xtr, Ytr,newOption,knotList)
% aresbuildLineSeg builds multiple output regression(MOR) based on
% piecewise linear approximation(PLA). Maximum distance point
% splitting(MDPS) is used to piecewise fit lines.  Then the best knot set
% of linear segmentation is obtained. The independent variable X is divided
% into some linear intervals which form Z. The linear regression is to
% determine A in Y=AZ.
% Input:
% Xtr :- Input variable of regressor.
% Ytr :- Output variable of regressor.
% knotList :- Linear segmentaion point(knot) sequence.
% newOption :- Options for model building.
% newOption.selectMinErrDime :- 0: Default value. Segment all dimensions of
%                              Xtr one by one. Compute the regression model
%                              by all segmented dimensions.
%                              1: Compute the regression model in the way
%                              of selecting the dimension with minimum
%                              error in each iteration. The iteration will
%                              terminate when error changing is lower than
%                              newOption.threshold.
% newOption.threshold :- When newOption.selectMinErrDime=1 newOption.threshold is the iteration terminating threshold;
% newOption.keepOrgDime :- 1: Keep the dimensions without segmentation in
%                             regression model computing. It is useful only
%                             when newOption.selectMinErrDime=1.
%                          0: Otherwise       
% newOption.laglanri :- Lagrange multiplier in least square with constraint
% newOption.toSingleRegrss :- 1: Compute the regression model in the way of  puting every 
%                              dimension of Ytr as output of a single regressor
%                             0: Compute the regression model in the way of
%                             MOR.
% Output:                          
% model :- Regression model
% model.knotdims :- Current dimension index No.
% model.knotsiteUp :- ; Up bound of current linear interval 
% model.knotsiteLow :- ; Low bound of current linear interval 
% model.coefs :- Coefficient matrix of linear regression, which is A in
%                Y=AZ.
% model.MSE :- aRRMSE of training set

% Compute mean value of Ytr
for jy=1:size(Ytr,2)   
    YtrMean(jy) = mean(Ytr(:,jy));
    YtrSS(jy)= sum((Ytr(:,jy) - YtrMean(jy)) .^ 2);
end

% Compute the regression model in the way of  puting every 
% dimension of Ytr as output of a single regressor
if newOption.toSingleRegrss==1
    [model errIter]=singleRegss(Xtr,Ytr,knotList,newOption,YtrSS);
    return
end

if newOption.selectMinErrDime==0
    newOption.keepOrgDime=0;
    % Segment every dimensions according to knotList and form Z in Y=AZ from X
    [model errIter]=directAddDime(Xtr,Ytr,knotList,newOption,YtrSS);
else
    % Form Z that the dimension of X with minimum error first
    [model errIter]=selectMinErrDime(Xtr,Ytr,knotList,newOption,YtrSS);
end

return


% =========================  Auxiliary functions  ==========================

function [model,X,parErr]=addFrwrdBasis(model, knotList,X,YtrSS,Xtr,Ytr,  ...
   minKnot,addIdxDime,newOption)
% Segment one dimension of X and form Z and compute new model.
% Input: 
% model :- Current regression model.
% knotList :- Linear segmentaion point(knot) sequence. 
% X :- Current segmented Xtr. 
% YtrSS :- Mean value of Ytr.
% Xtr :- Input variable of regressor. 
% Ytr :- Output variable of regressor. 
% minKnot :- Knot sequence with minimum error. It has M elements and the value of
%         each element is dimension index No. of Ytr.
% iDime :- The dimension index No. of Xtr to segment. 
% addIdxDime :- Dimension ID to be segmented.
% newOption :- Options for model building. Its description shows in below
%             the main function aresbuildLineSeg.
% Output:
% model :- New model after segment one dimension 
% coefs :- Current linear model coefficients
% parErr :- aRRMSE of current linear model coefficient.

[parErr parCoefs] = parBasisFunction(model, knotList, Xtr,Ytr,X,YtrSS,...
   minKnot, addIdxDime,newOption);

segList=knotList{addIdxDime,minKnot(addIdxDime)};
knotNum=size(segList,1);
knotsiteLow=segList(1:knotNum-1,1);
knotsiteUp(1:knotNum-1)=segList(2:knotNum,1);
knotsiteLow(1)=-inf;
knotsiteUp(knotNum-1)=inf;
Xn = createBasisFuncLine(Xtr, addIdxDime, knotsiteLow,knotsiteUp);
X = [X Xn];

model.knotdims(end+1) = addIdxDime;
model.knotsiteUp{end+1,1} = knotsiteUp;
model.knotsiteLow{end+1,1} = knotsiteLow;
model.coefs=parCoefs;
model.MSE=parErr;

return

function [coefs tmpErr]=cmpCoefsErr(Xtr,XtrMain,Ytr,knotList,iDime,iKnot,X,YtrSS,newOption)
% Compute linear model coefficients and aRRMSE for current segmented Xtr and a new
% segmented dimension. 
% Input: 
% Xtr :- Input variable of regressor. 
% XtrMain :- Left Xtr after removing segmented dimensions by function makeXtrLeft 
% Ytr :- Output variable of regressor. 
% knotList :- Linear segmentaion point(knot) sequence. 
% iDime :- The dimension index No. of Xtr to segment. 
% X :- Current segmented Xtr. 
% iKnot :- The dimension index No. of Ytr to determine which
%          knot list of Ytr's dimension is used to segment Xtr. 
% YtrSS :- Mean value of Ytr.
% newOption :- options for model building. Its description shows in below
%             the main function aresbuildLineSeg.
% Output:
% coefs :- Current linear model coefficients
% tmpErr :- aRRMSE of current linear model coefficients.

segList=knotList{iDime,iKnot};
knotNum=size(segList,1);
knotsiteLow=segList(1:knotNum-1,1);
knotsiteUp(1:knotNum-1)=segList(2:knotNum,1);
knotsiteLow(1)=-inf;
knotsiteUp(knotNum-1)=inf;
Xn = createBasisFuncLine(Xtr, iDime, knotsiteLow,knotsiteUp);
Xtmp=[X Xn];
if newOption.keepOrgDime==1
    Xtmp1=[Xtmp(:,1) XtrMain Xtmp(:,2:end)];
else
    Xtmp1=Xtmp;
end 
[coefs tmpErr1] = lreg(Xtmp1, Ytr,newOption);
tmpErr1 = sqrt(tmpErr1./ YtrSS);
tmpErr = mean(tmpErr1);
        
function [model errIter]=directAddDime(Xtr,Ytr,knotList,newOption,YtrSS)
% Segment every dimensions according to knotList and form Z in Y=AZ from X
% Input:
% Xtr :- Input variable of regressor.
% Ytr :- Output variable of regressor.
% knotList :- Linear segmentaion point(knot) sequence.
% newOption :- Options for model building. Its description shows in below
%             the main function aresbuildLineSeg.
% YtrSS :- Mean value of Ytr.
% Output:
% model :- Regression model.
% errIter :- Error array for all iterations.

model=makeInitModel;
X = ones(size(Xtr,1),1); 
minKnot=selectMinKnot(Xtr,Ytr,X,knotList,model,newOption,0,YtrSS); 
for iIter=1:size(Xtr,2)
%     iIter
    [model,X,parErr]=addFrwrdBasis(model, knotList,X,YtrSS,Xtr,Ytr,minKnot,iIter,newOption);
    errIter(iIter) = parErr;
end

function [coefs err] = lreg(z, y, newOption)
% Compute the coefficients A of Y=AZ by Constrained Least Squares
% Input:
% z :- Segmented Xtr.
% y :- Output variable Ytr.
% newOption
% Output:
% coefs :- Coefficients matrix A of linear model.
% err :- aRRMSE of current coefficient on training set. 

xDime=size(z,2);
for iy=1:size(y,2)
    tempCoefs1=z' * z;
    for itemp=1:size(tempCoefs1,1)
        tempCoefs1(itemp,itemp)=tempCoefs1(itemp,itemp)+newOption.laglanri;
    end
    tempCoefs=tempCoefs1 \ (z' * y(:,iy));
    coefs(:,iy)=tempCoefs;
    err(iy) = sum((y(:,iy)-z*coefs(:,iy)).^2);
end

return

function model=makeInitModel
% Build a empty model.
% Output:
% model :- Empty model.

model.coefs = [];
model.knotdims = [];
model.knotsiteUp = {};
model.knotsiteLow = {};
model.MSE = Inf;

function XtrMain=makeXtrLeft(Xtr,model,idxXDime)
% Remove the dimensions of Xtr in model.knotdims and dimension idxXDime for
% replacing them with the segmented Xtr.
% Input:
% Xtr :- Input variable of regressor.
% model :- Current regression model.
% idxXDime :- The dimension index No to remove from Xtr for segmenting.
% Output:
% XtrMain :- Xtr after removing above-mentioned dimensions.

XtrMain=Xtr;
removeDime=idxXDime;
knotDims=[];
for iXtr=1:length(model.knotdims)
    knotDims(iXtr)=model.knotdims(iXtr);
end
if isempty(knotDims)
     knotDims(1)=removeDime;
else
    knotDims(end+1)=removeDime;
end
sortDims=unique(sort(knotDims));

for iXtr=length(sortDims) :- 1:1
    XtrMain(:,sortDims(iXtr))=[];
end
    

function [parErr parCoefs] = parBasisFunction(model, knotList, Xtr,Ytr,X,YtrSS,...
   minKnot, currentIdx,newOption)
% Segment one dimension of X and form Z while compute the aRRMSE.
% Input: 
% model :- Current regression model.
% knotList :- Linear segmentaion point(knot) sequence. 
% Xtr :- Input variable of regressor. 
% Ytr :- Output variable of regressor. 
% X :- Current segmented Xtr. 
% YtrSS :- Mean value of Ytr.
% minKnot :- Knot sequence with minimum error. It has M elements and the value of
%         each element is dimension index No. of Ytr.
% currentIdx :- Dimension ID to be segmented.
% newOption :- options for model building. Its description shows in 
%             the main function aresbuildLineSeg.
% Output:
% parCoefs :- Current linear model coefficients
% parErr :- aRRMSE of current linear model coefficients.

XtrMain=makeXtrLeft(Xtr,model,currentIdx);
Xtmp = X;
[parCoefs parErr]=cmpCoefsErr(Xtr,XtrMain,Ytr,knotList,currentIdx,minKnot(currentIdx),X,YtrSS,newOption);


function minKnot=selectMinKnot(Xtr,Ytr,X,knotList,model,newOption,currentIdx,YtrSS)
% The knot sequence with minimum error is selected as the knot sequence for
% every dimesion of X, which represents by array minKnot.
% Input:
% Xtr :- Input variable of regressor.
% Ytr :- Output variable of regressor.
% X :- Current segmented Xtr. 
% knotList :- Linear segmentaion point(knot) sequence.
% newOption :- Options for model building. Its description shows in
%             the main function aresbuildLineSeg.
% currentIdx :- 0: Compute knot sequence with minimum error for all
%                dimensions of Xtr. It is used in function directAddDime.
%             >0: Compute knot sequence with minimum error for some
%                dimensions of Xtr. It is used in function selectMinErrDime.
% YtrSS :- Mean value of Ytr.
% Output:
% minKnot :- Knot sequence with minimum error. It has M elements and the value of
%         each element is dimension index No. of Ytr.

if currentIdx>0
    XtrMain=makeXtrLeft(Xtr,model,currentIdx);
else
    XtrMain=[];
end
Xtmp = X;
for iDime=1:size(Xtr,2)
   for iKnot=1:size(Ytr,2)
    [coefs tmpErr]=cmpCoefsErr(Xtr,XtrMain,Ytr,knotList,iDime,iKnot,X,YtrSS,newOption);
        errKnot(iKnot)=tmpErr;
    end
    [minErr minIdx]=min(errKnot);
    minKnot(iDime)=minIdx;
end
    
            
function [model errIter]=selectMinErrDime(Xtr,Ytr,knotList,newOption,YtrSS)
% Compute the regression model in the way of selecting the dimension with
% minimum  error in each iteration. The iteration will terminate when error
% changing is lower than  newOption.threshold.
% Input:
% Xtr :- Input variable of regressor.
% Ytr :- Output variable of regressor.
% knotList :- Linear segmentaion point(knot) sequence.
% newOption :- Options for model building. Its description shows in 
%             the main function aresbuildLineSeg.
% YtrSS :- Mean value of Ytr.
% Output:
% model :- Regression model.
% errIter :- Error array for all iterations.

model=makeInitModel;
X = ones(size(Xtr,1),1); 
maxIters = size(Xtr,2); 
errIter = 1; 
numAddBasis = 0; 
addDimeArray=[];
minKnot=[];

for depth = 1 : maxIters 
    lastKnot=minKnot;
    minKnot=selectMinKnot(Xtr,Ytr,X,knotList,model,newOption,depth,YtrSS);
    tmpErr = inf(1,size(Xtr,2)); 
%     depth
    basisFunctionNum=0;
    for iIter = 1 : maxIters
        clear idxFind
        idxFind=find(addDimeArray==iIter);
        if isempty(idxFind)
            [parErr parCoefs] = parBasisFunction(model, knotList, Xtr,Ytr,X,YtrSS,minKnot, iIter,newOption);
            tmpErr(iIter)=parErr;
        end

    end
    [sortErr sortInd]=sort(tmpErr,'ascend');

    for iSort=1:length(sortInd)
        if abs(sortErr(iSort)-sortErr(1))> newOption.threshold
            break;
        end
        addIdxDime=sortInd(iSort);
        [model,X,parErr]=addFrwrdBasis(model, knotList,X,YtrSS,Xtr,Ytr,minKnot,addIdxDime,newOption);
         errIter(end+1) = parErr;
         numAddBasis=numAddBasis+1;
        addDimeArray(numAddBasis)=addIdxDime;
    end

    if numAddBasis>=maxIters
        break;
    end
    
end % end of the main loop    


function [singleModel errIter]=singleRegss(Xtr,Ytr,knotList,newOption,YtrSS)
% Build MOR model in the way of single out regression, which means that a
% model is built for every dimension of Ytr.
% Input:
% Xtr :- Input variable of regressor.
% Ytr :- Output variable of regressor.
% knotList :- Linear segmentaion point(knot) sequence.
% newOption :- Options for model building. Its description shows in 
%             the main function aresbuildLineSeg.
% YtrSS :- Mean value of Ytr.
% Output:
% model :- Regression model.
% errIter :- Error array for all iterations.

errIter=zeros(size(Xtr,2),1);
for iDime=1:size(Ytr,2)
    X = ones(size(Xtr,1),1); 
    model=makeInitModel;
    minKnot=ones(size(Xtr,2),1)*iDime; 
    for iIter=1:size(Xtr,2)
%         iIter
        [model,X,parErr]=addFrwrdBasis(model, knotList,X,YtrSS,Xtr,Ytr(:,iDime),minKnot,iIter,newOption);
        errIter(iIter) = errIter(iIter)+parErr;
    end
    singleModel{iDime}=model;
end


            