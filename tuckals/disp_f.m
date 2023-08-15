function disp_f(a,I,J,K);
% DISP_F -- to display a matrix in folded row storage format
%
% disp_f(a,I,J,K);
for k=1:K
  disp(sprintf('layer %g',k));
  disp(a((k-1)*I+1:k*I,:));
end;
