function [h,xm,xl,xu,pr] = boot_ci(x,cilevel,nbins,plot_flag)
% BOOT_CI - Find the upper and lower confidence interval from bootstrap
%
% [xm, xl, xu] = boot_ci(x, nboot, cilevels, nbins, plot_flag);
% 
% Inputs
%          x: vector of bootstrap values
%    cilevel: confidence interval (default = 95)
%      nbins: default = 100
%  plot_flag: 0/1 

% Farnoosh Koleini, Chemistry department, East Carolina University
% email: koleinif20@students.ecu.edu

%h = histogram(x,nbins);  

if nargin < 4, plot_flag = 1; end
if nargin < 3, nbins = 100; end
if nargin < 2, cilevel = 95; end

nboot = length(x);
xm=median(x);    
xs=sort(x);
a=round((nboot*(50-(cilevel/2)))/100);
b=nboot-a;

%a = round(nboot*(100-cilevel)/100);
%b = nboot - a;

xl = xs(a);
xu = xs(b); 

% calc auto bin counts and edges w matlab function histcounts
% length of N is 100, length of edge is 101 <- beware of fence-post
% counting errors

[N,edge]=histcounts(xs,nbins);    % bin edges and counts

ixu = find(edge > xu);  % index of edges, upper tail 
ixub = ixu(1:end-1);    % index of upper bins

ixl = find(edge < xl);  % index of edges, lower tail    
ixlb = ixl(1:end-1);    % index of lower bins

ixm = find(edge>=xl & edge <= xu);   % index of edges, mid-section
ixme = [ixm(1)-1,ixm,ixm(end)+1];   % correct edges for edge overlap
ixmb = [ixm(1)-1,ixm];    % correct bins for edge overlap

if plot_flag == 1
    % plot the mid-section of the histogram
    h(1) = histogram('BinEdges', edge(ixme), 'BinCounts', N(ixmb), 'FaceColor','green'); 
    hold on;
    
    % plot the lower tail
    h(2) = histogram('BinEdges', edge(ixl), 'BinCounts', N(ixlb),'FaceColor','red');
    
    % plot the upper tail
    h(3) = histogram('BinEdges', edge(ixu), 'BinCounts', N(ixub),'FaceColor','red');
    
    ax = axis;
    line([xm,xm],[ax(3) ax(4)],'Color','k','linewidth',2)
    
    %done
    hold off
end

% 09/28/2022 code to calc p-values for null hypothesis x = 0
if xm < 0, x  = -x; end  % flip sign if the value being tested is negative for two-tailed test
pr = sum(x<0)/length(x);  % that's all!

