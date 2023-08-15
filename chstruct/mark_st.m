function y = mark_st(x);
%MARK_ST -- Mark t0 for kinetic fitting in a structure of spectra
%
%   y = mark_st(x);
%

y = x;  % copy structure

m = length(x);
for i=1:m
    if isfield(x,'name'); 
        fprintf(1,'Processing %g: %s\n',i,x(i).name); 
    end;
    z = mark_t0(x(i).t,x(i).dat);
    if isempty(z.t); 
        break; 
    end;
    y(i).t = z.t;
    y(i).dat = z.a;
end;
