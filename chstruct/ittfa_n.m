function [cp,ep,re]=ittfa_n(x,k,w,tol,max_iter);
% ITTFA_N - N way iterative target transf. factor analysis,
% 
% Command to perform ITTFA self-modeling curve
% resolution of a k-component structured matrix, x.
% Rows in a should be spectra.  
%
% [cpred,epred,re]=ittfa_n((x,k,w,tol,max_iter);
%
%   x.name:  orginal file name
%   x.t:     acq times, nx1
%   x.wv:    acq wvlns, 1xm
%   x.dat:   spectra, nxm
%
%   k:       number of factors to use
% 	w>0: 	 use wide needle search (optional);
% 	tol: 	 converge tolerance (optional, default = 1e-6;)
% 	max_iter: max no. iterations (optional, default = 50)
%
%   cp.name: orginal file name
%   cp.t:    acq times, nx1
%   cp.wv:   constituent number, 1xk
%   cp.dat:  scaled wfa conc profiles, nxk
%
%   ep: 	 pure spectra
%   ep.t:    constituent number, kx1
%   ep.wv:   acq wvlns, 1xm
%   ep.dat:  wfa spectral profiles, kxm


if nargin < 5,
	max_iter = 50;
end;

if nargin < 4,
	tol = 1e-6;
end	

if nargin < 3,
	w = 0;
end;

n_files = length(x);
ctest = x;
cp = x;
ep = x;

% build selectors for ctest, cpred.
ix(1).sel = 1:length(x(1).t);
t = x(1).t;
for i = 2:n_files
	ix(i).sel = ix(i-1).sel(end) + (1:length(x(i).t));
	t = [t t(end) + x(i).t];
end;
t = reshape(t,prod(size(t)),1);

for i=1:n_files
	fprintf(1,'Processing %g: %s\n',i,x(i).name);
	cp(i).wv = 1:k;
	ep(i).t = 1:k;
  	[ctest(i).dat,index(:,:,i)] = ittfa_sub(x(i).dat,k,x(i).t);	% get initial test vector
end;

ctest = rebuild_struct(ctest,'dat',1);	% make one big ctest vector
d = rebuild_struct(x,'dat',1);			% make one big data matrix

% loop to refine each set of vectors...

niter = 1;
rel_change = 1;
old = 2;
while abs(old - rel_change) > tol
	for i = 1:n_files
		epred = ctest \ d;						% calc cpred
		cpred = d / epred;
		ctest(ix(i).sel,:) = refine(cpred(ix(i).sel,:),index(:,:,i));
		figure(1); plot(t,cpred); hold on;
		figure(2); plot(x(1).wv,epred); hold on;
	end;
	old = rel_change;
	rel_change = sum((cpred-ctest).^2)/sum(ctest.^2);
	niter = niter + 1;
	if niter > max_iter,
		fprintf(1,'Warning - ITTFA did not converge in %g iterations.\n',niter);
		break
	end;
end
figure(1); hold off;
figure(2); hold off;
re = zeros(1,n_files);
for i = 1:n_files
	cp(i).dat = cpred(ix(i).sel,:);
	ep(i).dat = epred;
	re(i) = sum(sum((x(i).dat - cp(i).dat * ep(i).dat).^2));
	re(i) = sqrt(re(i)/((length(x(i).t)-k)*(length(x(i).wv-k))));
end;


%------------------------------------------------------------------------------
% PRIVATE FUNCTION FOR GETTING INITIAL TEST VECTORS
function [ctest,idx]=ittfa_sub(a,k,tt,w);
% subroutine to initialize multi-way ittfa
[n,m] = size(a);
if nargin < 4,
	w = 0;
end;

if nargin < 3,
	tt = 1:n;
end;

[nt,mt] = size(tt);

if mt > nt, 
	t = tt'; 
	nt = mt; 
else, 
	t=tt; 
end;

if nt ~= n,
	error('ITTFA - Number of rows in data matrix ''a'' and length of vector ''t'' must match.')
end;

[u,s,v]=svd(a);
u=u(:,1:k);
s=s(1:k,1:k);
v=v(:,1:k);

% needle search

ctest=eye(n);  % genereate uniqueness test vectors.

% use wide needles if w > 1.

if w > 0,
	ctest=ctest+[ctest(:,2:n) zeros(n,1)]+[zeros(n,1) ctest(:,1:n-1)];
end;
resid=diag((ctest-u*(u'*ctest)).^2);
resid=lowess(t,resid,0.05);
% plot results of needle search, saving handle to circles

tmp = findmin(resid);	% find local minima
nminima = length(tmp);	% count number of minima

index = zeros(nminima,3);  % save 'em here
index(:,1) = tmp;          % column 1 = position of minima
% column 2 = de-selected/selected flag (0/1)
% column 3 = handle to object on plot

title('Residuals from needle search');
plot(t,resid); hold on;  
for i=1:nminima;				% add red circles to the plot
	index(i,3)=plot(t(index(i,1)),resid(index(i,1)),'ro'); % and save handle
end;
hold off;

fprintf(1,'\nMinima found at:\n'); fprintf(1,' %5.0f  %9.4f\n',[index(:,1),t(index(:,1))]');
fprintf(1,'\nPlease select %g local minima by clicking the mouse.\n\n',k);
disp('Click the mouse button to select or de-select points.');
disp('On the Mac <shift> click creates a new point.');
disp('On Windows right click creates a new point.');
disp(' ');
disp('Hit <return> when you are finished.'); 

npks = 0;

[x,y,b]=ginput(1);		% get initial mouse click
while npks ~= k,		% repeat until k points selected.
	while ~isempty(b) & b ~= 13,		% repeat until <return> sends null button
		if b==1,						% come here to de-select/select a peak
			[xx,idx]=min(abs(t(index(:,1))-x));	% get location of closest circle
			if index(idx,2) == 0,			% if this pt not selected
				if npks == k,				% oops, too many selected, warn user
					waitdlg(warndlg(...
					sprintf('You can''t select more than %g points.\nDe-select a point first.',k),'ITTFA'));
				else	% come here to select a point
					npks = npks + 1;
					index(idx,2) = 1;			      	 % mark it selected
					set(index(idx,3),'color',[0 1 0]); % and make it green
				end;
			else	% come here to deselect a point
				npks = npks - 1;
				index(idx,2) = 0;	% mark it un-selected
				set(index(idx,3),'color',[1 0 0]) % and make it red
			end;
		else		% come here to add a new point
			[xx,idx]=min(abs(t(index(:,1))-x));	% get location of closest circle
			[xxx,idxx]=min(abs(t-x));
			if index(idx,1) ~= idxx,			% test to see if point already selected
				nminima = nminima + 1;		% add a new point
				index(nminima,1) = idxx;		% location of point
				index(nminima,2) = 0;			% mark it un-selected
				hold on;
				index(nminima,3) = ...
				plot(t(index(nminima,1)),resid(index(nminima,1)),'ro'); % and save handle
				hold off;
			else
				waitdlg(warndlg('Point is already marked, not added.','ITTFA'));
			end;
		end;
		[x,y,b]=ginput(1);
	end;

	if npks < k, 
		waitdlg(warndlg(sprintf('You must select %g points.',k),'ITTFA'));
		[x,y,b]=ginput(1);
	end;
end;  

idx = index(find(index(:,2)==1),1);
idx = sort(idx);

fprintf(1,'\nMinima selected at:\n'); fprintf(1,' %5.0f  %9.4f\n',[idx,t(idx)]');

ctest=ctest(:,idx);
%------------------------------------------------------------------------------
% PRIVATE FINDMIN funtion
function [index] = findmin(resid);
% FINDMIN -- generate an index of all local minima in a vector.
%
% [index] = findmin(resid);
n=length(resid);
temp=resid;
[y,i]=min(temp);
for j=2:n,
	if resid(j)>=resid(j-1), 
		temp(j)=0;
	end;
end;
for j=n-1:-1:1,
	if resid(j)>=resid(j+1), 
		temp(j)=0;
	end;
end;
index=find(temp~=0);

%------------------------------------------------------------------------------
% PRIVATE REFINE function
function [ctest]=refine(cpred,index);
%REFINE -- subroutine for ittfa

[r,c]=size(cpred);
ctest=cpred;
ctest=ctest.*(ctest>0);
for l=1:c,
	i=index(l);
	for j=i+2:length(ctest),
		if ctest(j-1,l)==0,
			ctest(j,l)=0;
		end
	end;
	for j=i-2:-1:1,
		if ctest(j+1,l)==0,
			ctest(j,l)=0;
		end
	end;
end;
