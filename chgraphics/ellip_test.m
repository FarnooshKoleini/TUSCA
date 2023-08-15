%
% ELLIP_TEST -- script to test 3D elipsoids

pr=[.90 .50]; 
npts = 20;

sp = 0.60;	% spread

u=sp*randn(npts,1)+3;
u(:,2)=-0.5*u(:,1)-2*sp*randn(npts,1);
u(:,3)=-0.5*u(:,1)+1.5*sp*randn(npts,1);
u1=u;

u=sp*randn(npts,1);
u(:,2)=0.5*u(:,1)+2*sp*randn(npts,1)+3;
u(:,3)=0.5*u(:,1)+1.5*sp*randn(npts,1)-3;
u2=u;

u=sp*randn(npts,1);
u(:,2)=0.2*u(:,1)+1.5*sp*randn(npts,1)-3;
u(:,3)=0.2*u(:,1)+sp*randn(npts,1)+3;
u3=u;

u=2*sp*randn(npts,1)-4;
u(:,2)=-0.3*u(:,1)+1.6*sp*randn(npts,1)-5;
u(:,3)=-0.3*u(:,1)+3.6*sp*randn(npts,1)+5;
u4=u;

ellipsoid3d(u1,pr,'b'); hold on;
ellipsoid3d(u2,pr,'r');
ellipsoid3d(u3,pr,'g');
ellipsoid3d(u4,pr,'m');
hold off;
