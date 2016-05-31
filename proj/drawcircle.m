function [overlay]=drawcircle(I,C,r,n)
% DRAWCIRCLE - function to mark image with circles using polygon approximation
% parameters passed establishes the approximation
%
% Inputs:
%   I - Image to be processed
%   C - center coordinates of the circle
%   n - number of sides for polygon approximation
%   r - radius of circle to draw
%
% Outputs:
%   overlay - overlay image with circles drawed
%
% Author: Evren KANALICI
% Date: 20/04/2015
% Computer Eng. - Computer Vision, Spring '16
% Yildiz Technical Univesity

theta=(2*pi)/n;% start angle for approximation

rows=size(I,1); % row count
cols=size(I,2); % column count
rads=theta:theta:2*pi; % angles for approximation
xs=C(1)-r*sin(rads); % x-locations
ys=C(2)+r*cos(rads); % y-locations

% IF any circle that does not fit inside the image regarding to center THEN no-op
if any(xs>=rows) || any(ys>=cols) || any(xs<=1) || any(ys<=1)
    overlay=I;
    return
end

for i=1:n
    I(round(xs(i)),round(ys(i)))=1; % white pixels for overlay
end
overlay=I;
