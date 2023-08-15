function []=dirlist(fn,print_dates)
% DIRLIST -- produce a directory listing, one line at a time
%
if nargin < 1,
    d = dir;
else
    d = dir(fn);
end;

if nargin < 2
    for i = 1:length(d);
        fprintf(1,'%s\n',d(i).name)
    end;    
else
    for i = 1:length(d);
        fprintf(1,'%s\t%s\n',d(i).name,d(i).date)
    end;
end;