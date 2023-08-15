function deriv_biplot(a,id);
% DERIV_BIPLOT -- plots two-dimensional derivatives
%
% deriv_bilpot(a,idx);
% 
% a:  absorbance spectra in rows
% idx: subrange of a for plotting

[r,c]=size(a);

if nargin < 2,
	id = 1:c
end;

x = a(:,id);
[r,c]=size(x);
dx = deriv(x',1)';
ddx = deriv(dx',1)';

figure(1); 
colorlin(round(c*1.1));
plot(x',dx');
hold on;
colorlin(round(r*1.1)); 
plot(x,dx);
hold off;
title('abs. vs. 1st deriv');

figure(2); 
colorlin(round(c*1.1));
plot(dx',ddx');
hold on;
colorlin(round(r*1.1)); 
plot(dx,ddx);
hold off;
title('1st deriv vs. 2nd deriv');

