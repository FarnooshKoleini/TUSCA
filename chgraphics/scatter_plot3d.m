function h=scatter_plot3d(x,y,z,g)
% scatter_plot3d -- 3d scatter plot by groups in g

% scatter_plot3d(x,y,z,g);  % up to 7 groups

% Author:
% Farnoosh Koleini
% East Carolina University / Department of chemistry
% email: farnoosh.kl1997@gmail.com
% January 26, 2021
 
groups = unique(g);         % get list of unique items in g
Ngroups = length(groups);
if Ngroups > 7
    error('More than 7 groups');
end;
 
h = figure;     % create a new figures
cmap = mycolors;       % group colors are unique for up to 8
 
for i = 1:Ngroups
    ix = find(g==i);    % find index of ith group in array
    scatter3(x(ix),y(ix), z(ix),'o','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor',cmap(i,:));
    hold on;
end;
hold off;
 
end