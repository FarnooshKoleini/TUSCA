function [x]=edit_st(y);
%EDIT_ST -- replace a data set in a structure of spectra from multiple runs
%   [x]=edit_st(y);
%   y.name: orginal file name
%   y.t:    acq times, nx1
%   y.wv:   acq wvlns, 1xm
%   y.dat:  spectra, nxm

x=y;
m=length(y);

disp('Names of data files stored in structure y:');

for i=1:m
   disp(sprintf('%g %s',i,y(i).name));
end;

x2=input('Enter the indentifier for the time intervals: ', 's');
x3=input('Enter the indentifier for the wavelengths: ', 's');
x4=input('Enter the indentifier for the spectra: ', 's');

n=input('Enter N, the number of data set to be replaced, 0 to stop: ');
while n > 0,
   [fn pt]=uigetfile('*.mat','select a data file to build the structure');
   load(strcat(pt,fn));
   disp(fn);
   x(n).name = fn;
   eval(sprintf('x(n).t=%s;',x2));
   eval(sprintf('x(n).wv=%s;',x3));
   eval(sprintf('x(n).dat=%s;',x4));
   n=input('Enter N, the number of data set to be replaced, 0 to stop: ');
end;
 
