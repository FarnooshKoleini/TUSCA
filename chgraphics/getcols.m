function [xsub,ix]=getcols(wvln,x);
% GETCOLS -- interactive pgm to delete outliers by column
%
% [xsub,ix]=getcols(wvln,x);
% wvln used for plotting.  Length of wv must be same as no. cols in x.
% ix = indices of cols retained, e.g., xsub = x(:,ix)

[r,c]=size(x);
if length(wvln) ~= c,
  error('getcols -- no. cols in x does not match length of wvln, try x''?');
end;
if size(wvln,2) ~= c,
  wv = wvln;
else
  wv = wvln';
end;
[ix]=ones(c,1);
[u,s,v]=svd(meancorr(x));
u=u(:,1:3);
v=v(:,1:3);
s=s(1:3,1:3);

% set up plot
sub_ax=zeros(1,4);
subplot(2,2,1); plot(x,'y'); sub_ax(1)=gca; hold on;
subplot(2,2,2); plot(wv,v(:,1)); sub_ax(2)=gca; hold on; plot(wv,v(:,1),'o');
subplot(2,2,3); plot(wv,v(:,2)); sub_ax(3)=gca; hold on; plot(wv,v(:,2),'o');
subplot(2,2,4); plot(wv,v(:,3)); sub_ax(4)=gca; hold on; plot(wv,v(:,3),'o');

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
        col = find(0==(sum((x-y(ones(c,1),:)'))));
      end;
    else    % if win > 1 	  
      % find closest pc score
      dx = [wv-pt(1,1), v(:,win-1)-pt(1,2)]';
      [ignore,col] = min(sum(dx.^2));
    end;    % if win == 1 

	w1_obj = findobj(sub_ax(1),'ydata',x(:,col)'); % pointer to spectrum in window 1
    if ix(col) == 1,  % de-select row
      ix(col) = 0;
	  set(w1_obj,'color','r');	% change spectrum color
    else				% or re-select row
      ix(col) = 1;
	  set(w1_obj,'color','y');	% change spectrum color
	  subplot(2,2,2); plot(wv,v(:,1),'yo');
	  subplot(2,2,3); plot(wv,v(:,2),'yo');
	  subplot(2,2,4); plot(wv,v(:,3),'yo');
	end;
    cols = find(ix==0);
	  subplot(2,2,2); plot(wv(cols),v(cols,1),'ro');
	  subplot(2,2,3); plot(wv(cols),v(cols,2),'ro');
	  subplot(2,2,4); plot(wv(cols),v(cols,3),'ro');
  end;
  window_done = waitforbuttonpress;
end;  % while window_done
set(gcf,'pointer','arrow');

ix=find(ix==1);
xsub = x(:,ix);
set(gcf,'nextplot','replace');
for i=1:4
  set(sub_ax,'nextplot','replace');
end;
