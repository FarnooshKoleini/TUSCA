function colorlin(n_lines);
% COLORLIN -- changes the line colormap to n_lines, 0 resets default colors
%
% use: colorlin(n)

if nargin < 1,
	n_lines = 0;
end;

if n_lines > 0,
   set(gcf,'defaultaxescolororder',hsv(round(n_lines)))
else
   set(gcf,'defaultaxescolororder',[0 0 1; 0 0.5 0; 1 0 0; 0 .75 .75; .75 0 .75; .75 .75 0; .25 .25 .25]);
end
