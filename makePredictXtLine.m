function predictX = makePredictXtLine(model, Xq,newOption)
% Segment the predict X according to model 
%Input:
%model :- Regression model building by aresbuildLineSeg.m
%Xq :- Input variable to predict
%newOption :- options for model building, see description in aresbuildLineSeg.m
%Output:
%predictX: Input variable after linear segmentation

if nargin < 2
    error('Too few input arguments.');
end

X=ones(size(Xq,1),1);
for i = 1 : length(model.knotdims)
     Xn = createBasisFuncLine(Xq, model.knotdims(i), model.knotsiteLow{i},model.knotsiteUp{i});
     X=[X Xn];
end
XtrMain=Xq;

knotDims=model.knotdims;

sortDims=unique(sort(knotDims));

for iXtr=length(sortDims):-1:1
    XtrMain(:,sortDims(iXtr))=[];
end
if newOption.keepOrgDime==1
    X1=[X(:,1) XtrMain X(:,2:end)];
else
    X1=X;
end
predictX=X1;
return


