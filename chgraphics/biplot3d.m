function biplot3d(x,y,z,pr,cl);
% BIPLOT3D -- Compute and plot ellipse for trivariate distribution in x,y,z.
%
% biplot3d(x,y,z,pr,cl);
%
% Ellipse drawn at prob. level(s) given by chi^2. 
% Default color is dark grey. 
%
% Set axis('equal') for orthog. ellipse axes.
%
% See SCORES3D

% COPYRIGHT, 1996.  Un-authorized use prohibited.
% Paul J. Gemperline
% Department of Chemistry
% East Carolina University
% Greenville, NC 27858
% 919-328-6767
% chgemper@ecuvax.cis.ecu.edu

if nargin < 4, error('BIPLOT requires 4 at least input arguments.'); end;
if nargin ~= 5, cl=[ .5 .5 .5]; end
[npts,c]=size(x);
ax=axis;

%
% compute ploting coordinates of ellipse
%
unit_circle = [sin(0:pi/64:2*pi)' cos(0:pi/64:2*pi)'];
chi2 = chi_crit(pr,2);

%
% compute axes for ellipse on X-Y plane.
%
[uc,mu]=meancorr([x y]);		% compute maj & minor axis length & direction
[u,s,v]=svd(uc,0);
d = (s.^2)./npts;				% compute e'vals adj. for npts.

num_ellipse = length(pr);
for j=1:num_ellipse

  elip = unit_circle * sqrt(d*chi2(j))*v';		% xform circle to ellipse
  plot3(elip(:,1)+mu(1),elip(:,2)+mu(2),ax(5)*ones(129,1),'color',cl);  % and plot it
  
  eax = v*sqrt(d*chi2(j));	% compute endpoints of maj & minor axes
  for i=1:2					% an plot 'em
    plot3([eax(1,i)+mu(1),-eax(1,i)+mu(1)],[eax(2,i)+mu(2),-eax(2,i)+mu(2)],[ax(5),ax(5)],'color',cl)
  end;
end;


%
% compute axes for ellipse on Y-Z plane.
%
[uc,mu]=meancorr([y z]);		% compute maj & minor axis length & direction
[u,s,v]=svd(uc,0);
d = (s.^2)./npts;				% compute e'vals adj. for npts.

num_ellipse = length(pr);
for j=1:num_ellipse

  elip = unit_circle * sqrt(d*chi2(j))*v';		% xform circle to ellipse
  plot3(ax(2)*ones(129,1),elip(:,1)+mu(1),elip(:,2)+mu(2),'color',cl);  % and plot it
  
  eax = v*sqrt(d*chi2(j));	% compute endpoints of maj & minor axes
  for i=1:2					% an plot 'em
    plot3([ax(2),ax(2)],[eax(1,i)+mu(1),-eax(1,i)+mu(1)],[eax(2,i)+mu(2),-eax(2,i)+mu(2)],'color',cl)
  end;
end;

axis('equal')
