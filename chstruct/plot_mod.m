function [chat,ehat] = plot_mod(x,cp,hold_on);
%PLOT_MOD -- Plot SMCR or kinetic model for each data set in a structure of spectra
%
%   [chat,ehat]=plot_mod(x,cp,hold_on);
% 		or
%   [chat,ehat]=plot_mod(x,ep,hold_on);
%
%   x.name: orginal file name
%   x.t:    acq times, nx1
%   x.wv:   acq wvlns, 1xm
%   x.dat:  spectra, nxm
%
%   cp.name: orginal file name
%   cp.t:    acq times, nx1
%   cp.wv:   constituent number, 1xk
%   cp.dat:  model conc profiles, nxk
%
%   hold_on: set to one to make overlay plot
%
%   chat & ehat are struct vars containing the est conc profiles and spectra.

if nargin < 3, hold_on = 0; 
end;

m = length(x);

[rx,cx] = size(x(1).dat);
[rc,cc] = size(cp(1).dat);

chat = cp;
ehat = cp;

if rx == rc,
	%
	% do cp calcs
	%
	for i=1:m
		fprintf(1,'Processing %g: %s\n',i,x(i).name);
		
		t = x(i).t;
		wv = x(i).wv;
		y = cp(i).dat;
		
		ep = y\x(i).dat;
		yh = x(i).dat/ep;
		chat(i).dat = yh;
		
		ehat(i).t = 1:cc;
		ehat(i).wv = wv;
		ehat(i).dat = ep;
		
		figure(1); plot(t,y); hold on; plot(t,yh,'--'); 
		if not(hold_on), 
			hold off,
		end;
		% title('(-) kinetic model.  (- - -) fit to spectra.');
		
		figure(2); plot(wv,ep); 
		if hold_on,
			hold on; 
		end;
		pause;
	end;
else
	%
	% do ep calcs
	%
	for i=1:m
		fprintf(1,'Processing %g: %s\n',i,x(i).name);
		
		t = x(i).t;
		wv = x(i).wv;
		y = cp(i).dat;
		
		ep = x(i).dat/y;
		yh = ep\x(i).dat;
		ehat(i).dat = yh;
		
		chat(i).t = t;
		chat(i).wv = 1:rc;
		chat(i).dat = ep;
		
		figure(1); plot(t,chat(i).dat); hold on; 
		if not(hold_on), 
			hold off,
		end;
		% title('(-) kinetic model.  (- - -) fit to spectra.');
		
		figure(2); plot(wv,cp(i).dat); hold on; plot(wv,ehat(i).dat,'--'); 
		if not(hold_on), 
			hold off; 
		end;
		pause;
	end;
end;

figure(1); hold off;
figure(2); hold off;
