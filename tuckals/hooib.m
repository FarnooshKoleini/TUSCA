function [G, A, error1, Xr, iter] = hooib(X, R, A, opt)
%
% Higher-order orthogonal iteration (HOOI) to compute the Tucker
% decomposition of a 3D array with the given ranks
% Reference: "On the best rank-1 and rank-(R1, R2,...,RN ) approximation of
% higher-order tensors" (L. de Lathauwer, B. de Moor, J. Vandewalle)
%
% inputs:
%    X: tensor to decompose
%    R: vector of trimmed rank for each mode
%    e: error tolerance (1e-7 default)
%    maxiter: (50 default)
% outputs:
%    G: core matrix
%    A: cell matrix of eigenvectors
%    error1: residual variance at convergence
%    Xr: reproduced (model estimated) tensor
%    iter: num iterations

if nargin < 4
    opt.error = 1e-7; % hooib convergence tolerance
    opt.maxiter = 100; % hooib max iteration
    opt.als = 0; % Default is hooib (svd).  If als = 1, then tuckerals

elseif nargin < 3
    error('hooib - not enough input parameters.')
end

if isfield(opt, 'error') == 0
    opt.error = 1e-7;
end

if isfield(opt, 'maxiter') == 0
    opt.maxiter = 100;
end

if isfield(opt,'als') == 0
    opt.als = 0;
end

if nargin < 3
    error('hoiib: wrong number of input parameters.');
end

maxiter = opt.maxiter;
e = opt.error;
als = opt.als;
l = ndims(X);
iter=0;
error1= 1;
error2= 0;

S = cell(l,1);          % initial eigenvalues for each mode  stored here
G = X;                  % Will contain core matrix

%disp('HOOI Iter  error')

if als == 1     % This is the tuckals option for hooib
    r = size(X);
    a = uf_tensor(X);
    [A{1},A{2},A{3},g,S{1},S{2},S{3},tracea,Xr,ar,iter]=tuckals3b(a,1,R(1),R(2),R(3),r(3),A{1},A{2},A{3});
    error1 = sum(ar(:).^2);
    G = f_tensor(g,R(1),R(2),R(3));
    Xr = f_tensor(Xr,r(1),r(2),r(3));

else            % This is the SVD option for hooib

    while(iter<maxiter && abs(error1-error2)>e)
        iter=iter+1;
        G=X;        % init core matrix
        for i = 1:l
            o = setdiff(1:l,i);   % for tracking dimensionality of each mode
            Y = X;      % temp storage
            for n = o   % for tracking dimensionality of each mode
                [~, Y] = kproduct(Y,A{n}',n); % projection in to reduced space
            end
            Yu = unfold(Y,i);
            [U,s,~] = svd(Yu,"econ");  % update e'vecs of mode i
            A{i} = U(:,1:R(i)); % save trimmed result
            S{i} = diag(s(1:R(i))).^2;  % 12/12/2022 PJG: fixed bug to trim evals same as tuckals3
            [~, G] = kproduct(G, A{i}',i); % update core matrix
        end
        Xr=G;   % get copy of core matrix
        for j = 1:l
            [~, Xr] = kproduct(Xr,A{j},j);  % calc model estimated matrix
        end

        Xdiff = X-Xr;   % calc residuals

        error2=error1;
        %error1 = inproduct(Xdiff,Xdiff); % calc resid SSQ
        error1 = sum(Xdiff(:).^2); % easier way?

        if (error1<e)   % stop early if total SSQ is less than conv tol
            %        fprintf('\t%g\t%16.12e\n',[iter, error1]);
            break
        end

        %   if (mod(iter,10)==0)    % dispaly intermediate results
        %        fprintf('\t%g\t%16.12e\n',[iter, error1]);
        %   end
    end
    % disp('HOOI done.')

end