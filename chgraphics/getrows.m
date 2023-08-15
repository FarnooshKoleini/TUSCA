function [xsub,ix]=getrows(wv,x);
% GETROWS -- interactive pgm to delete outliers by row
%
% [xsub,ix]=getrows(wv,x);
% wv used for plotting.  Length of wv must be same as no. cols in x.
% ix = indices of rows retained, e.g., xsub = x(ix,:)

[r,c]=size(x);
if length(wv) ~= c,
  error('GETROWS -- no. cols in x does not match length of wv, try x''?');
end;
[ix]=ones(r,1);
[u,s,v]=svd(meancorr(x));
u=u(:,1:4);

% set up plot
sub_ax=zeros(1,4);
subplot(2,2,1); plot(wv,x','y'); sub_ax(1)=gca; hold on;
subplot(2,2,2); lab_plot(u(:,1),u(:,2)); sub_ax(2)=gca; hold on;
subplot(2,2,3); lab_plot(u(:,2),u(:,3)); sub_ax(3)=gca; hold on;
subplot(2,2,4); lab_plot(u(:,3),u(:,4)); sub_ax(4)=gca; hold on;
set(gcf,'renderer','zbuffer')

disp('Click mouse to select or de-select outliers.');
disp('Hit <return> to stop.');

set(gcf,'pointer','crosshair');
window_done = waitforbuttonpress;
while window_done ~= 1,
  win = find(get(get(gcf,'currentobjec'),'parent')==sub_ax);    % find out which window
  if length(win) ~=0, 
    pt = get(sub_ax(win),'CurrentPoint');  % get the pt inside the window
    if win == 1,
      % test to see if object selected is a data series in window 1
	  if sub_ax(win) == get(gco,'parent'),
  	    y = get(gco,'ydata');
        row = find(0==(sum((x-y(ones(r,1),:))')));
      end;
    else    % if win > 1 	  
      % find closest pc scores
      dx = [u(:,win-1)-pt(1,1), u(:,win)-pt(1,2)]';
      [ignore,row] = min(sum(dx.^2));
    end;    % if win == 1 

	w1_obj = findobj(sub_ax(1),'ydata',x(row,:)); % pointer to spectrum in window 1
 
    if ix(row) == 1,  % de-select row
      ix(row) = 0;
	  set(w1_obj,'color','r');	% change spectrum color
    else				% or re-select row
      ix(row) = 1;
	  set(w1_obj,'color','y');	% change spectrum color
	  subplot(2,2,2); plot(u(row,1),u(row,2),'yo');
	  subplot(2,2,3); plot(u(row,2),u(row,3),'yo');
	  subplot(2,2,4); plot(u(row,3),u(row,4),'yo');
	end;
    rows = find(ix==0);
	subplot(2,2,2); plot(u(rows,1),u(rows,2),'ro');
	subplot(2,2,3); plot(u(rows,2),u(rows,3),'ro');
	subplot(2,2,4); plot(u(rows,3),u(rows,4),'ro');
  end;
  window_done = waitforbuttonpress;
end;  % while window_done
set(gcf,'pointer','arrow');

ix=find(ix==1);
xsub = x(ix,:);
set(gcf,'nextplot','replace');
for i=1:4
  set(sub_ax,'nextplot','replace');
end;
