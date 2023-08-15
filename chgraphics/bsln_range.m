function [xb,xb_coef,id_bsln]=bsln_range(wv,x,id_bsln);
% BSLN_RANGE -- Baseline correct spectra in selected range.
%
%Non-interactive:
% [xb,xb_coef,id_bsln]=bsln_range(wv,x,id_bsln);
%
%Interactive:
% [xb,xb_coef,id_bsln]=bsln_range(wv,x);
%
%   x: matrix to be baseline corrected;
%
%      xb = baseline corrected spectra.
% xb_coef = vector of correction constants.
% id_bsln = indices of the selected range
%

[r,c]=size(x);

if length(wv) ~= c,
	error('BSLN_RANGE: Error, length of wv is not equal to number of columns in x');
end;

if nargin == 3,
	if isempty(id_bsln)
		warning('bsln_range -- nill baseline range.');
	end;
	xb_coef = mean(x(:,id_bsln)');	% calc avg offset
	xb = x - xb_coef(ones(1,c),:)';
else
	id_bsln = [];
	fig1 = figure;
	colorlin(r*1.2);
	subplot(2,1,1); plot(wv,x,'-');
	axis('tight');
	title('Uncorrected');
	disp('Select wvln range with mouse 2 clicks.'); 
	
	while 1 == 1,
		
		% get mouse clicks
		
		figure(fig1); subplot(2,1,1);
		[idx,wvi,xi] = sel_range_sub(wv,x);
		
		if isempty(idx);
			if isempty(id_bsln)
				warning('bsln_range -- nill baseline range.');
			end;
			delete(fig1);
			return	% if no more mouse clicks, we're done.
		end;
        id_bsln = idx;
		if length(id_bsln) == c,  	% full range? (e.g., reset)
			xb_coef = zeros(1,r)';		% if reset, set offsets to 0
		else
			xb_coef = mean(xi')';	% calc avg offset
		end;
		xb = x - xb_coef(:,ones(1,c));
		subplot(2,1,2); plot(wv,xb,'-'); axis('tight');
	end;
end;
