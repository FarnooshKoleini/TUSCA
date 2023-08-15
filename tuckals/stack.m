function [y]=stack(x);
% STACK -- unfold a Matlab 5.2 multidim array.
%
% [y]=uf_col(x);

sz = size(x);
if length(sz) ~=3, 
	error('STACK requires a three-way array.'); 
end;

len = sz(1)*sz(2);
y = zeros(len,sz(3));

% stack first dimension
for i=1:sz(1);
	y(((i-1)*sz(2))+1:i*sz(2),:) = squeeze(x(i,:,:));
end;
