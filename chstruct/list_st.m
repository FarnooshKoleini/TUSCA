function list_st(x);
%LIST_ST -- List names of data sets in a structure of spectra
%   list_st(x);
%   y.name: orginal file name
%   y.t:    acq times, nx1
%   y.wv:   acq wvlns, 1xm
%   y.dat:  spectra, nxm

m=length(x);

disp('Names of data files stored in structure y:');

for i=1:m
   disp(sprintf('%g %s',i,x(i).name));
end;

for i=1:m
   disp(x(i));
end; 
