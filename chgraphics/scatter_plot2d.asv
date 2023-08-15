function h=scatter_plot2d(x,y,g)
% scatter_plot2d -- 2d scatter plot by groups in g

% scatter_plot2d(x,y,g);  % up to 7 groups
%

groups = unique(g);         % get list of unique items in g
Ngroups = length(groups);
if Ngroups > 7
    error('More than 7 groups');
end;

h = figure;     % create a new figures
cmap = mycolors;       % group colors are unique for up to 8

for i = 1:Ngroups
    ix = find(g==i);    % find index of ith group in array
    plot(x(ix),y(ix),'o','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor',cmap(i,:));
    hold on;
end;
hold off;

end
       

    
    