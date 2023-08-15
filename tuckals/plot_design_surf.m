function h =  plot_design_surf(y, yd, factor_label, level_label)
% PLOT_DESIGN_SURF - plot rows of y color-coded by design matrix yd
%
%[h] =  plot_design_surf(y, yd, factor_label, level_label);
%
% inputs
%   y:   data to plot (r x c) 
%   yd:  design matrix (r x 2; factors in col 1, levels in col 2)
%        use integers to show factors and levels
%
% optional inputs (cell arrays)
%   factor_label
%   level_label 
%
% output
%   h:   vector of handles to surface plots

[drows,n]=size(yd);  % number of factors = n columns
[r,c]=size(y);          % size of data matrix
rr = 1:r;               % index for surface plot
cc = 1:c;               % index for surface plot

if r ~= drows
    error('plot_design_surf: data and design matrices must have same number of rows.')
elseif n ~= 2
    error('plot_design_surf: design matrix must have 2 columns.')
end

nfac = length(unique(yd(:,1)));
nlevels = length(unique(yd(:,2)));

% n_total = nfac * nlevels; % total num plots, one for each combination of levels
% h = zeros(1,n_total);    % array of handles for plots

c = hsv(nfac * nlevels);   % create color map

n = 1;
for i = 1:nfac
    for j = 1:nlevels
        idx = find(yd(:,1)==i & yd(:,2)==j); % get index to each combination of factor levels
        if ~isempty(idx)
            
            h(n) = mesh(y(idx,:),'YData',rr(idx));  % make the surface
            hold on;

            set(h(n),'EdgeAlpha',0.2);
            set(h(n),'FaceAlpha',0.1);  
            set(h(n),'MeshStyle','row')
            set(h(n),'FaceColor',c(n,:));

            if nargin == 4
                L{n} = sprintf('%s, %s',factor_label{i},level_label{j}); % Legend 
            else
% format the legend strings
                L{n} = sprintf('Factor %g, level %g',i,j); % Legend 
            end            
            n = n + 1;
        end
    end
end
hold off;
legend(L);
