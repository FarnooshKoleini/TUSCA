function [cn,en] = noneg_st(x,cp,noise);
%NONEG_ST -- Do find non_neg lsq solution on each data set in a structure of spectra
%
%   [cn,en] = noneg_st(x,cp,noise);
%
%   cp:     initial solution (structure)
%   x.name: orginal file name
%   x.t:    acq times, nx1
%   x.wv:   acq wvlns, 1xm
%   x.dat:  spectra, nxm
%
%   noise:  allowed noise levels (default = 1)
%
%   cn.name: orginal file name
%   cn.t:    acq times, nx1
%   cn.wv:   constituent number, 1xk
%   cn.dat:  scaled wfa conc profiles, nxk
%
%   en.name: orginal file name
%   en.t:    constituent number, kx1
%   en.wv:   acq wvlns, 1xm
%   en.dat:  wfa spectral profiles, kxm

if nargin < 3, noise = 1; end;
m = length(x);
cn = cp;
en = cp;

for i=1:m
   fprintf(1,'\n\nProcessing %g: %s\n',i,x(i).name);
   [cn(i).dat,en(i).dat] = non_neg(x(i).dat,cp(i).dat,noise);
   drawnow;
   en(i).t = cp(i).wv;
   en(i).wv = x(i).wv;
end;

