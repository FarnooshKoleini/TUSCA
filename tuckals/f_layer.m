function [c]=f_layer(a,I,J,K);
% F_LAYER -- fold layers in the 3-mode array, a.  
% This function complements the unfold_layers function
% I=rows, J=cols, K=layers.
%
% [c]=f_layer(a,I,J,K);

c=zeros(I*K,J);
b=f_col(a,K,J,I);
for k=1:K
  c((k-1)*I+1:k*I,:)=b(k:K:I*K,:);
end;
