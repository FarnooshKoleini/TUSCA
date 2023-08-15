function lab_plot(x,y,s);
% LAB_PLOT -- plot x,y scatter plot using symbol 's' w/ numerical point labels
%
% lab_plot(x,y,s) numbers the points in a scatter plot consecutively.
% The variables x and y specify the location of the points in the plot.
% s ='o' is the default plotting string
% 
% lab_plot(u(:,1),u(:,2),'o');

if nargin < 3, s='o'; end;

plot(x,y,s);

r=length(x);
for i=1:r
   text(x(i),y(i),sprintf('  %g',i));
end
