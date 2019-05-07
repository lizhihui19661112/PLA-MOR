function [normVect meanVect boundVect]=zeroMeanNorm(vect,option)
% Normalize the vector in two ways. When option==0 the vector is converted
% into interval [-1,1]. When option==1 the vector is converted into [0,1].
% Input:
% vect :- Vector to be normalized.
% Option :- 0: The vector is converted into interval [-1,1].
%           1: The vector is converted into interval [0,1].
% Output:                          
% normVect :- Normalized vector.
% meanVect :- 0: Mean value of the original vector.
%             1: Low bound of the original vector.
% boundVect :- 0: Absolute bound of the original vector.
%              1: Up bound of the original vector.

if option==0
    for iv=1:size(vect,2)
        meanVect(iv)=mean(vect(:,iv));
        boundVect(iv)=max(abs(vect(:,iv)-meanVect(iv)));
        normVect(:,iv)=(vect(:,iv)-meanVect(iv))/boundVect(iv);
    end
else
     for iv=1:size(vect,2)
%         meanVect(iv)=mean(vect(:,iv));
        boundVect(iv)=max(vect(:,iv));%Up bound
        meanVect(iv)=min(vect(:,iv));%Low bound
        normVect(:,iv)=(vect(:,iv)-meanVect(iv))/(boundVect(iv)-meanVect(iv));
     end
end
