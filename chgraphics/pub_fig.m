function pub_fig(fname,lc,lw,fs,ln,ht,font,fw);
% PUB_FIG - sets plot characteristics for journals and books
%
% Interactive mode: pub_fig;
%
% non-interactive mode: 
% pub_fig(fname,linecolor,linewidth,font_size,length,height,font);
%
% variables omited from the argument list will be given the following
% default values.
%
% fname = 'unique name...', use 'none' for no saving.
% line color = no change
% linewidth = 1 point
% font_size = 12 points
% font = helvetica
% length = 5.75 inches
% height = 3.25 inches
% 
% non-interactive defauts:
% pub_fig('none','',1,12,5.75,3.25,'helvetica','bold');

ax=gca;

ax_find_all=allchild(gcf);
axes_type = get(ax_find_all,'type');
count1 = 1;
for ax_find_length = 1:1:length(ax_find_all);     %seperates out legends, annotation and menues
    if strcmpi('axes', axes_type(ax_find_length)) == 1,
        ax_find(count1) = ax_find_all(ax_find_length);
        count1 = count1 + 1;
    end
end


axes_tag = get(ax_find,'tag');
count2 = 1; count3 = 1;
ax_restack = 0;
for ax_find_length2 = 1:1:length(ax_find);     %seperates out legends, annotation and menues
    test_tag = get(ax_find(ax_find_length2),'tag');
    if strcmpi('',test_tag) == 1;
        set(ax_find(ax_find_length2), 'tag', 'temp');
    end
    if ~isempty(axes_tag) % 9/15/2010 PJG: Skip next if no legends
        if strcmpi('legend', axes_tag(ax_find_length2)) == 0,
            ax(count2) = ax_find(ax_find_length2);
            count2 = count2 + 1;
        else
            ax_restack(count3) = ax_find(ax_find_length2);
            count3 = count3 + 1;
        end
    end
end

for j = length(ax):-1:1;
axes(ax(j));
if j ~= 1,
    if nargin==0,  % interactive mode
        fs=input('Enter font size in points [12]: ');
        fw=input('Enter font weight [bold]: ');
        ln=input('Enter  length in inches [5.75]: ');
        ht=input('Enter box height in inches [3.25]: ');
        font=input('Enter font for labels [helvetica]:  ','s');
        lw=input('Enter default line width in points [1]: ');
        lc=input('Enter default line color [blank=no change]: ','s');
        sd=round(rand*1e9);
        default_fname=sprintf('fig_%1.0f',sd);
        fname=input(sprintf('Enter file name for saving figure [%s] or "none": ',default_fname),'s');
    end;
end;

if length(ax) == 1,
    if nargin==0,  % interactive mode
        fs=input('Enter font size in points [12]: ');
        fw=input('Enter font weight [bold]: ');
        ln=input('Enter box length in inches [5.75]: ');
        ht=input('Enter box height in inches [3.25]: ');
        font=input('Enter font for labels [helvetica]:  ','s');
        lw=input('Enter default line width in points [1]: ');
        lc=input('Enter default line color [blank=no change]: ','s');
        sd=round(rand*1e9);
        default_fname=sprintf('fig_%1.0f',sd);
        fname=input(sprintf('Enter file name for saving figure [%s] or "none": ',default_fname),'s');
    end;
end;

if nargin > 0,
  if nargin < 8, fw = 'bold'; end;
  if nargin < 7, font='helvetica'; end;
  if nargin < 6, ht=3.251; end;
  if nargin < 5, ln=5.751; end;
  if nargin < 4, fs=12; end;
  if nargin < 3, lw=1; end;
  if nargin < 2, lc='b'; end;
end;

if isempty(fs), fs = 12; end;
if isempty(ln), ln = 5.75; end;
if isempty(ht), ht = 3.25; end;
if isempty(font), font = 'helvetica'; end;
if isempty(fw), fw = 'bold'; end;
if isempty(lw), lw = 1; end;
if isempty(fname), fname = default_fname; end;

xl=get(ax(j),'xlabel');
yl=get(gca,'ylabel');
zl=get(gca,'zlabel');

set(ax(j),'fontname',font)
set(ax(j),'fontsize',fs)
set(ax(j),'fontweight',fw)
set(ax(j),'units','inches')
set(ax(j),'position',[.75,.5 ln,ht])
set(ax(j),'linewidth',lw);

h=allchild(ax(j));	% get all children, including hidden labels & titles
h=findobj(h,'Type','text'); 	% find all text objects
for i=1:length(h);
  set(h(i),'fontname',font)
  set(h(i),'fontsize',fs)
  set(h(i),'fontweight',fw)
end;

h=get(ax(j),'Children'); 	% find all line objects
for i=1:length(h);
  if strcmp(get(h(i),'type'),'line'),
    set(h(i),'linewidth',lw);
    if ~isempty(lc), set(h(i),'color',lc); end;
  end;
end;

if strcmp(fname,'none'), return; end;

disp(' ');

set(gcf,'paperpositionmode','auto');
set(gcf,'units','inches');
posit = get(gcf,'position');
posit(3) = ln + 1.25;  % set plot window width in inches
posit(4) = ht + 0.75;  % set plot window height in inches
set(gcf,'position',posit);

end;

% 
% for graph_restack = 1:1:length(ax_restack); %restack function for the legend
%     uistack(ax_restack(graph_restack),'top');
% end


% fprintf('Creating: %s.ai  (adbobe illustrator format).',fname);
% eval(sprintf('print -dill -painters %s',fname));
% 
disp(sprintf('Creating: %s.eps  (colr eps2 with tiff preview format).',fname));
eval(sprintf('print -deps2c -tiff %s',fname));

disp(sprintf('Creating: %s.png  (300 dpi png format).',fname));
eval(sprintf('print -dpng -r300 %s',fname));

disp(sprintf('Creating: %s.fig   (matlab fig format).',fname));
saveas(gcf, fname, 'fig');

