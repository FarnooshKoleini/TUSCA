function h = biplot(x,pr,color);
% BIPLOT -- Compute and plot ellipse for bivariate distribution in x.
%
% x should be trn set w/ 2 columns. ellipse drawn at prob. level given
% by chi^2. 
%
% Use:  
% 1. make a scatter plot first.  2. put hold on.  3. plot ellipse. 4. hold off
%
% plot(x(:,1),x(:,2),'ro'); hold on; biplot(x,0.95,'r'); hold off;
%
% see also bi_test

% COPYRIGHT, 1996.  Un-authorized use prohibited.
% Paul J. Gemperline
% Department of Chemistry
% East Carolina University
% Greenville, NC 27858
% 919-328-6767
% chgemper@ecuvax.cis.ecu.edu

if nargin ~= 3, error('BIPLOT requires 3 input arguments.'); end;

[npts,c]=size(x);
if c ~= 2, error('BIPLOT - Matrix u must have 2 columns.'); end;

%
% compute axes for ellipse
%
[uc,mu]=meancorr(x);			% compute maj & minor axis length & direction
[u,s,v]=svd(uc,0);
d = (s.^2)./npts;				% compute e'vals adj. for npts.

%
% compute ploting coordinates of ellipse
%
unit_circle = [sin(0:pi/64:2*pi)' cos(0:pi/64:2*pi)'];
chi2 = chi_crit(pr,2);

num_ellipse = length(pr);
for j=1:num_ellipse

  elip = unit_circle * sqrt(d*chi2(j))*v';		% xform circle to ellipse
  if ischar(color) % is color specification a string or a number?
    h = plot(elip(:,1)+mu(1),elip(:,2)+mu(2),color);  % and plot it
  else
    h = plot(elip(:,1)+mu(1),elip(:,2)+mu(2),'Color',color);  % and plot it
  end

  ax = v*sqrt(d*chi2(j));	% compute endpoints of maj & minor axes
  for i=1:2					% an plot 'em
      if ischar(color)
          plot([ax(1,i)+mu(1),-ax(1,i)+mu(1)],[ax(2,i)+mu(2),-ax(2,i)+mu(2)],color);
      else
          plot([ax(1,i)+mu(1),-ax(1,i)+mu(1)],[ax(2,i)+mu(2),-ax(2,i)+mu(2)],'Color',color);
      end
  end;
end;

%
% adj plot x-y axes so maj & minor axes of ellipse look orthogonal
%
axis('auto');
axis('equal');
