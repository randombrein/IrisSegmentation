function [gmax]=search(I,C,rmin,rmax,vngbr,hngbr,type)
% SEARCH - function to detect the pupil  boundary
% it searches a certain subset of the image
% with a given radius range(rmin,rmax)
% around a 10*10 neighbourhood of the point x,y given as input
%
% Inputs:
%   I - image to be processed
%   C - center coordinates for calculation operation
%   rmin - minimum radius for calculation operation
%   rmax - maximum radius for calculation operation
%   vngbr - vertical local neighbourhood to search
%   hngbr - horizontal local neighbourhood to search
% Outputs:
%   gmax - max. gradient value [x,y,radius]
%
% Author: Evren KANALICI
% Date: 20/04/2015
% Computer Eng. - Computer Vision, Spring '16
% Yildiz Technical Univesity

NPOLYSIDE=600; % circle polygon approximation sude count
SIGMA=1; % standard deviation of gaussian filter
rows=size(I,1); % image row count
cols=size(I,2); % image column count

maxrad=zeros(rows,cols); % max. radius matrix
maxloc=zeros(rows,cols); % max. location matrix

% enumarate neightbourhod window to set integrod values
for i=(C(1)-vngbr):(C(1)+vngbr)
    for j=(C(2)-hngbr):(C(2)+hngbr)
        [loc,r]=integrod(I,[i,j],rmin,rmax,NPOLYSIDE,SIGMA,type);
        maxloc(i,j)=loc;
        maxrad(i,j)=r;
    end
end

% location at max. gradient
mloc=max(max(maxloc));

[x,y]=find(maxloc==mloc); % image location
radius=maxrad(x,y); % radius at max. gradient
gmax=[x,y,radius]; % max. gradient retVal



        