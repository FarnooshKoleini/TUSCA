function [y]=plot_cp(x,fignum);
%PLOT_CP -- plot a structured CP array end to end
%
%   plot_cp(x);
%
%       x: structured array of spectra.

if nargin < 2,
   fignum = 1;
end;

m = length(x);

cp = rebuild_struct(x,'dat',1);	% make one big vector
t = x(1).t;
% ix(1).sel = 1:length(x(1).t);
for i = 2:m
% 	ix(i).sel = ix(i-1).sel(end) + (1:length(x(i).t));
	t = [t t(end) + x(i).t];
end;
t = reshape(t,prod(size(t)),1);



figure(fignum); 
plot(t,cp);

figure(fignum+1);
plot(x(1).t,x(1).dat);
hold on;

for i=2:m
	plot(x(i).t,x(i).dat);
end;
hold off;
