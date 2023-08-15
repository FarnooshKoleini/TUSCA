function M=spin(dt,revs);
% SPIN -- rotate a 3d plot 360 degrees about Z-axis in n steps (180=defaul).
%
% spin or spin(dTheta,revs);
%
% try spin(5,4);

if nargin == 0,
   dt = 2;
   revs = 1;
elseif nargin == 1,
   revs = 1;
end


%set(gcf,'renderer','zbuffer');

if nargin < 1, n=180; end;
	
[az,el] = view;	% get current view

j=1;
for i = 1:dt:revs*360; 
 	view(az,el-i); 	% rotate in y axis
   
	drawnow;
    M(j) = getframe;
    j=j+1;
end;
