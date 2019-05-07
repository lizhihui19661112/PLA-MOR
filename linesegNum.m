
function newSeglistIdx = linesegNum(edgelist, seglistIdx,num)
%Reduce the knot number to a fixed number
%Input:
%edgelist: - Array of points with Nx2 
%seglistIdx: - Index numbers of points in edgelist
%num: -Destination  knot number\
%Output:
% newSeglistIdx - The index number  sequence  of knot point

newSeglistIdx=seglistIdx;

while length(newSeglistIdx)>num
    orgSeglistIdx=newSeglistIdx;
    totalDist=zeros(length(orgSeglistIdx)-2,1);
    for iPts=1:length(orgSeglistIdx)-2
        newSeglistIdx(iPts+1)=[];%从第二点起每次去掉一个点
        startPts=newSeglistIdx(iPts);
        if length(newSeglistIdx)>=iPts+1
            endPts=newSeglistIdx(iPts+1);
            [maxdev, index, D, totaldev] = maxlinedev(edgelist(startPts:endPts,2),edgelist(startPts:endPts,1));
            totalDist(iPts)=totalDist(iPts)+sum(D);
        end
        newSeglistIdx=orgSeglistIdx;
    end
    [minDist minIdx]=min(totalDist);
    newSeglistIdx=orgSeglistIdx;
    newSeglistIdx(minIdx+1)=[];
 end


    
