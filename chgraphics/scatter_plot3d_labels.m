function h=scatter_plot3d_labels(x,y,z,g)
% scatter_plot3d_labels -- 3d scatter plot by groups in g, labeled by number

% scatter_plot3d_labels(x,y,z,g);  % up to 7 groups

% Author:
% Farnoosh Koleini
% East Carolina University / Department of chemistry
% email: farnoosh.kl1997@gmail.com
% January 26, 2021
 
groups = unique(g);         % get list of unique items in g
Ngroups = length(groups);
if Ngroups > 8
    error('More than 8 groups');
end;
 
h = figure;             % create a new figures
cmap = mycolors;        % group colors are unique for up to 8
r = length(x);        % create integers for labeling
 
for i = 1:Ngroups
    ix = find(g==i);    % find index of ith group in array
    scatter3(x(ix),y(ix), z(ix),'o','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor',cmap(i,:));
    hold on;
end;

for i=1:r
    text(x(i),y(i),z(i),sprintf('  %g',i));
end

hold off;
 
end