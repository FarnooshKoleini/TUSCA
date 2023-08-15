function [cp,ep,t] = nway_smcr(a,e,noise,tol,max_iter);
% NWAY_SMCR -- multi-way SMCR w/ non-negativity constraints
%
% >>input
% a:      structure of data matrices (spectra in row)
% e:      structure of initial spectra estimated by one-way SMCR analysis
%         NOTE-the initial starting solution is the average of e.
%noise:   scalar to adjust fuzziness of constraints (Optional, 1=default.)
% tol:    Termination RMS difference (default=1e-6)
% max_iter: default is 50
%
% <<output
% cp:     structure contains refined concentration profile
% ep:     refined pure spectrum
% t:      RMS error at termination
%
% [cp,ep,t]=nway_smcr(a,e_avrg,noise,tol,max_iter);

if nargin < 5, max_iter=50; end;
if nargin < 4, tol = 1e-6; end;
if nargin < 3, noise = 1; end;

[nr,nc]=size(e(1).dat);
k=nr;
n=length(a);

etest = e(1).dat;
for i=2:n
	etest = etest + e(i).dat;
end;
etest = etest / n;
figure(3); plot(etest'); drawnow; hold on;

e_new = zeros(nc,nr);
% using average pure spectrum to start the refine
iter = 1;
for i=1:n

	cp(i).name = a(i).name;
   	cp(i).t = a(i).t;
	cp(i).wv = 1:k;

	ep(i).name = a(i).name;
	ep(i).t = 1:k;
   	ep(i).wv = a(i).wv;
	
   	[ep(i).dat,c]=non_neg(a(i).dat',etest',noise);
	cp(i).dat = c';
   	drawnow;
   	e_new = e_new + ep(i).dat;
end

% test convergence
e_new = e_new' / n;
figure(3); plot(e_new'); drawnow;

while (sum(sum(etest-e_new).^2)/sum(sum(etest.^2))>tol & iter<max_iter)
   figure(3); plot(e_new'); drawnow;
   iter = iter + 1;
   etest = e_new;
   e_new = zeros(nc,nr);
   for i=1:n
	  [ep(i).dat,c]=non_neg(a(i).dat',etest',noise);
	  cp(i).dat = c';
      drawnow;
      e_new = e_new+ep(i).dat;
   end
   e_new = e_new' / n;
   figure(3); plot(e_new'); drawnow;
end
t=sum(sum(etest-e_new).^2)/sum(sum(etest.^2));
figure(3); hold off;
for i=1:n
	ep(i).dat = ep(i).dat';
end;


