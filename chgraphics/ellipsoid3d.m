function ellipsoid3d(X,pr,color);
% ellipsoid3d -- Compute and plot a 3d ellipsoid for trivariate distribution in x.
%
% x should have 3 columns. ellipse drawn at prob. level given
% by chi^2. 
%
% Use:  
% ellipsoid3d(X,pr,color);
%
% Ex:
% ellipsoid3d(x,[0.99 90],'r');
%
% see also ellip_test

% COPYRIGHT, 2004.  Un-authorized use prohibited.
% Paul J. Gemperline
% Department of Chemistry
% East Carolina University
% Greenville, NC 27858
% 252-328-9810
% gemperlinep@mail.ecu.edu

if nargin ~= 3, error('ELLIPSOID requires 3 input arguments.'); end;
[npts,c]=size(X);
if c ~= 3, error('ELLIPSOID - Matrix u must have 3 columns.'); end;

hold_state = ishold;

%
% plot the data
%
h1=plot3(X(:,1),X(:,2),X(:,3),'o');
set(h1,'color',color);
pt_color = get(h1,'color');
set(h1,'MarkerFaceColor',pt_color);  % make the color of the points darker
set(h1,'color',pt_color * 0.7);  % make the color of the points darker
%
% compute axes for ellipse
%
[Xm,M]=meancorr(X);			    % compute maj & minor axis length & direction
[u,s,v]=svd(Xm);
d = (diag(s).^2)./npts;			% compute e'vals adj. for npts.
chi2 = chi_crit(pr,3);          % crit value of chi^2 at probability level pr and 3 degrees of freedom gives size of ellipse

%
% compute ploting coordinates of ellipse
%
num_ellipse = length(pr);
for j=1:num_ellipse
    
    Radii = sqrt(d*chi2(j));	% compute radii of maj & minor axes
    [xc,yc,zc]=ellipsoid(0,0,0,Radii(1),Radii(2),Radii(3),30);
    a = kron(v(:,1),xc); b = kron(v(:,2),yc); c = kron(v(:,3),zc);  % map axes to correct orrientation
    data = a+b+c; 
    n = size(data,2);
    x = data(1:n,:)+M(1); 
    y = data(n+1:2*n,:)+M(2); 
    z = data(2*n+1:end,:)+M(3);

    hold on;            % plot the ellipsoid
    h2=surf(x,y,z);
    set(h2,'FaceLighting','g','FaceColor',color,'edgecolor','none','AmbientStrength',0.7);
    light;
    alpha(0.15/j);
    
    ax = v*sqrt(diag(d)*chi2(j));	% compute endpoints of maj & minor axes
    for i=1:3					% an plot 'em
        h3(i)=plot3([ax(1,i)+M(1),-ax(1,i)+M(1)],[ax(2,i)+M(2),-ax(2,i)+M(2)],[ax(3,i)+M(3),-ax(3,i)+M(3)],color);
        set(h3(i),'color',pt_color*.4+.6);
    end;
    
    hold off;
end
%
% adj plot x-y axes so maj & minor axes of ellipse look orthogonal
%
% axis('equal');
if hold_state,
    hold on;
end;