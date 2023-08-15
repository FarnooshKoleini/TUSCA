function [g,h,e,c,evlg,evlh,evle,tracea] = tuckals3nn(as,scale_opt,s,t,u,K,verbose);
% TUCKALS -- compute Tucker3 model of a 3-way array.
%
% [g,h,e,c,evlg,evlh,evle,tracea]=tuckals3nn(a); (interactive)
%     or
% [g,h,e,c,evlg,evlh,evle,tracea]=tuckals3nn(a,scale_opt,s,t,u,K,verbose);
%
% Non-negatively constrained 
% Alternating least-squares solution to the reduced-rank tuker-3
% model of a three-mode data array.  The data array, a(IxJxK), 
% has unfolded row storage format initially:
%
%       1...........I
%   |------------------|
% 1 |                  |
% . |      layer 1     |
% . |                  |
% J |                  |
%   |------------------|
%   |                  |
%  //                  // 
%   |                  |
%   |------------------|
%   |                  |
%   |     layer K      |
%   |                  |
%   |                  |
%   |------------------|
%
% g, h, and e are the eigenvectors of the row, column, and layer
% space of a.  The sxtxu core matrix is returned in c (unfolded row
% storage format.  Tracea is the total variance in the scaled data
% matrix.
%
% scale_opt (for variables, i.e. columns) 
% 1=None
% 2=Global center columns
% 3=Global center rows
% 4=Center columns within layers
% 5=Center rows within layers
% 6=Global center columns and standardize
% 7=Global center rows and standardize
% 8=Center and standardize columns within layers
% 9=Center and standardize rows withing layers
%
% s, t, and u specify the number of factors to be retained in modes
% I, J, and K respectively.
% verbose=1 (default) causes all sorts of results to be displayed.
if nargin ~= 1 & nargin ~= 6 & nargin ~= 7
   error('Wrong number of arguments.');
end;

if nargin == 6,
   verbose=1;
end;

if nargin == 1,
   verbose=input('Do you want the verbose mode [n=0/y=1]? ');
   K=input('How many layers does your data matrix have? ');
end;
[r,J]=size(as);
I=round(r/K);
if r ~= round(I*K),
   error(' Number of layers inconsistant with matrix dimension.');
end;

if nargin == 1,
   scale_opt=menu('Choose centering and scaling option','None','Global center columns','Global center rows','Center columns within layers','Center rows within layers','Global center columns and standardize','Global center rows and standardize','Center and standardize columns within layers','Center and standardize rows withing layesr');
end;

if scale_opt == 1,
   a=as;
elseif scale_opt == 2,    % global col centering
   a=meancorr(as);
elseif scale_opt == 3,	  % global row centering
   a=uf_col(as,I,J,K);
   a=meancorr(a')';
   a=f_col(a,I,J,K);
elseif scale_opt == 4,    % center cols within layers
   for i=1:K
     a((i-1)*I+1:i*I,:)=meancorr(as((i-1)*I+1:i*I,:));
   end;
elseif scale_opt == 5,    % center rows within layers
   a=meancorr(as')';
elseif scale_opt == 6,    % global scale
   a=autoscal(as);
elseif scale_opt == 7,	  % global row scaling
   a=uf_col(as,I,J,K);
   a=autoscal(a')';
   a=f_col(a,I,J,K);
elseif scale_opt == 8,    % scale cols within layers
   for i=1:K
     a((i-1)*I+1:i*I,:)=autoscal(as((i-1)*I+1:i*I,:));
   end;
elseif scale_opt == 9,    % scale rows within layers
   a=autoscal(as')';
end;


% compute the total variance
tracea=sum(sum(a.^2));

disp(' Please wait while I compute the initial svd''s');

% unfold columns and compute common row space in g:
   x=uf_col(a,I,J,K);
   [x,y,g]=svd(x',0);
   if nargin == 1,
      hold off
      plot(cumsum(100*diag(y).^2/tracea),'o')
      hold on;
      grid;
      plot(cumsum(100*diag(y).^2/tracea))
      title('I-mode variance preserved');
      ylabel('Percent variance preserved');
      xlabel('Factors');
      hold off;
      s=input('Enter number of factors to retain for I-mode: ');
   end;
   g=g(:,1:s);
   evlg=y(1:s,1:s).^2;
   disp(sprintf('%%Variance preserved in initial I-mode factors (sum=%g):',sum(diag(evlg)'/tracea*100)));
   disp(diag(evlg)'/tracea*100);

% get initial estimate of common column space in h:
   [x,y,h]=svd(a,0);
   if nargin == 1,
      plot(cumsum(100*diag(y).^2/tracea),'o')
      hold on;
      grid;
      plot(cumsum(100*diag(y).^2/tracea))
      title('J-mode variance preserved');
      ylabel('Percent variance preserved');
      xlabel('Factors');
      hold off;
      t=input('Enter number of factors to retain for J-mode: ');
   end;
   h=h(:,1:t);
   evlh=y(1:t,1:t).^2;
   disp(sprintf('%%Variance preserved in initial J-mode factors (sum=%g):',sum(diag(evlh)'/tracea*100)));
   disp(diag(evlh)'/tracea*100);

% unfold the layers and compute the common layer space in e:
   x=uf_layer(a,I,J,K);
   [x,y,e]=svd(x',0);
   if nargin == 1,
      plot(cumsum(100*diag(y).^2/tracea),'o')
      hold on;
      grid;
      plot(cumsum(100*diag(y).^2/tracea))
      title('K-mode variance preserved');
      ylabel('Percent variance preserved');
      xlabel('Factors');
      hold off;
      u=input('Enter number of factors to retain for K-mode: ');
   end;
   e=e(:,1:u);
   evle=y(1:u,1:u).^2;
   disp(sprintf('%%Variance preserved in initial K-mode factors (sum=%g):',sum(diag(evle)'/tracea*100)));
   disp(diag(evle)'/tracea*100);

% now begin iterative refinement
% algorithm converges when ss(fit) in all modes is equal.
% we only need to test for equality in two modes.

% check init solutions for all neg scores & flip them
g = flip_sign(g);
h = flip_sign(h);
e = flip_sign(e);

i=0;
disp('Iteration  Percent variance explained');

while (i<3) | abs(sum(diag(evlh))-sum(diag(evle)))/sum(diag(evlh)) > 2*sqrt(eps)

% project data matrix into space spanned by h and e.
% find common row space
   x=core(a,eye(I),h,e);
   x=uf_col(x,I,t,u)';
   x=x'*x;
   [v,evlg]=sort_eig(g'*x*x'*g);
   evlg=sqrt(evlg);
   g=x*g*v*diag(1 ./ diag(evlg));
   g=flip_sign(g);
%   g(g<0)=0;    %non neg constraint by truncation
%  disp(sprintf(' %%variance preserved in I-mode = %g',sum(diag(evlg))/tracea*100));

% project data matrix into space spanned by new g and old e
% find common column space
   x=core(a,g,eye(J),e);
   x=x'*x;
   [v,evlh]=sort_eig(h'*x*x'*h);
   evlh=sqrt(evlh);
   h=x*h*v*diag(1 ./ diag(evlh));
   h=flip_sign(h);
%   h(h<0)=0;    %non neg constraint by truncation
%  disp(sprintf(' %%variance preserved in J-mode = %g',sum(diag(evlh))/tracea*100));

% project data matrix into space spanned by new g and new h
% find new common layer space, e
   x=core(a,g,h,eye(K));
   x=uf_layer(x,s,t,K)';
   x=x'*x;
   [v,evle]=sort_eig(e'*x*x'*e);
   evle=sqrt(evle);
   e=x*e*v*diag(1 ./ diag(evle));
   e=flip_sign(e);
%   e(e<0)=0;    %non neg constraint by truncation
%  disp(sprintf(' %%variance preserved in K-mode = %g',sum(diag(evle))/tracea*100));

% test for failure to converge
   i=i+1;
   disp(sprintf('   %2g             %10.6f',i,sum(diag(evle))/tracea*100));
   if i > 30,
       opt=menu('Not converging','Do another iteration','Stop');
       if opt == 2,
          break;
       end
   end;
end;

c=core(a,g,h,e);

if verbose == 1,

% display core matrix

disp(' ');
disp('Core matrix:');
disp_f(c,s,t,u);

% display percent variance described by combinations of factors

disp('%Variance explained by IJK combinations of factors:');
disp_f(c.^2/tracea*100,s,t,u);

% display variance explained by individual factors

disp(sprintf('%%Variance preserved in I-mode factors (sum=%g):',sum(diag(evlg)'/tracea*100)));
disp(diag(evlg)'/tracea*100);
disp(sprintf('%%Variance preserved in J-mode factors (sum=%g):',sum(diag(evlh)'/tracea*100)));
disp(diag(evlh)'/tracea*100);
disp(sprintf('%%Variance preserved in K-mode factors (sum=%g):',sum(diag(evle)'/tracea*100)));
disp(diag(evle)'/tracea*100);

% do residual analysis

ar=core(c,g',h',e');
r=(a-ar).^2;
ar=ar.^2;

% do cases first
sstotal=sum(uf_col(a.^2,I,J,K)')';
gsstot=sstotal;
ssfit=sum(uf_col(ar,I,J,K)')';
ssresid=sum(uf_col(r,I,J,K)')';
disp('Residual analysis of cases.');
disp('      spl     ss(tot)   ss(fit)   %fit      ss(res)    %res')
disp([(1:I)',sstotal,ssfit,ssfit./sstotal*100,ssresid,ssresid./sstotal*100])

% do variables
sstotal=sum(a.^2)';
hsstot=sstotal;
ssfit=sum(ar)';
ssresid=sum(r)';
disp('Residual analysis of variables.');
disp('      var     ss(tot)   ss(fit)   %fit      ss(res)    %res')
disp([(1:J)',sstotal,ssfit,ssfit./sstotal*100,ssresid,ssresid./sstotal*100]);

% do conditions
sstotal=sum(uf_layer(a.^2,I,J,K)')';
esstot=sstotal;
ssfit=sum(uf_layer(ar,I,J,K)')';
ssresid=sum(uf_layer(r,I,J,K)')';
disp('Residual analysis of conditions.');
disp('     cond     ss(tot)   ss(fit)   %fit      ss(res)    %res')
disp([(1:K)',sstotal,ssfit,ssfit./sstotal*100,ssresid,ssresid./sstotal*100]);

% display loadings.

disp('I-mode loadings.');
disp([(1:I)' g]);

disp('J-mode loadings.');
disp([(1:J)' h]);
 
disp('K-mode loadings.');
disp([(1:K)' e]);

end;
