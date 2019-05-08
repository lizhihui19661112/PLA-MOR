%Compute the linear segmentation points for every pairs of xi and yj to
%implement the piecewise linear approximation.
%Input:
%Xtr: - Input variable of regresser
%Ytr: - Output variable of regresser
%newOption.minTD: Threshold which limits the deviation of every point to the current line
%Output:
%knotList: - Linear segmentaion point(knot) sequence
%newKnotList: -Reduced knot number to the number in knotNum

knotNum=5;%fixed knot number of every  pair of xi and yj 

for yDime=1:size(Ytr,2)
    for xDime=1:size(Xtr,2)
        [xSort sortIdx]=sort(Xtr(:,xDime));
%         [xSort sortIdx]=unique(Xtr(:,xDime));
        ySort=Ytr(sortIdx,yDime);
        clear pts
        pts(:,1)=ySort;
        pts(:,2)=xSort;
        [seglist seglistIdx] = lineseg(pts, newOption.minTD);
        
        KnotList{xDime,yDime}=[seglist(:,2) seglist(:,1)];
        KnotListIdx{xDime,yDime}=seglistIdx;
        newSeglistIdx = linesegNum(pts, seglistIdx,knotNum);
        newKnotListIdx{xDime,yDime}=newSeglistIdx;
        newKnotList{xDime,yDime}=[pts(newSeglistIdx,2) pts(newSeglistIdx,1)];
%         plot(xSort,ySort,'b+');
%         hold on 
%         plot(seglist(:,2),seglist(:,1),'r');        
    end
end
% plot(xSort,ySort,'b+');
% hold on 
% plot(seglist(:,2),seglist(:,1),'r');