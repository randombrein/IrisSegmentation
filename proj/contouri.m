function [CI]=contouri(I,C,r,n,type)
% CONTOURI - function calculates contour integral for circle by polygon approximation
% Polygon approximation for a circle is based on `n` edge count passed as a param.
%
% Inputs:
%   I - Image to be processed
%   C - Center coordinates of the circle to approximate
%   n - Number of edges for polygon approximation
%   r - Radius of circle
%   type - Application-specific type of the integral calculation.
%       Indicats wheter calculation is for iris or pupil. Pupil integral
%       calculation is based on entire circumference. On the other hand
%       iris calculation considers image staging cases caused by eyelids and gives 
%       *zero* weight for the top and the bottom of the iris. This weight
%       scheme is very coarse but it gives very satisfying results. (Ref; [3])
%
% Outputs:
%   CI - Contour integral calculated by polygon approximation
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

% IF any circle that does not fit inside the image regarding to center THEN return zero
if (any(xs>=rows) || any(ys>=cols) || any(xs<=1) || any(ys<=1)) 
    CI=0;
    return 
end

% Calculate pupil integral
if (strcmp(type,'pupil')==1)
    s=0;
    for i=1:n
        val=I(round(xs(i)),round(ys(i)));
        s=s+val;
    end

    CI=s/n;
end
% CI = sum(sum(I(round(xs),round(ys))))/n;

% Calculate iris integral
% only half of the polygon edges on the sides are included in the
% calculation with weight 2; [1:n/8  1+3n/8:5n/8  1+7n/8:n]
% top and bottom weights are *zero*
if(strcmp(type,'iris')==1)
    s=0;
    for i=1:round((n/8))
        val=I(round(xs(i)),round(ys(i)));
        s=s+val;
    end

    for i=(round(3*n/8))+1:round((5*n/8))
        val=I(round(xs(i)),round(ys(i)));
        s=s+val;
    end

    for i=round((7*n/8))+1:(n)
        val=I(round(xs(i)),round(ys(i)));
        s=s+val;
    end

    CI=(2*s)/n;
end

% CI = 0;
% rng = 1:round((n/8));
% CI = CI + sum(sum(I(round(xs(rng)),round(ys(rng)))));
% rng = (round(3*n/8))+1:round((5*n/8));
% CI = CI + sum(sum(I(round(xs(rng)),round(ys(rng)))));
% rng = round((7*n/8))+1:(n);
% CI = CI + sum(sum(I(round(xs(rng)),round(ys(rng)))));
% 
% CI=(2*CI)/n;
