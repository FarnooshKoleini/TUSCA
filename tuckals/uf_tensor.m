function x=uf_tensor(a)
% UF_TENSOR -- unfold a matlab 3-way array to tuckals 2d format
%
% x = uf_tensor(a);


sz = size(a);
if length(sz) ~=3 
	error('uf_tensor requires a three-way array.'); 
end

[I,J,K] = size(a);
x = zeros(I*K,J);

for k=1:K
    x((k-1)*I+1:k*I,:) = a(:,:,k);
end
