function axis_tight(pct);
% AXIS_TIGHT  --  Makes plot axis tight at +/- 2%
if nargin < 1,
	pct = 2;
end;
frac = pct/100;

axis('tight');
ax=axis;
dx = (ax(2)-ax(1))*frac;
dy = (ax(4)-ax(3))*frac;

axis([ax(1)-dx; ax(2)+dx; ax(3)-dy; ax(4)+dy]);
