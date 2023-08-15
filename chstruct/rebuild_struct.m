function [a]=rebuild_struct(uv,varible,choice);
%
% [a]=rebuild_struct(uv,varible,choice);
% REBUILD_STRUCT: concatenate the structure data into 2 
%                 or 3 dimentional matrix.
% uv: structure data with the following field
%     uv.name: name of the data file
%     uv.t:  time
%     uv.wv: wavelength
%     uv.dat: spectra
%     uv.m:  number of data files selected
% varible: field in uv that will be concatenated
% choice: 1- a vertically concatenated 2-d matrix
%         2- a horizontally concatenated 2-d matrix
%         3- a three dimential matrix
% a:  the resulting concatenated data

if (nargin==2),
   choice=menu('Choose a pattern','vertically concatenated 2-d matrix',...
      'horizontally concatenated 2-d matrix','3-d matrix');
end;
d=['uv' '.' varible];
if (choice==1),
   eval(sprintf('a=cat(1,%s);',d))
   %t=cat(1,uv.t);
   %wv=uv(1).wv;
   %m=uv(1).m;
end;

if (choice==2),
   eval(sprintf('a=cat(2,%s);',d))
   %wv=cat(2,uv.wv);
   %t=uv(1).t;
   %m=uv(1).m;
end;

if (choice==3),
   eval(sprintf('a=cat(3,%s);',d))
   %wv=uv(1).wv;
   %t=uv(1).t;
   %m=uv(1).m;
end;
