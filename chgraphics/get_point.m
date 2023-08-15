function [index,handle]=get_point(w,y,color,k);
% GET_POINT - returns an index of selected points from existing plot.
%
%>inputs 
%x:     The x variable that is being graphed. This corresponds 
%       to the first column of the index that will be returned.
%       x is restricted to a 1xn matrix because points are selected
%       on the basis of x first and then y.  the program can be modified however.
%y:     The y variable that is being graphed. This corresponds 
%       to the second column of the index that will be returned. 
%color: The color and shape of the point that is selected 
%       (optional, default = 'ro')
%k:     The number of points to be selected (optional).
%
%>outputs
%idx:   graphically selected index values that correspond to x 
%       and y in that order. 
%h:     handle for each point added to the plot.
%
%[idx,h]=get_point(x,y,'ro',k);

if nargin<4,
   k = 0;
end;

if nargin<3,
   color = 'ro';
end;

if nargin<2,
  	error('get_point requires a y value and a w value')
end;
if k > 0,  %This set of commands deals with getting k points. 
   if k == 1,
      fprintf(1,'\nPlease select %g point by clicking the mouse.\n\n',k);
   end;
   if k > 1,
      fprintf(1,'\nPlease select %g points by clicking the mouse.\n\n',k);
   end;
disp('Clicking the left mouse button will select and');
disp('clicking the right mouse button will de-select points.');
disp('On the Mac clicking selects a point. ');
disp('On the Mac <shift> click deletes a point.');
disp('Hit <return> when you are finished.');
hold on;
   [a,aa]=size(w);
   if a ~= 1,        % checks size of w to make sure it is 1xn.
      error('get_point requires that the wavelength be 1xn')
   end;
   [ay,aay]=size(y);
   if a == 1,          % makes sure demensions of w and y are correct.
      if aa ~= aay,
         y=y';         [ay,aay]=size(y);
      end;
   end;   npks = 0;         % initialize counter for k components.
   temp = zeros(1,5);
   while npks ~= k,
      [aaa,bbb,button]=ginput(1); % initial ginput and if too few points are selected
      while ~isempty(button),
         if button > 1 , % this section is for point deletion
            if npks == 0,
               waitdlg(warndlg(...
                  sprintf('no points selected yet for deletion.\nThis point will be used for your first selection.'),'get_point'));
               nnn=length(aaa);
               [yyy,idx]=min(abs(w(ones(nnn,1),:)'-aaa(:,ones(aa,1))'));
               [yyy2,idx2]=min(abs(y(:,idx)-bbb(ones(ay,1))));
               npks =npks + 1;
               temp(npks,1)=idx;
               temp(npks,2) = idx2;	
               temp(npks,3)=plot(w(1,idx),y(idx2,idx),color);
               temp(npks,4)=aaa;
               temp(npks,5)=bbb;
            else % special delete function that finds closest point to mouse click and deletes it.
               ccc=[aaa bbb];
               [stemx,stemy]=size(temp);
               mw=max(w);
               my=max(max(y));
               ccc=[(aaa./mw) (bbb./my)];
               mwy=[mw my];
               cor_temp=temp(:,[4:5])./mwy(ones(stemx,1),:);
               ddd=(cor_temp-ccc(ones(stemx,1),:));
               eee=(((ddd(:,1)).^2)+((ddd(:,2)).^2));
               [yfy,idx]=min(eee);
               temp(idx,1) = 0; % sets values of deleted point to zero.
               temp(idx,2) = 0;
               delete(temp(idx,3)); % deletes handle for deleted point.
               temp(idx,3) = 0;
               temp(idx,4) = 0;
               temp(idx,5) = 0;
               temp1=[temp([1:[idx-1]],:);temp([[idx+1]:[stemx]],:)]; % condenses matrix containing output data
               temp=temp1;
               npks=npks-1;
               if npks == 0,
                  temp = zeros(1,5); % reinitializes temp matrix if all points are deleted.
               end;
            end;
         else    % points are selected and drawn here.
            nnn=length(aaa);
            [yyy,idx]=min(abs(w(ones(nnn,1),:)'-aaa(:,ones(aa,1))'));% selects closest point to mouse click.
            [yyy2,idx2]=min(abs(y(:,idx)-bbb(ones(ay,1))));
            if temp(:,1) ~= round(idx), % checking to see if point is already selected.		
               if npks == k,
                  waitdlg(warndlg(...
		               sprintf('You can''t select more than %g points.\nDe-select a point first.',k),'get_point'));
               else  % stores information about point that was just selected. 
                  npks =npks + 1;
                  temp(npks,1)=idx;
                  temp(npks,2)=idx2;	
                  temp(npks,3)=plot(w(1,idx),y(idx2,idx),color); % saves handle for point
                  temp(npks,4)=aaa;
                  temp(npks,5)=bbb;
               end;
            else,
               nn=1;
               indd = zeros(1,1);
               for ide=1:npks,
                  if temp(ide,1) == round(idx);
                     indd(nn,1)=ide;
                     nn=nn+1;
                  end;
               end;
               if temp(indd',2) ~= round(idx2), % the program checks both the y and x position for the new point.
                  if npks == k,
                     waitdlg(warndlg(...
		                  sprintf('You can''t select more than %g points.\nDe-select a point first.',k),'get_point'));
                  else
                     npks = npks +1;
                     temp(npks,1)=idx;
                     temp(npks,2) = idx2;	
                     temp(npks,3)=plot(w(1,idx),y(idx2,idx),color);
                     temp(npks,4)=aaa;
                     temp(npks,5)=bbb;
                  end;
               else
                  waitdlg(warndlg(...
                     sprintf('point already selected.'),'get_point'));
               end;
            end;
         end;
         [aaa,bbb,button]=ginput(1); %ginput for selection of points after initial click.
      end;
      if npks < k, % checks to see  if enough points have been selected.
         waitdlg(warndlg(sprintf('You must select %g points.',k),'get_point'));
      end;
   end;
else %This part gets points if k is not selected.
   hold on;
   fprintf(1,'\nPlease select as many points as you need by clicking the mouse.\n\n');
   disp('Clicking the left mouse button will select and');
   disp('clicking the right mouse button will de-select points.');
   disp('On the Mac clicking selects a point. ');
   disp('On the Mac <shift> click deletes a point.');
   disp('Hit <return> when you are finished.');
   [a,aa]=size(w);
   if a ~= 1,        % checks size of w to make sure it is 1xn.
      error('get_point requires that the wavelength be 1xn')
   end;
   [ay,aay]=size(y);
   if a == 1,          % makes sure demensions of w and y are correct.
      if aa ~= aay,
         y=y';         [ay,aay]=size(y);
      end;
   end;
   [aaa,bbb,button]=ginput(1); % initial ginput for intial mouse click.
   nnn=length(aaa);
   temp = zeros(1,5);
   vv=1; 
   if(~isempty(button)),
      if button  > 1,   % section for deleting a point.
          waitdlg(warndlg(...
		            sprintf('no points selected yet for deletion.\nThis point will be used for your first selection.'),'get_point'));               
      end;
      [yyy,idx]=min(abs(w(ones(nnn,1),:)'-aaa(:,ones(aa,1))'));
      [yyy2,idx2]=min(abs(y(:,idx)-bbb(ones(ay,1))));
      temp(vv,1)=idx;
      temp(vv,2) = idx2;
      temp(vv,3)=plot(w(1,idx),y(idx2,idx),color);
      temp(vv,4)=aaa;
      temp(vv,5)=bbb;
      while (~isempty(button)),
         [aaa,bbb,button]=ginput(1);
         vv=vv+1;
         if(~isempty(button)),
            if button > 1,  % if no points are selected and the deselect button
               if vv == 1,  % is used, the point selected will be used as the first point.
                  waitdlg(warndlg(...
                     sprintf('no points selected yet for deletion.\nThis point will be used for your first selection.'),'get_point'));
                  nnn=length(aaa);
                  [yyy,idx]=min(abs(w(ones(nnn,1),:)'-aaa(:,ones(aa,1))'));
                  [yyy2,idx2]=min(abs(y(:,idx)-bbb(ones(ay,1))));

                  temp(vv,1)=idx;
                  temp(vv,2) = idx2;
                  temp(vv,3)=plot(w(1,idx),y(idx2,idx),color);
                  temp(vv,4)=aaa;
                  temp(vv,5)=bbb;
               else       % if points are selected, the closest point will be deleted.
                  ccc=[aaa bbb];
                  [stemx,stemy]=size(temp);
                  mw=max(w);
                  my=max(max(y));
                  ccc=[(aaa./mw) (bbb./my)];
                  mwy=[mw my];
                  cor_temp=temp(:,[4:5])./mwy(ones(stemx,1),:);
                  ddd=(cor_temp-ccc(ones(stemx,1),:));
                  eee=(((ddd(:,1)).^2)+((ddd(:,2)).^2));
                  [yfy,idx]=min(eee);
                  temp(idx,1) = 0;
                  temp(idx,2) = 0;
                  delete(temp(idx,3));
                  temp(idx,3) = 0;
                  temp(idx,4) = 0;
                  temp(idx,5) = 0;
                  temp1=[temp([1:[idx-1]],:);temp([[idx+1]:[vv-1]],:)];
                  temp=temp1;
                  vv=vv-2;
                  if vv ==0, % resets the temp file if all points are deleted.
                     temp = zeros(1,5);
                  end;
               end;
            else % selectes point closest to mouse click.
               [yyy,idx]=min(abs(w(ones(nnn,1),:)'-aaa(:,ones(aa,1))'));
               [yyy2,idx2]=min(abs(y(:,idx)-bbb(ones(ay,1))));
               if temp(:,1) ~= round(idx), % makes sure that none of the points have the same x value as the selected point.	
                  temp(vv,1)=idx;
                  temp(vv,2) = idx2;
                  temp(vv,3)=plot(w(1,idx),y(idx2,idx),color); % saves handle of point selected.
                  temp(vv,4)=aaa;
                  temp(vv,5)=bbb;
               else;
                  nn=1;
                  indd = zeros(1,1);
                  for ide=1:[vv-1],
                     if temp(ide,1) == round(idx);
                        indd(nn,1)=ide;
                        nn=nn+1;
                     end;
                  end;
                  if temp(indd',2) ~= round(idx2); % makes sure the y value of the selected point is not the same as any other selected points.
                     temp(vv,1)=idx;
                     temp(vv,2) = idx2;	
                     temp(vv,3)=plot(w(1,idx),y(idx2,idx),color);
                     temp(vv,4)=aaa;
                     temp(vv,5)=bbb;
                  else % if point is the same as a point already selected.
                        waitdlg(warndlg(...
                        sprintf('point already selected.'),'get_point'));
                     vv=vv-1;
                     if vv ==0,
                        temp = zeros(1,5);
                     end;
                  end;
               end;
            end;
         end;
      end;
   end;
end;
handle=temp(:,3);
hold off;
index=temp(:,[1:2]);
[aha,bhb]=size(handle);
if aha == 1,
   if handle(1,1) == 0,
      handle=[];
      index=[];
   end;
end;
