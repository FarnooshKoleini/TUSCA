function plot_core_histograms(y,cilevel,nbins,save_flag,rng)
% PLOT_CORE_HISTOGRAMS - PLots core matrix histograms from TUSCA output
%
% [xm, xl, xu] = boot_ci(G_bs, cilevels, nbins, plot_flag, rng);
%
% Inputs
%       G_bs: cell array of core matrix boostrap iterations
%    cilevel: confidence interval (default = 95)
%      nbins: default = 100
%  save_flag: 0/1 save as .fig files (default = 0)
%
%        rng: table(i,j,k)  
%               OR 
%             n:m (an ordered list)
%               OR
%             r.i, r.j, r.k (a structure listing the modes to plot)
%

n_dim =  ndims(y);
R = size(y{1});
n_elem = prod(R);

if nargin < 5
    ri = 1:R(1); rj = 1:R(2); rk = 1:R(3);
    lin_range = 1:n_elem;
    rng = 1:n_elem;
end

if nargin < 4, save_flag = 0; end
if nargin < 3, nbins = 100; end
if nargin < 2, cilevel = 95; end

if istable(rng)
    t = table2array(rng);
    for n = 1:size(rng,1)
        i = t(n,1); j = t(n,2); k = t(n,3);
        x=cellfun(@(x) x(i,j,k), y); % this is an implied loop
        figure;
        boot_ci(x,cilevel,nbins,1); % custom function to plot hist
        title (sprintf('Histogram of core element %g, %g, %g',i,j,k));
        ylabel('frequency');
        xlabel('core value');
        if save_flag > 0
            fname = sprintf('hist_core_%g_%g_%g',i,j,k);
            savefig(gcf, fname,'compact');
            if save_flag > 1
                pause(save_flag);
            end % if save_flat
        end
    end
    return

elseif isstruct(rng)
    lin_range = 1:n_elem;
    if isfield(rng,'i'), ri = rng.i; else ri = 1:R(1); end
    if isfield(rng,'j'), rj = rng.j; else rj = 1:R(2); end
    if isfield(rng,'k'), rk = rng.k; else rk = 1:R(3); end
else
    lin_range = rng;
    ri = 1:R(1); rj = 1:R(2); rk = 1:R(3);
end

n = 1;

for i = ri
    for j = rj
        for k = rk
            if any(n==lin_range)
                % extract one element from a cell array of multi-dim array
                x=cellfun(@(x) x(i,j,k), y); % this is an implied loop
                figure;
                boot_ci(x,cilevel,nbins,1); % custom function to plot hist
                title (sprintf('Histogram of core element %g, %g, %g',i,j,k));
                ylabel('frequency');
                xlabel('core value');
                if save_flag > 0
                    fname = sprintf('hist_core_%g_%g_%g',i,j,k);
                    savefig(gcf, fname,'compact');
                    if save_flag > 1
                        pause(save_flag);
                    end % if save_flat
                end
            end % for k
            n = n + 1;
        end % for j
    end % for i
end