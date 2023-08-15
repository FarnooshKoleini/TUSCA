function threefig;
% Threefig -- creates three figure windows across the top of the screen
bdwidth = 4;
topbdwidth = 30;

% get size of screen
set(0,'Units','pixels') 
scnsize = get(0,'ScreenSize');

% calc size and postion of figures
pos1  = [2*bdwidth,... 
    2/3*scnsize(4) - 10*bdwidth,...
    scnsize(3)/3 - 3*bdwidth,...
    scnsize(4)/3 - (topbdwidth + bdwidth)];
pos2 = [pos1(1) + scnsize(3)/3,...
    pos1(2),...
    pos1(3),...
    pos1(4)];
pos3 = [pos2(1) + scnsize(3)/3,...
    pos1(2),...
    pos1(3),...
    pos1(4)];

if ishandle(1)
    set(1,'Position',pos1);
end;
if ishandle(2)
    set(2,'Position',pos2);
end;
if ishandle(3)
    set(3,'Position',pos3);
end;
