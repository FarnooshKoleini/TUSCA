function [G, S, error1, Xdiff, Xr, iter] = hooi_test(X, R, A, init_method, e, maxiter)
%
% Higher-order orthogonal iteration (HOOI) to compute the Tucker
% decomposition of a 3D array with the given ranks
% Reference: "On the best rank-1 and rank-(R1, R2,...,RN ) approximation of
% higher-order tensors" (L. de Lathauwer, B. de Moor, J. Vandewalle)
%
% inputs:
%    X: tensor to decompose
%    R: vector of trimmed rank for each mode
%    init_method: 'random' or 'hosvd' (default)
%    e: error tolerance (1e-7 default)
%    maxiter: (50 default)
% outputs:
%    G: core matrix
%    A: cell matrix of eigenvectors
%    error1: residual variance at convergence
%    Xr: reproduced (model estimated) tensor
%    iter: num iterations

if nargin < 5
    maxiter = 50;
end
if nargin < 4
    e = 1e-7;
end
if nargin < 3
    init_method = 'hosvd';
end

l = ndims(X);
iter=0;
error1= 1;
error2= 0;
S = cell(l,1);          % initial eigenvalues for each mode  stored here
G = X;                  % Will contain core matrix


if ~strcmp(init_method,'none')
    A = cell(l,1);      % eigenvectors for each mode will be stored here
if strcmp(init_method,'hosvd')
    [~,A,~] = hosvd(X,R);
    iter = 1;           % we will count init with HOSVD as one iteration
elseif strcomp(init_method,'random')
    for i = 1:l
        A{i} = randn(size(X,i),R(i));
    end
end

%disp('HOOI Iter  error')

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

    error2=resid_err;
    % error1 = inproduct(Xdiff,Xdiff); % calc resid SSQ
    resid_err = sum(Xdiff(:).^2); % easier way?

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