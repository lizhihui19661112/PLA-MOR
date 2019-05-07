
function [seglist seglistIdx] = lineseg(edgelist, tol)
%The function is modified from the function of lineseg by Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% http://www.csse.uwa.edu.au/

%The fuction implements picewise linear segmentation (PLA) based on maximum
%distance point splitting(MDPS).

%Input:
% edgelist - Array of points with Nx2 
% tol      - Distance threshold. 
%Output:
% seglist - The knot point sequence 
% seglistIdx - The index number  sequence  of knot point

y = edgelist(:,1);   % Note that (col, row) corresponds to (x,y)
x = edgelist(:,2);

fst = 1;                % Indices of first and last points in edge
lst = length(x);        % segment being considered.

Npts = 1;	
seglist(Npts,:) = [y(fst) x(fst)];
seglistIdx(Npts)=fst;

while  fst<lst
    [m,i] = maxlinedev(x(fst:lst),y(fst:lst));  % Find size & posn of
                                                    % maximum deviation.

    while m > tol       % While deviation is > tol  
    lst = i+fst-1;  % Shorten line to point of max deviation by adjusting lst
    [m,i] = maxlinedev(x(fst:lst),y(fst:lst));
    end

    Npts = Npts+1;
    seglist(Npts,:) = [y(lst) x(lst)];
    seglistIdx(Npts)=lst;

    fst = lst;        % reset fst and lst for next iteration
    lst = length(x);
end

    
