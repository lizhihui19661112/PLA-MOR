function Xn = createBasisFuncLine(XtrOrg,  knotdims, knotsiteLow,knotsiteUp)
% Segmentation of X according to piecewise linear approximate parameters.
% Input:
% XtrOrg :- Input variable X before segmentaion.
% knotdims :- Dimension index No. of X to be segmented.
% knotsiteLow :- Lower bound of segmented interval. 
% knotsiteUp :- Upper bound of segmented interval. 
% Output:
% Xn :- Segmented result of X;

Xn=zeros(size(XtrOrg,1),length(knotsiteLow));
for i = 1 : length(knotsiteLow)
    idxFind=find(XtrOrg(:,knotdims)>=knotsiteLow(i) & XtrOrg(:,knotdims)<knotsiteUp(i));
    Xn(idxFind,i)=XtrOrg(idxFind,knotdims);
end

return
