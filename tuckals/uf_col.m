function [b]=uf_col(a,I,J,K);
% UF_COL -- unfold the layers in the 3-mode array.
%
% [b]=uf_col(a,I,J,K);
%
% subroutine for unfolding the columns in the 3-mode
% array, a.  The initial storage mode for a should be
% unfolded rows.  I=rows, J=cols, K=layers.

b=zeros(I,J*K);
for k = 1:K
   b(:,(k-1)*J+1:k*J) = a((k-1)*I+1:k*I,:);
end;
