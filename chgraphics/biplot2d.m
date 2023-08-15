function h=biplot2d(scores,score_groups,group_nm,loads,load_nm,plot_ellipse)

% biplot2d -- 2d biplot (scores and loadings) by groups in g.
%
% biplot2d(scores,score_groups,group_nm,Loads,load_nm,plot_ellipse)
%
% names and group lables are optional, pass dummy '' if not wanted
%   score_groups:   integers identifying groups of scores (like a design mtx)
%   group_nm:       string or cell array of group names
%   load_nm:        string or cell array of loading labels
%   plot_ellipse:   vector of prob density levels for drawing ellipses on
%                   score clusters, example: [0.95] or [0.95 0.99]
% 
% short form:
% biplot2d(scores,'','',loads,'','')

[Nscores, Ndims] = size(scores);
Nloads = length(loads);
groups = unique(score_groups);         % get list of unique items in g
Ngroups = length(groups);

if Ndims ~= 2
    error('Scores and loadings must be 2 dimensional')
end

if isempty(score_groups)
    score_groups = ones(1,Nscores); % if groups not specified, default to 1
end

%if Ngroups > 8
    cmap = hsv(Ngroups);   % this color map has fewer repeats
%else
%    cmap = mycolors; % this color map only has 8 colors
%end

% Force each column of the coefficients to have a positive largest element.
% This tends to put the large var vectors in the top and right halves of
% the plot.

[~,maxind] = max(abs(loads),[],1);
colsign = sign(loads(maxind+[0 Nloads]));
scores = scores .* colsign;

% scale the scores for the biplot

maxCoefLen = sqrt(max(sum(loads.^2,2)));
scores = (maxCoefLen.*(scores ./ max(abs(scores(:))))).*colsign;

for i = 1:Ngroups
    ix = score_groups==i;    % find index of ith group in array
    plot(scores(ix,1),scores(ix,2),'o','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor',cmap(i,:));
%    plot(scores(ix,1),scores(ix,2),'o','MarkerEdgeColor',cmap(i,:));
    hold on;

% plot ellipse for cluster if requesteed by user
    if ~isempty(plot_ellipse)
        h_scores(i) = biplot(scores(ix,:),plot_ellipse,cmap(i,:));
    end
end

% section to plot the loadings
xy0 = zeros(Nloads,1);  % coordinates of line origins
plot([xy0'; loads(:,1)'],[xy0'; loads(:,2)'],'k','LineStyle',':');  % plot blue line
plot([xy0'; loads(:,1)'],[xy0'; loads(:,2)'],'ko','MarkerFaceColor','k'); % plot a symbol at the end of the line

% label the loadings if user provided them
if ~isempty(load_nm)  
% Take a stab at keeping the labels off the markers.
    delx = .01*diff(get(gca,'XLim'));
    dely = .01*diff(get(gca,'YLim'));

% label the loadings
    for i = 1:Nloads
        text(loads(i,1)+delx,loads(i,2)+dely,load_nm(i));  % draw label
    end
end

% add a legend for the groups
if ~isempty(group_nm)
    legend(h_scores,group_nm)
end
hold off;
axis_tight;  % from chgraphics toolbox




    
    