function showline(a1,a2,a3,a4,a5)
% SHOWLINE -- convert solid lines to various line styles.
%
% The change is transparent to the user.
% Non-solid lines are not affected.
%
% The default line styles are:
%
%              '- '
%              '-.'
%              '--'
%              ': '
%              '. '
%              'o '
%              'x '
%              '+ '
%              '* '
%
% The line style can be changed by editing the file and changing the 'styles' 
% array.

% Written by John L. Galenski III
% All Rights Reserved  10/14/93
% LDM101493jlg

%% PRTLINES is an M-file developed by me for my own personal use, and 
%% therefore,it is not supported by The MathWorks, Inc., or myself. 
%% Please direct any questions or comments to johng@mathworks.com.

% Create the array of line styles.
styles = [
              '- '
              '-.'
              '--'
              ': '
              '. '
              'o '
              'x '
              '+ '
              '* '
      ];

% Get the 'Children' of the Figure.
a = get(gcf,'children');

% Check the 'Children' of 'a'.  If they are solid lines, then change their
% 'LineStyle' property.
for j = 1:length(a)
   l = sort(get(a(j),'children'));
   X = 0;
   Add = 0;
   for i = 1:length(l)
      if strcmp( 'line', get(l(i), 'type' ))
      if strcmp(get(l(i),'linestyle'),'-')
        X = X + 1;
        LINE = [LINE;l(i)];
        SI =  rem(X,length(styles));
        if SI == 0
          Add = 1;
        end
          set(l(i),'linestyle', styles(SI+Add,:));
      end
      end
   end
end

% Construct the PRTCMD.
%PRTCMD = 'print';
%for x = 1:nargin
%      PRTCMD = [PRTCMD,' ',eval(['a',int2str(x)])];
%end

% Discard the changes so that the Figure is not updated.
%drawnow discard
%eval(PRTCMD)

% Reset the 'LineStyles'
%set(LINE,'linestyle','-')

% Discard the changes so that the Figure is not updated.
%drawnow discard
