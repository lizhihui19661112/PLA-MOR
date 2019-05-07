function vect=inverseZeroNorm(normVect, meanVect, boundVect,option)
% Convert the normalized vector back.
% Input:
% normVect :- Normalized vector.
% meanVect :- 0: Mean value of the original vector.
%             1: Low bound of the original vector.
% boundVect :- 0: Absolute bound of the original vector.
%              1: Up bound of the original vector.
% Option :- 0: The normalized vector is in interval [-1,1].
%           1: The normalized vector is in interval [0,1].
% Output:                          
% vect :- The original vector.

if option==0
    for iv=1:size(normVect,2)
%         normVect(:,iv)=(vect(:,iv)-meanVect(iv))/boundVect(iv);
        vect(:,iv)=normVect(:,iv)*boundVect(iv)+meanVect(iv);
    end
else
     for iv=1:size(normVect,2)
%         normVect(:,iv)=(vect(:,iv)-meanVect(iv))/(boundVect(iv)-meanVect(iv));
        vect(:,iv)=normVect(:,iv)*(boundVect(iv)-meanVect(iv))+meanVect(iv);
     end
end