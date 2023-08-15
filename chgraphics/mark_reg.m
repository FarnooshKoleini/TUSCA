function [indx]=mark_reg1(xax,da,k)
% MARK_REG - mark the selected region from existing plot and return the index
%
% >>input 
%   wv: variables to label the x-axis
%   a:  data matrix
%   k: number of regions need to be selected
%
% <<output
%   idx: indx of selected region
% 
% [idx]=mark_reg(wv,a,k);

if nargin < 3,
	k = 1;
end;

[rd,cd]=size(da);
hold on
indx=zeros(k,2);h1=[];
disp('click left button to select region');
disp('hit return key to accept your selection');
h=zeros(rd,k);
for i= 1:k          %loop for selecting 
   [row,col,butn]=ginput(2);
   while (~isempty(butn))
      butn=[];
      row=sort(row);
      n=length(row);      % gets No. of points
      %gets the wv closest to selected points 
      [yy,ind]=min(abs(xax(ones(n,1),:)'-row(:,ones(cd,1))'));       
      if ind(1)<1 
        ind(1)=1;
      end;
      if ind(2)>cd
        ind(2)=cd;
      end;
         
      x1=[xax(ind(1)) xax(ind(1):ind(2)) xax(ind(2))];
      
      yy1=min(min(da));
      y1=[yy1; max(da(:,ind(1):ind(2)))'; yy1];
      h1=fill(x1,y1,'r','erasemode','xor');
      [row,col,butn]=ginput(2);
	  if ~isempty(butn), delete(h1); end;
   end
   indx(i,:)=ind;

end
hold off
