function [loc,r]=integrod(I,C,rmin,rmax,n,sigma,type)
% INTEGROD - function calculates the partial derivative of contour integral.
% calculates is based on incrementin radius between [rmin:rmax] while
% keeping the center coordinates constant at C(x,y). `n` parameter is used
% for polygon approximation of the circle. After integrodifferential
% operation, gradient field is smoothed by a LP filter based on gaussian
% `sigma` value. function returns the maximum gradient value with location
% and radius
%
% Inputs:
%   I - input image
%   C - center coordinates to calculate differentiation
%   rmin - the minimum radius value
%   rmax - the maximum radius value
%   n - number of sides of the polygon approximation 
%   sigma - standard deviation of the gaussian filter
%   type - specifies whether it is searching for the iris or pupil
%   
% Outputs:
%   loc - location at maximum gradient
%   r - radius at maximum gradient
%   blur - the gradient vector field
%
% Author: Evren KANALICI
% Date: 20/04/2015
% Computer Eng. - Computer Vision, Spring '16
% Yildiz Technical Univesity

rs=rmin:rmax;
count=size(rs,2);
Cint = zeros(1, count);

for i=1:count
    % calculate contour integral for each radius
    [Cint(i)]=contouri(I,C,rs(i),n,type);
    
    % Cint == 0 mean window with radius value lays out of the image
    % delete the value and break, no more calculation is needed
    if Cint(i)==0
        Cint(i)=[];
        break;
    end
end
% Cint = contouri(I,C,rs,n,part);

% delete zero integral values
Cint(Cint==0)=[]; 

% differentiate Contour integral vector wrt radius
D=diff(Cint);

% append one element at the beginning to make it an n vector
% Partial derivative at rmin is assumed to be zero
D=[0 D];

% set smoothing filter according to sigma value
%   - Inf sigma; 7x7 mean filter
%   - Otherwise generate a 1-D gaussian (3sigma rule)
if isinf(sigma) 
    f=ones(1,7)/7;
else 
    f=fspecial('gaussian',[1,1+2*ceil(3*sigma)],sigma);
end

% Smooth diffentiate vector with 1-D convolution with `same` size
gfield=convn(D,f,'same');

gfield=abs(gfield); % absolute dynamic range for gradient field
[loc,i]=max(gfield); % max. gradient location
r=rs(i); % radius at max. gradient


