
function label_plot(x,y,s,ix)
% LABEL_PLOT -- add labels, s, to x,y scatter plots.

% The variables x, and y specify the location of the points in the plot.
%
% The optional variable, s, contains labels (cell, string or char arrays).
% The optional variable, ix, describes which points are to be labeled.
% If ix is omitted, all points are labeled.
% If s is omitted, sequential numerical labels are generated.
%
% label_plot(x,y,s,ix); or label_plot(x,y,s)  or label_plot(x,y)

r=length(x);                    % num points
if nargin < 4, ix = 1:r; end;   % label all points if ix missing
if nargin < 3, s=ix; end;       % generate numeric lables if s missing

% sprintf is matlab's formated string print function

if isstring(s)      % label w strings
    for i=ix
        text(x(i),y(i),sprintf('  %s',s(i)));
    end
elseif iscell(s)    % label with cells
    for i=ix
        text(x(i),y(i),sprintf('  %s',s{i}));
    end
elseif isfloat(s)   % label with sequential numbers
    for i=ix
        text(x(i),y(i),sprintf('  %g',s(i)));
    end
else
    error('Label class not recongized (string, cell, or float)')
end
