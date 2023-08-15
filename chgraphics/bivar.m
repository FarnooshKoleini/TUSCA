function [z]=bivar(m,s);
% BIVAR - plot bivariate distribution function
%
% variance-covariance matrix in s.
% mean in m.
%
% [z]=bivar(m,s);
%
% TRY:
%   s = [1 .3; .3 1];
%   m = [0 ; 0];

[x1,x2] = meshgrid(-3:.05:3, -3:.05:3);
x=zeros(2,14641);
x(1,:)=reshape(x1,1,14641) - m(1);
x(2,:)=reshape(x2,1,14641) - m(2);

d=x'*inv(s);
d=sum((d.*x')');
d=reshape(d,121,121);

z=1./(2*pi*sqrt(det(s))) * exp(-1/2*d);

figure(1);
contour(x1,x2,z,5); 
xlabel('X standard variates'); 
ylabel('Y standard variates'); 
set(gca,'xtick',-3:1:3); 
set(gca,'ytick',-3:1:3);
colormap([0 0 0])
rand; sd=rand('seed');
default_fname=sprintf('fig_%1.0f',sd);
fname=input(sprintf('Enter file name for saving figure [%s] or "none": ',default_fname),'s');
pub_fig(fname,'white',1,10,2.25,2.25,'helvetica');

figure(2);
mesh(x1(1:5:121,1:5:121),x2(1:5:121,1:5:121),z(1:5:121,1:5:121)); 
xlabel('X');
set(gca,'xtick',-3:1:3); 
ylabel('Y'); 
set(gca,'ytick',-3:1:3); 
zlabel('Relative frequency');
axis([-3.1 3.1 -3.1 3.1 -0.001 .2]);
msh=get(gca,'child');
set(msh,'linewidth',1);
colormap([0 0 0])
grid off
view(-20,20);
rand; sd=rand('seed');
default_fname=sprintf('fig_%1.0f',sd);
fname=input(sprintf('Enter file name for saving figure [%s] or "none": ',default_fname),'s');
pub_fig(fname,'white',1,10,2.25,2.5,'helvetica');
