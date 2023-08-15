function [iy]=getpts(xx,yy);
% GETPTS -- interactive pgm to delete outliers, point by point.
% [iy]=getpts(x,y);
% iy = companion matrix of ones & zeros showing points retained/deleted.
% hint: y.*iy sets deleted pts to zero
% hint: sum(iy) and sum(iy') gives no. pts retained in columns or rows.

if length(xx) ~= size(yy,2),	% transpose yy if needed.
  y = yy';
else
  y = yy;
end;
if size(xx,2) ~= size(yy,2),
  x = xx;
else
  x = xx';
end;
[r,c]=size(y);
[iy]=ones(r,c);

% set up plot
disp('Click mouse to select or de-select outliers.');
disp('Hit <return> to stop.');

hold off; plot(x,y,'y'); hold on; plot(x,y,'co'); hold off;
ax = gca;                                % get handle to current plot
set(gcf,'pointer','crosshair');

window_done = waitforbuttonpress;
while window_done ~= 1,
  pt = get(ax,'CurrentPoint');           % get x,y location of mouse click
  [ignore,ic]=min(abs(x-pt(1,1)));       % find closest x
  [ignore,ir]=min(abs(y(:,ic)-pt(1,2))); % find closest y
  if iy(ir,ic) == 1,                     % test if pt already selected
    iy(ir,ic) = 0;
  else
    iy(ir,ic) = 1;
  end;
  [ir,ic]=find(iy==0);
  plot(x,y,'y'); hold on; plot(x,y,'co'); plot(x(ic),y(find(iy==0)),'ro'); hold off;
  window_done = waitforbuttonpress;
end;  % while window_done
set(gcf,'pointer','arrow');

