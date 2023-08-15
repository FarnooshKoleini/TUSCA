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

if nargin==0,  % interactive mode
  fs=input('Enter font size in points [12]: ');
  fw=input('Enter font weight [bold]: ');
  ln=input('Enter box length in inches [5.75]: ');
  ht=input('Enter box height in inches [3.25]: ');
  font=input('Enter font for labels [helvetica]:  ','s');
  lw=input('Enter default line width in points [1]: ');
  lc=input('Enter default line color [blank=no change]: ','s');
  rand; sd=rand('seed');
  default_fname=sprintf('fig_%1.0f',sd);
  fname=input(sprintf('Enter file name for saving figure [%s] or "none": ',default_fname),'s');
end;

if nargin > 0,
  if nargin < 8, fw = 'bold'; end;
  if nargin < 7, font='helvetica'; end;
  if nargin < 6, ht=3.251; end;
  if nargin < 5, ln=5.751; end;
  if nargin < 4, fs=12; end;
  if nargin < 3, lw=1; end;
  if nargin < 2, lc='w'; end;
end;

if length(fs)==0, fs = 12; end;
if length(ln)==0, ln = 5.75; end;
if length(ht)==0, ht = 3.25; end;
if length(font)==0, font = 'helvetica'; end;
if length(fw)==0, fw = 'bold'; end;
if length(lw)==0, lw = 1; end;
if length(fname)==0, fname = default_fname; end;

xl=get(ax,'xlabel');
yl=get(gca,'ylabel');
zl=get(gca,'zlabel');

set(ax,'fontname',font)
set(ax,'fontsize',fs)
set(ax,'fontweight',fw)
set(ax,'units','inches')
set(ax,'position',[.75,.5 ln,ht])
set(ax,'linewidth',lw);

h=allchild(ax);	% get all children, including hidden labels & titles
h=findobj(h,'Type','text'); 	% find all text objects
for i=1:length(h);
  set(h(i),'fontname',font)
  set(h(i),'fontsize',fs)
  set(h(i),'fontweight',fw)
end;

h=get(ax,'Children'); 	% find all line objects
for i=1:length(h);
  if strcmp(get(h(i),'type'),'line'),
    set(h(i),'linewidth',lw);
    if length(lc)~=0, set(h(i),'color',lc); end;
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

disp(sprintf('Creating: %s.ai  (adbobe illustrator format).',fname));
eval(sprintf('print -dill -painters %s',fname));

disp(sprintf('Creating: %s.eps  (colr eps2 with tiff preview format).',fname));
eval(sprintf('print -deps2c -tiff %s',fname));

disp(sprintf('Creating: %s.png  (300 dpi png format).',fname));
eval(sprintf('print -dpng -r300 %s',fname));

disp(sprintf('Creating: %s.fig   (matlab fig format).',fname));
saveas(gcf, fname, 'fig');

