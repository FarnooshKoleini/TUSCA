function plot_bs_loadings(AA_bs, AA_opt, conf_level, t, save_flag)

if nargin < 4, save_flag = 0; end
if nargin < 3, t=[]; end
if nargin < 2, conf_level = 90; end

l = size(AA_bs,1);      % number of modes
nb = size(AA_bs,2);     % number of bootstrap samples

for m=1:l   % loop over all modes
    [r, c] = size(AA_bs{m,1});    % r = rows in this loading
    if size(t)>0        % get list of columns from table
        for vec = [table2array(unique(t(:,m)))'] % c = number of vectors in this mode
            title_str = sprintf('mode %g, loading %g',m,vec);

            a=zeros(r,nb);
            for k=1:nb              % collect loadings from cell array into matrix
                a(:,k) = AA_bs{m,k}(:,vec);
            end

            boot_ci_loading(a, AA_opt{m}(:,vec),conf_level,title_str,save_flag);
        end
    else
        for vec = 1:c                   % c = number of vectors in this mode
            title_str = sprintf('mode %g, loading %g',m,vec);
            a=zeros(r(1),nb);

            for k=1:nb              % collect loadings from cell array into matrix
                a(:,k) = AA_bs{m,k}(:,vec);
            end

            boot_ci_loading(a, AA_opt{m}(:,vec),conf_level,title_str,save_flag);

        end
    end
end
