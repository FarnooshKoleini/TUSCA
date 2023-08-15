function scores3d(x,y,z,opt);
% SCORES3D -- Plot three columns of scores in 3D w/ color.
% scores3d(x,y,z,opt)
%
% opt = 0 or 1, show shadows = 1 (default)
% See BIPLOT3D

% COPYRIGHT, 1996.  Un-authorized use prohibited.
% Paul J. Gemperline
% Department of Chemistry
% East Carolina University
% Greenville, NC 27858
% 919-328-6767
% chgemper@ecuvax.cis.ecu.edu

if nargin < 4
   opt = 1;
end;

xx=x'; yy=y'; zz=z';

[r,c]=size(xx);
colormap(jet(128));

% first determine the size of the auto axis & erase the plot

xm=mean(xx); ym=mean(yy);

h_surface = surface([ones(1,c)*xm;xx],[ones(1,c)*ym;yy],[zz;zz]); 
view([-40, 40]); ax=axis;
clf

if opt == 1,
   % plot shadows first.
   plot3(xx,yy,ones(1,c)*ax(5),'color',[ .5 .5 .5],'marker','o');
   
   % freeze the axes...
   axis(ax);
   hold on;
   
   plot3(ones(1,c)*ax(2),yy,zz,'color',[ .5 .5 .5],'marker','o');
   
end;

% plot the data sequence as circles
h1 = surface([ones(1,c)*ax(1);xx],[ones(1,c)*ax(4);yy],[zz;zz],...
	'facecolor','none',...
	'edgecolor','flat',...
	'meshstyle','row',...
	'linewidth',1,...
	'marker','o');

% connect the dots...
h2 = surface([ones(1,c)*ax(1);xx],[ones(1,c)*ax(4);yy],[zz;zz],...
	'facecolor','none',...
	'edgecolor','flat',...
	'meshstyle','row',...
	'linewidth',1);
view([-40 40]);
grid on;

hold off;
