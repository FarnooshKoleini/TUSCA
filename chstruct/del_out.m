function [new_struct]=del_out(uv);
% DEL_OUT -- interactive pgm to delete outliers by row in uv data struct
%
% [new_struct]=del_out2(uv);
%   uv.name: orginal file name
%   uv.t:    acq times, nx1
%   uv.wv:   acq wvlns, 1xm
%   uv.dat:  spectra, nxm
%
% The prgm repeats the graphical plots and prompts for outliers, once for
% each set of batch data in the structure.

mm=length(uv);
new_struct = uv;

for i=1:mm
  [r,c]=size(uv(i).dat);
  [ix]=ones(r,1);
  [u,s,v]=svd(meancorr(uv(i).dat));
  u=u(:,1:4);

% set up plot
sub_ax=zeros(1,4);
subplot(2,2,1); plot(uv(i).wv,uv(i).dat,'b'); sub_ax(1)=gca; hold on;
subplot(2,2,2); plot(uv(i).t,u(:,1),'o'); sub_ax(2)=gca; hold on;
subplot(2,2,3); plot(uv(i).t,u(:,2),'o'); sub_ax(3)=gca; hold on;
subplot(2,2,4); plot(uv(i).t,u(:,3),'o'); sub_ax(4)=gca; hold on;

fprintf(1,'\nProcessing data set %s\n',uv(i).name);
fprintf(1,'Click mouse to select or de-select outliers.\n');
fprintf(1,'Hit <return> to stop.\n');

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
        row = find(0==(sum((uv(i).dat-y(ones(r,1),:))')));
      end;
    else    % if win > 1 	  
      % find closest pc scores
      dx = [uv(i).t-pt(1,1), u(:,win-1)-pt(1,2)]';
      [ignore,row] = min(sum(dx.^2));
    end;    % if win == 1 

  w1_obj = findobj(sub_ax(1),'ydata',uv(i).dat(row,:)); % pointer to spectrum in window 1
 
    if ix(row) == 1,  % de-select row
      ix(row) = 0;
      set(w1_obj,'color','r');	% change spectrum color
      fprintf(1,'Deleted row %g\n',row);
    else				% or re-select row
      ix(row) = 1;
      fprintf(1,'Un-deleted row %g\n',row);
      set(w1_obj,'color','b');	% change spectrum color
      subplot(2,2,2); plot(uv(i).t(row),u(row,1),'bo');
      subplot(2,2,3); plot(uv(i).t(row),u(row,2),'bo');
      subplot(2,2,4); plot(uv(i).t(row),u(row,3),'bo');
    end;
    rows = find(ix==0);
    subplot(2,2,2); plot(uv(i).t(rows),u(rows,1),'ro');
    subplot(2,2,3); plot(uv(i).t(rows),u(rows,2),'ro');
    subplot(2,2,4); plot(uv(i).t(rows),u(rows,3),'ro');
  end;
  window_done = waitforbuttonpress;
end;  % while window_done
set(gcf,'pointer','arrow');

ix=find(ix==1);
new_struct(i).t = uv(i).t(ix);
new_struct(i).dat=uv(i).dat(ix,:);
set(gcf,'nextplot','replace');
for i=1:4
  set(sub_ax,'nextplot','replace');
end;

end;
