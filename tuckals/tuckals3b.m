function [g,h,e,c,evlg,evlh,evle,tracea,ar,r,i] = tuckals3b(as,scale_opt,s,t,u,K,g_ini,h_ini,e_ini)
% TUCKALS3B -- compute Tucker3 model of a 3-way array w/ initial estimates
%
% [g,h,e,c,evlg,evlh,evle,tracea,,ar,r]=tuckals3b(a,scale_opt,s,t,u,K); (no
% initial estimates)
%                            or
% [g,h,e,c,evlg,evlh,evle,tracea,ar,r]=tuckals3b(a,scale_opt,s,t,u,K,g_ini,h_ini,e_ini);
% (including initial estmates. E.g., when performing a bootstrap)
%
% Alternating least-squares solution to the reduced-rank tucker-3
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

% Check if the number of input arguments is correct
if nargin ~= 6 && nargin ~= 9
    error('Wrong number of arguments.');
end

[r,J]=size(as);
I=round(r/K);
if r ~= round(I*K)
    error(' Number of layers inconsistant with matrix dimension.');
end

% Perform scaling options
if scale_opt == 1       % No scaling
    a=as;
elseif scale_opt == 2	% global col centering
    a=meancorr(as);
elseif scale_opt == 3	% global row centering
    a=uf_col(as,I,J,K);
    a=meancorr(a')';
    a=f_col(a,I,J,K);
elseif scale_opt == 4	% center cols within layers
    for i=1:K
        a((i-1)*I+1:i*I,:)=meancorr(as((i-1)*I+1:i*I,:));
    end
elseif scale_opt == 5	% center rows within layers
    a=meancorr(as')';
elseif scale_opt == 6	% global scale
    a=autoscal(as);
elseif scale_opt == 7	% global row scaling
    a=uf_col(as,I,J,K);
    a=autoscal(a')';
    a=f_col(a,I,J,K);
elseif scale_opt == 8	% scale cols within layers
    for i=1:K
        a((i-1)*I+1:i*I,:)=autoscal(as((i-1)*I+1:i*I,:));
    end
elseif scale_opt == 9	% scale rows within layers
    a=autoscal(as')';
end

% compute the total variance
tracea=sum(sum(a.^2));

% Determine initial estimates if they were not specified beforehand, or
% assign the initial estimates to the matrices used during calcualtion.
if nargin == 6
    % unfold columns and compute common row space in g:
    x=uf_col(a,I,J,K);
    [~,y,g]=svd(x',0);
    g=g(:,1:s);
    evlg=y(1:s,1:s).^2;
    
    % get initial estimate of common column space in h:
    [~,y,h]=svd(a,0);
    h=h(:,1:t);
    evlh=y(1:t,1:t).^2;
    
    % unfold the layers and compute the common layer space in e:
    x=uf_layer(a,I,J,K);
    [~,y,e]=svd(x',0);
    e=e(:,1:u);
    evle=y(1:u,1:u).^2;
else
    % Use initial estimates for g if specified in the input
    g = g_ini;
    evlg = Inf;
    
    % Use initial estimates for h if specified in the input
    h = h_ini;
    evlh = Inf;
    
    % Use initial estimates for e if specified in the input
    e = e_ini;
    evle = Inf;
end

% now begin iterative refinement
% algorithm converges when ss(fit) in all modes is equal.
% we only need to test for equality in two modes.

i=0;

while (i<3) || abs(sum(diag(evlh))-sum(diag(evle)))/sum(diag(evlh)) > 2*sqrt(eps)
    
    % project data matrix into space spanned by h and e.
    % find common row space
    x=core(a,eye(I),h,e);
    x=uf_col(x,I,t,u)';
    x=x'*x;
    [v,evlg]=sort_eig(g'*x*x'*g);
    evlg=sqrt(evlg);
    g=x*g*v*diag(1 ./ diag(evlg));
    
    % project data matrix into space spanned by new g and old e
    % find common column space
    x=core(a,g,eye(J),e);
    x=x'*x;
    [v,evlh]=sort_eig(h'*x*x'*h);
    evlh=sqrt(evlh);
    h=x*h*v*diag(1 ./ diag(evlh));
    
    % project data matrix into space spanned by new g and new h
    % find new common layer space, e
    x=core(a,g,h,eye(K));
    x=uf_layer(x,s,t,K)';
    x=x'*x;
    [v,evle]=sort_eig(e'*x*x'*e);
    evle=sqrt(evle);
    e=x*e*v*diag(1 ./ diag(evle));
    
    % test for failure to converge
    i=i+1;
    if i > 100
        break;
    end
end

c=core(a,g,h,e); % Calculate the core matrix.
ar=real(core(c,g',h',e')); % Calculate the reconstructed data. Keep in mind that these are scaled according to the scaling options specified in the input.
r=(a-ar); % Calculate the residuals. Keep in mind that these are scaled according to the scaling options specified in the input.