function [xn,xn_coef,id_norm]=norm_range(wv,x,opt,id_norm);
% NORM_RANGE -- normalize spectra in selected range.
%
%Non-interactive:
% [xn,xn_coef,id_norm]=norm_range(wv,x,opt,id_norm);
%
%Interactive:
% [xn,xn_coef,id_norm]=norm_range(wv,x,opt);
%
%   x: matrix to be normalized;
%
% opt: [0/1], 0 = norm to max area (default)
%             1 = norm to max value
%
%      xn = matrix of normalized spectra.
% xn_coef = vector of normalization constants.
% id_norm = indices of the selected range
%

[r,c]=size(x);
xm = ones(1,r);

if length(wv) ~= c,
	error('NORM_RANGE: Error, length of wv is not equal to number of columns in x');
end;

if nargin == 4,
	if isempty(id_norm)
		warning('norm_range -- nill baseline range.');
	end;
	if opt == 0,
		xn_coef = sum(x(:,id_norm)');	% calc area
	elseif opt == 1,
		xn_coef = max(x(:,id_norm)');
	end;
	xn_coef_max = max(xn_coef);		% max area
	xn_coef = xn_coef / xn_coef_max;		% calc normalization factor
	xn = (x ./ xn_coef(ones(1,c),:)');
else
	id_norm = [];
	if nargin < 3,
		opt = 0;
	end;

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
			if isempty(id_norm)
				warning('bsln_range -- nill baseline range.');
			end;
			delete(fig1);
			return	% if no more mouse clicks, we're done.
		end;
        id_norm = idx;
		if length(idx) == c,  	% reset?
			xn_coef = xm;		% if reset, set scale factors to 1.0
		elseif opt == 0,
			xn_coef = sum(xi');	% calc area
		elseif opt == 1,
			xn_coef = max(xi');
		end;
		xn_coef_max = max(xn_coef);		% max area
		xn_coef = xn_coef / xn_coef_max;		% calc normalization factor
		xn = (x ./ xn_coef(ones(1,c),:)');
		subplot(2,1,2); plot(wv,xn,'-'); axis('tight');
	end;
end
