function [y]=sub_st(x,idx);
%SUB_ST -- Get submatrix in a structure of spectra
%
%   sub_st(x,idx);
%
%       x: structured array of spectra.
%     idx: index of wavelengths to retain

m = length(x);
y = x;

for i=1:m
	y(i).dat = y(i).dat(:,idx);
	y(i).wv = y(i).wv(idx);
end;
