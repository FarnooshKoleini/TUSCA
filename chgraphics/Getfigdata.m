function varargout = Getfigdata;
% Getfigdata -- return all of the line data in a figure
%
%[x,y] = getfigdata;
%  or
%[x1,y1,x2,y2,...] = getfigdata;  % use mult outputs for traces w/ diff lengths

h = findall(gcf,'Type','line');
n = length(h);

if n == 0,
   error('GetFigData -- current figure has no line data to export')
end;

for i = 1:n
   d(i).x = get(h(i),'Xdata');
   d(i).y = get(h(i),'Ydata');
end;

x = d(1).x;
y = d(1).y;
k = 1;
j = 1;
i = 2;
while (i <= n) 
   if (length(x) == length(d(i).x)) & all(x == d(i).x),
      k = k + 1;
      y(k,:) = d(i).y;
   else
      varargout(j) = {x};
      varargout(j+1) = {y};
      x = d(i).x;
      y = d(i).y;
      j = j + 2;
      k = 1;
   end;
   i = i + 1;
end;
y = y(end:-1:1,:);
varargout(j) = {x};
varargout(j+1) = {y};
j = j + 1;
fprintf(1,'Exported %g line variables in %g (x,y) pairs',j,j/2);