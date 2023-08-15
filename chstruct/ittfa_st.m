function [cp,ep] = ittfa_st(x,k);
%ITTFA_ST -- Do ITTFA analysis on each data set in a structure of spectra
%
%   [cp,ep] = ittfa_st(x,k);
%
%   k:      number of factors to use
%   x.name: orginal file name
%   x.t:    acq times, nx1
%   x.wv:   acq wvlns, 1xm
%   x.dat:  spectra, nxm
%
%   cp.name: orginal file name
%   cp.t:    acq times, nx1
%   cp.wv:   constituent number, 1xk
%   cp.dat:  scaled wfa conc profiles, nxk
%
%   ep.name: orginal file name
%   ep.t:    constituent number, kx1
%   ep.wv:   acq wvlns, 1xm
%   ep.dat:  wfa spectral profiles, kxm


m = length(x);
cp = x;
ep = x;

for i=1:m
   fprintf(1,'Processing %g: %s',i,x(i).name);
   c = ittfa(x(i).dat,k,x(i).t);
   drawnow;

   cp(i).wv = 1:k;
   cp(i).dat = c; % concscal(c);

   ep(i).t = 1:k;
   ep(i).dat = cp(i).dat\x(i).dat ;
end;

