function [y,b,idx]=baslncor(x,wv);
% BASLNCOR -- baseline correction (interactive)
%
% [y,b]=baslncor(x,wv);
%
% x = matrix that you wish to correct;
% wv = wvln index for plots (optional)
%
% y = matrix of corrected spectra
% b = vector of row means of the selected range

[r,c]=size(x);

if nargin == 1,
  wv = 1:c;
end;

plot(wv,x);  
title('Uncorrected');
disp('Select wvln range with mouse 2 clicks.'); 
[ix,iy]=ginput(2);
if ix(1) > ix(2),
  temp = ix(1); ix(1) = ix(2); ix(2) = temp;
end;
npts=length(ix);
for i=1:npts
  [w,ix(i)]=min(abs(wv-ix(i)));
end;
disp(' ')
disp('   Selected wavelengths')
disp('    wvln        index')
disp('============ ============ ')
for i=1:npts
  iy(i)=wv(ix(i));
  disp(sprintf('%9.2f    %7.0f',iy(i),ix(i)));
end;

idx = ix(1):ix(2);
[y,b] = bascor(x,ix(1),ix(2));

plot(wv,y);
title('Corrected');

ques=input('Try again (1=yes/0=no) [1]: ');
if isempty(ques), ques=1; end;
if ques ==1,
  [y,b,idx]=baslncor(x); 
end;

