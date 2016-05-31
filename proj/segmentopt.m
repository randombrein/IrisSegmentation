function [ci,cp,out]=segmentopt(I,rmin,rmax)
% SEGMENTOPT - function to search for the centre coordinates of the pupil and the iris
% along with their radius using Daugman's integrodifferetial operation (Ref;[1]).
% 
% After the iris has been detected, pupil's centre coordinates
% are found by searching a 15*15 neighbourhood around the iris centre and varying the radius
% until a maximum gradient is found (Ref;[1]).
% Optimizations benefits from Ref;[2] to find the possible center coordinates of 
% the iris by the method consist of thresholding followed by checking if the selected 
% points correspond to a local minimum in their (5x5) neighbourhoods. 
%
% Inputs:
%   I - image to be segmented
%   rmin - the minimum value of the iris radius
%   rmax - the maximum value of the iris radius
% Outputs:
%   cp - the parameters[xc,yc,r] of the pupilary boundary
%   ci - the parameetrs[xc,yc,r] of the iris boundary
%   out - the segmented image
%
% Author: Evren KANALICI
% Date: 20/04/2015
% Computer Eng. - Computer Vision, Spring '16
% Yildiz Technical Univesity

NPOLYSIDE=600; % circle polygon approximation side count

% convert img to double [0..1]
I=im2double(I);

rows=size(I,1);
cols=size(I,2);

% keep original image
oriimage=I;

% Remove specular reflections by using the morphological operation `imfill`
% Ref;[2] - specularity filling
I=imcomplement(imfill(imcomplement(I),'holes'));

% Thresholded column vectors for the image to find local minimas
% Ref;[2] - seed point detection/thresholding
[X,Y]=find(I<0.5);

% Scan the neighbourhood (5x5) of the threshold pixels to find local minimas in neighbourhood
% Ref;[2] - seed point detection
s=size(X,1);
LNGHBR = 2; %local neighbour (5x5)
for k=1:s
    if (X(k)>rmin) && (Y(k)>rmin) && (X(k)<=(rows-rmin)) && (Y(k)<(cols-rmin))
            A=I((X(k)-LNGHBR):(X(k)+LNGHBR),(Y(k)-LNGHBR):(Y(k)+LNGHBR));
            M=min(min(A));
            
            % mark non local minimas as NAN
            if I(X(k),Y(k))~=M
                X(k)=NaN;
                Y(k)=NaN;
            end
    end
end

% Delete all pixels that are NOT local minima
v=find(isnan(X));
X(v)=[];
Y(v)=[];

% Delete all pixels that are so close to the border according to `rmin` param.
v=find((X<=rmin) | (Y<=rmin) | (X>(rows-rmin)) | (Y>(cols-rmin)));
X(v)=[];
Y(v)=[];  

maxrad=zeros(rows,cols); % max. radius matrix
maxloc=zeros(rows,cols); % max. location matrix

% Coarse search
% Ref;[2] - seed point detection
N=size(X,1);
for j=1:N
    [loc,r]=integrod(I,[X(j),Y(j)],rmin,rmax,NPOLYSIDE,inf,'iris');
    maxloc(X(j),Y(j))=loc;
    maxrad(X(j),Y(j))=r;
end

% location at max. gradient
mloc=max(max(maxloc));

[x,y]=find(maxloc==mloc); % image location at max. gradient

% Fine search for iris at 15x15 neightbourhood
ci=search(I,[x,y],rmin,rmax,7,7,'iris');

% Localized search for pupil
% search for the centre of the pupil and its radius by scanning a 15*15
% window around iris center
% Ref;[1] relative sizes of the iris and pupil
rpupil_min = round(0.1 * ci(3));
rpupil_max = round(0.8 * ci(3));
cp=search(I,[ci(1),ci(2)],rpupil_min,rpupil_max,7,7,'pupil');

% Marking segmented image
out=drawcircle(oriimage,[ci(1),ci(2)],ci(3),NPOLYSIDE); % iris overlay-mark
out=drawcircle(out,[cp(1),cp(2)],cp(3),NPOLYSIDE); % pupil overlay-mark
