function stack_plot(t,y,offset,norm);
% STACK_PLOT -- stacks traces in a plot
%
% inputs:
%         t: time or x-axis var
%         y: profiles in columns
%    offset: init offset from zero (default = 0)
%      norm: 0 or 1 (default = 1);
%
% stack_plot(t,y,offset,normalize);

if nargin < 4,
	norm = 1;
	if nargin < 3,
		offset = 0;
		
	end;
end;

if norm == 1,
	y = normalize(y);
end;

rt = length(t);
if length(y) ~= rt,
	error('STACK_PLOT: t and y must be the same lenght');
end;

[r,c] = size(y);

if rt ~= r,
	y = y';
	[r,c] = size(y);
end;

ymax = max(y);
ymin = min(y);
yrange = ymax - ymin;
blank = 0.1*max(abs((yrange)));

for i = 1:c
	plot(t,offset - ymin(i) + y(:,i)); hold on;
	offset = offset + yrange(i) + blank;
end;
hold off;

