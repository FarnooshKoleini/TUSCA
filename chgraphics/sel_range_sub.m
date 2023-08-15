function [idx,wvi,xi] = sel_range_sub(wv,z);
%  SEL_RANGE - get subrange of wavelengths from mouse clicks
%
%  [idx,wvi,xi] = sel_range_sub(wv,x);
%
% This function plots a series of vectors in X against wv 
% and then accepts two grahpical clicks
% from the mouse to define a subsets of ranges.
%
% A double click resets the plot.
%
% The ENTER or RETURN key terminates the function.

disp('Click desired end points to select wavelength ranges.');
disp('Double click mouse to reset plot.');
disp('Hit ENTER or RETURN to end.');

ax1= gca;

if nargin < 2,
    z = wv;
    [r,c] = size(z);
    wv = 1:c;
end

[r,c] = size(z);
transp = 0;
if length(wv) ~= r,
    z = z';
    transp = 1;
end;

[r,c] = size(z');
[rs,cs] = size(wv);
if rs > cs, wv = wv'; cs = rs; 
end;

if (cs ~= c),
	error('wv and x must have same number of rows or columns.');
end

idx = zeros(cs,1);

[x,y]=ginput(2);

if isempty(x), 
	idx=[]; wvi=[]; xi=[];
	return
end;

h = get(gcf,'userdata');  % get the old polygon
if ~isempty(h); 
	delete(h);  % erase the old fill range
	set(gcf,'userdata',[]); % and mark it deleted
end;

[w(1),ia]=min(abs(wv-x(1))); % find closest wvlns
[w(2),ib]=min(abs(wv-x(2)));

ix(1) = min(ia,ib); % make sure they are arranged in correct order
ix(2) = max(ia,ib);

[w(1),ia]=min(abs(wv-x(1))); % find closest wvlns
[w(2),ib]=min(abs(wv-x(2)));

if  ia == ib, % double mouse click?
	idx = ones(cs,1);  % yes, select full range
else    
	ix(1) = min(ia,ib); % make sure they are arranged in correct order
	ix(2) = max(ia,ib);
	idx(ix(1):ix(2)) = 1; % record position of selected wvlns
	
	fprintf('\n\n      start        stop');
	fprintf('\nidx:  %7g  %7g\nx:  %9.4g  %9.4g\ny:  %9.4g  %9.4g',ix,x,y);
	fprintf('\n');
	ax = axis;
	
	hold on;
	subplot(ax1);
	h=fill([wv(ix(1)) wv(ix(1):ix(2)) wv(ix(2))],[ax(3) max(z(ix(1):ix(2),:)') ax(3)],'r');
	set(gcf,'userdata',h); % save polygon in figure window if needed later erasure
	hold off;
end;    

idx = find(idx==1);
wvi = wv(idx);
if transp == 1,
	xi = z(idx,:)';
else
	xi = z(idx,:);
end

