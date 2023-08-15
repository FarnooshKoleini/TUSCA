function setlines
% SETLINES -- Dialog to set line styles
%
% one day this should be fixed to use menus like 'matmenus'

lines=get(gca,'Children');	% get handles to lines from current axis

lines = sort(lines);		% sort in proper order

ln=input('Set line styles.  Enter line number [return to exit]: ');
while length(ln) ~=0
	ls=input('Enter line style [-]: ','s');
	if length(ls)==0, ls='-'; end;
	set(lines(ln),'linestyle',ls);
	ln=input('Set line styles.  Enter line number [return to exit]: ');
end;

ln=input('Set line colors.  Enter line number [return to exit]: ');
while length(ln) ~=0
	ls=input('Enter line color [white]: ','s');
	if length(ls)==0, ls='white'; end;
	set(lines(ln),'color',ls);
	ln=input('Set line colors.  Enter line number [return to exit]: ');
end;

ln=input('Set line widths.  Enter line number [return to exit]: ');
while length(ln) ~=0
	lw=input('Enter line width [0.50]: ');
	if length(lw)==0, lw=0.5; end;
	set(lines(ln),'linewidth',lw);
	ln=input('Set line widths.  Enter line number [return to exit]: ');
end;

