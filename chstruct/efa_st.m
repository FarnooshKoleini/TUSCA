function [y]=efa_st(x,k);
%EFA_ST -- Do EFA of data sets in a structure of spectra
%   y=efa_st(x,k);
%   y.name: orginal file name
%   y.t:    acq times, nx1
%   y.wv:   acq wvlns, 1xm
%   y.dat:  efa scores, nxk

m=length(x);
y=x;

i=1;
fprintf(1,'%g %s\n',i,x(i).name);
y(i).dat = efa_scor(x(i).dat,k);
y(i).wv = 1:k;

for i=2:m
   fprintf(1,'%g %s\n',i,x(i).name);
   sc = efa_scor(x(i).dat,k);

   % make sure sign of this data set is same as last one

   idx=find(sum(y(i-1).dat.*sc) < 0);
   sc(:,idx) = -sc(:,idx);

   y(i).dat = sc
   y(i).wv = 1:k;
end;

