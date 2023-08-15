function pub_std(fn)
% PUB_STD - sets STANDARD plot characteristics for journals and books
%
% pub_fig('none','',2,14,5.75,3.25,'helvetica','bold');
% pub_fig(fn,'',1,12,5.75,3.25,'helvetica','normal');
%
% pub_std(fn)
if nargin < 1; fn='none'; end;
pub_fig(fn,'',1,12,5.75,3.25,'helvetica','normal');
