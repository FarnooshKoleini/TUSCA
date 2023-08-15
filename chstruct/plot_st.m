function plot_st(x,field1,field2,s);
%PLOT_ST -- Plot each data set in a structure of spectra
%
%   plot_st(x,field1,field2,s);
%
%       x: structured array of data.
%  field1: var or name of structure's x axis
%  field2: name of structure's field for plotting (default = dat)
%       s: optional string showing plot symbol, line style, color

if nargin < 4, s = '-'; end;
if nargin < 3, field2 = 'dat'; end;
if nargin < 2, field1 = 'dat'; end;
if ~ischar(s), error('PLOT_ST -- s must be a string.'); end;

m = length(x);
cmap = hsv(m);

for i=1:m
   if ischar(field1), 
      xx = getfield(x(i),field1);
   else
      xx = field1;
   end;
   yy = getfield(x(i),field2);
   
   if isfield(x,'name'), fprintf(1,'Processing %g: %s\n',i,x(i).name); end;
   
   if nargin == 2,
      h1 = plot(xx,'color',cmap(i,:));
      [y,ix] = max(max(yy));
      if isfield(x,'name'),
         text(ix,y,['  ', x(i).name],'color',cmap(i,:));
      end
   else
      h1 = plot(xx,yy,s,'color',cmap(i,:));
      [y,ix] = max(max(yy));
      if isfield(x,'name'),
         text(xx(ix),y,['  ', x(i).name],'color',cmap(i,:));
      end
   end;
   hold on;
end;
hold off;

