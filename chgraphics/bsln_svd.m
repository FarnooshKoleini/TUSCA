function [yb,bsln,vr]=bsln_svd(y,k,p,plot_flag);
% bsln_svd -- baseline correct a data matrix by use of augmented SVD [V;1]
%
% [yb,bsln,v]=bsln_svd(y,k,p,plot_flag);
%
% OUTPUTS
%   yb: baseline corrected data
% bsln: baseline correction
%    v: percent varaiance modeled by baseline correction
%
% INPUTS
%  y: uncorrected data
%  k: number of factors to use (default = 1)
%  p: polynomial order for fitting [0 1 2 or 3] (default = 0)
%  1: plot flag 1 = produce plots 0 = no plots (default = 1);

if nargin < 4,
   plot_flag = 1;
end;

if nargin < 3,
   p = 1;
end;

if nargin < 2,
   k = 1;
end;

[u,s,v]=svdt(k,y);
[n,m]=size(y);

vv = [v*s ones(m,1)];      % augment V w/ spectrum of ones (this is hypth model for baseline
for i = 1:p
   vv = [vv  normalize((1:m)'.^(i))]; % add polynomial terms if requested
end;

[rvv,cvv]=size(vv);        % get num extra components

sc = y / vv';              % calc scores for augmented V

yb = sc(:,1:k)*vv(:,1:k)'; % est baseeline corrected spectra
bsln = sc(:,k+1:cvv)*vv(:,k+1:cvv)';  % est baseline from augmented scores

tot_var = sum(sum(y.^2));
vr = 100*sum(sum(bsln.^2))/tot_var;

if plot_flag > 0,
   figure; subplot(3,1,3);plot(sc(:,1:k)); 
   h1=title(sprintf('PCA scores vs. time at k = %g',k));
   subplot(3,1,2);plot(sc(:,k+1:k+p+1)); 
   h2=title(sprintf('Bsln scores vs. time at p = %g',p));
   subplot(3,1,1); colorlin(1.1*n); plot(yb'); 
   title(sprintf('Bsln corrected spectra at k = %g factors and p = %g polynomial',k,p));
   fprintf(1,'%% baseline variance: %g\n',vr);
end