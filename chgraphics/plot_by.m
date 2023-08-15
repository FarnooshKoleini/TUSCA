function by_order=plot_by(a,x,y,by_col);
% PLOT_BY -- plot columns x vs y in a sorted by_cols.
%
% by_order=plot_by(a,x,y,by_col);

by_order=a(1,by_col);
iy=find(a(:,by_col)==a(1,by_col));
px=a(iy,x); py=a(iy,y);
a(iy,:)=[];
[r,c]=size(a);

while r > 0,
  by_order=[by_order a(1,by_col)];
  iy=find(a(:,by_col)==a(1,by_col));
  px=[px a(iy,x)]; py=[py a(iy,y)];
  a(iy,:)=[];
  [r,c]=size(a);
end;

plot(px,py);
