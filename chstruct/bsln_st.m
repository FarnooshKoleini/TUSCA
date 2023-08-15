function [y] = bsln_st(x,mtd);
%BSLN_ST -- Do baseline correction on structure x.
%
%[y] = bsln_st(x,mtd);
%
% mtd:  1 = set min offset to zero (default method)
%       2 = set avg offset in range to zero
%       3 = set polynomial offset
%

if nargin < 2, mtd = 1; end;
k=length(x);
y = x;

fprintf(1,'Processing %g: %s\n',i,x(1).name);
[n,m]=size(x(1).dat);
if mtd==1,
   mn = min(y(1).dat')';
   y(1).dat = y(1).dat - mn(:,ones(m,1));
elseif mtd==2,
   [y(1).dat,b,idx] = baslncor(x(1).dat,x(1).wv);
elseif mtd==3,
   np = input('Enter polynomial order: ');
	[y(1).dat,idx] = bsln_poly(x(1).dat,x(1).wv,np);
end

for i=2:k
   [n,m]=size(x(i).dat);
   fprintf(1,'Processing %g: %s\n',i,x(i).name);
   if mtd==1,
      mn = min(y(i).dat')';
      y(i).dat = y(i).dat - mn(:,ones(m,1));
   elseif mtd==2,
      [y(i).dat,b] = bascor(x(i).dat,idx(1),idx(end));
   elseif mtd==3,
      [y(i).dat] = base_poly(x(i).dat,idx,np);
   end
end;

