function [b,ind]=bsln_poly(a,wv,np);
% BSLN_POLY -- Fit polynomial baseline corrections to data.
%
% a:   data matrix or spectra (m*n)
% wv:  wavelength (1*n)
% np:  polynomial order  (default=2) 
%
% b:   baseline corrected data
% ix:  index of colvars selected for basline fitting
%
% [b,ix]=bsln_poly(a,wv,n);

if nargin<3,    
   np=2;
end;
[nn,m]=size(a);
b=zeros(nn,m);

if nargin<2
   wv=[1:m];
end;

[z,zz]=size(wv);  % check the dimension of wv
if z>1,
   wv=wv';
end;

figure(1);
plot(wv,a);
hold on;
[x,y]=ginput;     % gets points for correction by mouse clicking
n=length(x);      % gets No. of points
[yy,ind]=min(abs(wv(ones(n,1),:)'-x(:,ones(m,1))')); %gets the wv closest to selected points 

for i=1:nn,
    p=polyfit(ind,a(i,ind),np);
    figure(1);
    yy=polyval(p,1:m);
    plot(wv,yy);
    plot(wv(ind),a(i,ind),'o');
    b(i,:)=a(i,:)-yy;
end;
hold off;
% b = b - min(min(b));
figure(2);plot(wv,b);
title('Baseline corrected Spectra');
