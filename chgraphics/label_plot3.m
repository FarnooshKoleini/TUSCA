function label_plot3(x,y,z,s,ix)
% LABEL_PLOT3 -- plot x,y,z scatter plot w/ string s or numerical point labels, n
%
% lab_plot3(x,y,z,s,ix) lables the points in a scatter plot according to the values in n with string s.
% The variables x, y, and z specify the location of the points in the plot.
% The optional variable, s, contains labels (cell, string or char arrays).
% The optional variable, ix, describes which points are to be labeled.
% If ix is omitted, all points are labeled.
% If s is omitted, sequential numerical labels are generated.
%
% label_plot3(x,y,z,s,ix); or label_plot(x,y,z,s)  or label_plot(x,y,z)

r=length(x);                    % num points
if nargin < 5, ix = 1:r; end;   % label all points if ix missing
if nargin < 4, s=ix; end;       % generate numeric lables if s missing

% sprintf is matlab's formated string print function

if isstring(s)      % label w strings
    for i=ix
        text(x(i),y(i),z(i),sprintf('  %s',s(i)));
    end
elseif iscell(s)    % label with cells
    for i=ix
        text(x(i),y(i),z(i),sprintf('  %s',s{i}));
    end
elseif isfloat(s)   % label with sequential numbers
    for i=ix
        text(x(i),y(i),z(i),sprintf('  %g',s(i)));
    end
elseif error('Label class not recongized (string, cell, or float)')
end