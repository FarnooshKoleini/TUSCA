function [x]=build_st();
%BUILD_ST -- build a data structure of spectra from multiple runs
%   [x]=build_st();
%   x.name: orginal file name
%   x.t:    acq times, nx1
%   x.wv:   acq wvlns, 1xm
%   x.dat:  spectra, nxm

m=input('Enter N, the number of data sets to be saved in the structure: ');

x2=input('Enter the indentifier for the time intervals: ', 's');
x3=input('Enter the indentifier for the wavelengths: ', 's');
x4=input('Enter the indentifier for the spectra: ', 's');

for i = 1:m
   [fn pt]=uigetfile('*.mat','select a data file to build the structure');
   s=load(strcat(pt,fn));
   disp(fn);
   x(i).name = fn;
   eval(sprintf('x(i).t=s.%s;',x2));
   eval(sprintf('x(i).wv=s.%s;',x3));
   eval(sprintf('x(i).dat=s.%s;',x4));
  
end;
 
