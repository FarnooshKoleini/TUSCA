function [result,epred,re]=ittfan(uv,k,w,scal,tol,max_iter);
% ITTFA - n-way iterative target transf. factor analysis,
% 
% Command to perform n-way ITTFA self-modeling curve
% resolution of a k-component data matrix, a.
% Rows in a should be spectra.  
%
% [cpred,epred,re]=ittfan(x,k,t,w,tol,max_iter);
%
% x: structure of batches
% k: number of factors to use.
% w>0: use wide needle search (optional);
% tol: converge tolerance (optional, default = 0.0000001;)
% max_iter: max no. iterations (optional, default = 50)
%
% cpred: est. pure chromatograms
% epred: est. pure spectra.
% 
n_files=length(uv);   % get the No. of data files
ind = 1:n_files;

t = uv(1).t;

t1=t(end);

tt=t;
for i=2:n_files
   tt=[tt,t+((i-1)*t1)];
end;

[n,m]=size(uv(ind(1)).dat);

if nargin < 7,
  tol = 0.0000001;
end	

if nargin < 6,
   max_iter = 50;
end;

if nargin < 5,
	w = 0;
end;
if nargin < 4,
   scal=ones(1,n_files);
end;

dd.dat= rebuild_struct(uv(ind),'dat',1);
d=dd.dat;
[uu,ss,vv]=svdt(k,d);

% needle search

ctest=eye(n);  % genereate uniqueness test vectors.
ndx=zeros(k,n_files);

% use wide needles if w > 1.

if w > 0,
	ctest=ctest+[ctest(:,2:n) zeros(n,1)]+[zeros(n,1) ctest(:,1:n-1)];
end;

% plot results of needle search, saving handle to circles

for l = 1:n_files;
	u = reshape(uu,n,k,n_files);
	resid=diag((ctest-(u(:,:,l)*pinv(u(:,:,l))*ctest)).^2);
	tmp = findmin(resid);	% find local minima
	nminima = length(tmp);	% count number of minima

	index = zeros(nminima,3);  % save 'em here
	index(:,1) = tmp;          % column 1 = position of minima
                           % column 2 = de-selected/selected flag (0/1)
                           % column 3 = handle to object on plot

	figure(2);				% plot the residuals
	title('Residuals from needle search');
	plot(t,resid); hold on;  
	for i=1:nminima;				% add red circles to the plot
		index(i,3)=plot(t(index(i,1)),resid(index(i,1)),'ro'); % and save handle
	end;
	hold off;

	fprintf(1,'\nMinima found at:\n'); fprintf(1,'   %g\n',index(:,1));
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
	    			nminima = nminima + 1;			% add a new point
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

	ndx(:,l) = sort(index(find(index(:,2)==1),1));
	fprintf(1,'\nMinima selected at:\n'); fprintf(1,'   %g    %g\n',ndx(:,l),t(ndx(:,1)));
end;

for i=1:n_files,
   uv(ind(i)).test=ctest(:,ndx(:,i));
end;

ctest_com=rebuild_struct(uv(ind),'test',1);

figure(2);hold off;
cpred = uu*uu'*ctest_com;

figure(1);
plot(tt,cpred);
cpred=reshape(cpred',k,n,n_files);
ctest=reshape(ctest_com',k,n,n_files);

for i=1:n_files,
   cnew(:,:,i)=refine3(cpred(:,:,i)',k,ndx(:,i));
end;

hold on

j = 1:k;	% adjust all traces together
	i = 1;
   xx=0;
   for ii=1:n_files
      xx=xx+sum(cnew(:,:,ii)-ctest(:,:,ii)').^2./sum(ctest(:,:,ii)'.^2);
   end;
   
   while any(xx > tol)
      yy=[];
      for ii=1:n_files
         yy=[yy;cnew(:,:,ii)];
      end;
    
    ep = pinv(yy)*d;
    cpred = d / ep;
    plot(tt,cpred);
    cp=reshape(cpred',k,n,n_files);
    ctest=cnew;
    for ii=1:n_files
       cnew(:,:,ii)=refine3(cp(:,:,ii)',k,ndx(:,ii));
       %cnew(:,k,ii)=cnew(:,k,ii)-min(cnew(:,k,ii));
       %cnew(:,:,ii)=scal(ii)*cnew(:,:,ii)./(sum(cnew(:,:,ii)')'*ones(1,k));
    end;
    
    i = i + 1;
    if i > max_iter,
       break
    end;
    
    for ii=1:n_files
      xx=xx+sum(cnew(:,:,ii)-ctest(:,:,ii)).^2./sum(ctest(:,:,ii).^2);
   end;

end;
fprintf(1,'%g iterations.\n',i);
% get final estimates
yy=[];
for ii=1:n_files
     yy=[yy;cnew(:,:,ii)];
end;

b = uu'*yy;
uu=reshape(uu',k,n,n_files);
keyboard;
for ii=1:n_files,
   result(:,:,ii) = uu(:,:,ii)' * b;
end;

for ii=1:n_files,
   for jj=2:k,
      result(:,jj,ii)=result(:,jj,ii)-min(result(:,jj,ii));
   end;
   
   %result(:,:,ii)=scal(ii)*result(:,:,ii)./(sum(result(:,:,ii)')'*ones(1,k));

   %result(:,:,ii)=concscal(result(:,:,ii),max(sum(result(:,:,ii)')));
   %result(:,:,ii)=concscal(result(:,:,ii),scal(ii));

end;
keyboard;
yy=[];
for ii=1:n_files
     yy=[yy;result(:,:,ii)];
end;

epred = pinv(yy) * d;
keyboard;
hold off;
re=zeros(1,n_files);
for i=1:n_files,
   re(i)=sum(sum(((uv(i).dat-result(:,:,i)*epred)).^2./uv(i).dat.^2));
end;
