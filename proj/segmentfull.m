function [ci,cp,out]=segmentfull(I,rmin,rmax)
% SEGMENTFULL - function to search for the centre coordinates of the pupil and the iris
% along with their radius using Daugman's integrodifferetial operation (Ref;[1]) by
% fullsearch. The search start from center of the image and scans whole
% boundry limited with `rmin` param. No-optimazation takes places either
% morphological features of the image or intensity thresholding nor methods for finding
% the possible centers of the iris.
% After the iris has been detected, pupil's centre coordinates
% are found by searching a 15*15 neighbourhood around the iris centre and varying the radius
% until a maximum gradient is found (Ref;[1]).
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

% keep original image
oriimage=I;

rows=size(I,1);
cols=size(I,2);

% Full search for iris
vngbr=floor(rows/2)-rmin; % half-vertical neighbour
hngbr=floor(cols/2)-rmin; % half-horizontal neighbour
center=[ceil(rows/2),ceil(cols/2)]; % image center location
ci=search(I,center,rmin,rmax,vngbr,hngbr,'iris'); % max. gradient iris location

% Localized search for pupil
% search for the centre of the pupil and its radius by scanning a 15*15
% window around iris center
% Ref;[1] relative sizes of the iris and pupil
rpupil_min=round(0.1 * ci(3));
rpupil_max=round(0.8 * ci(3));
cp=search(I,[ci(1),ci(2)],rpupil_min,rpupil_max,7,7,'pupil'); % max. gradient pupil location

% Marking segmented image
out=drawcircle(oriimage,[ci(1),ci(2)],ci(3),NPOLYSIDE); % iris overlay-mark
out=drawcircle(out,[cp(1),cp(2)],cp(3),NPOLYSIDE); % pupil overlay-mark
