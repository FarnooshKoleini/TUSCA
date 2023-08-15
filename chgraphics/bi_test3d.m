%
% BI_TEST3D -- script to test/demo biplot3d

pr=[.95 .80]; 
npts = 100;

sp = 0.8;	% spread

u=sp*randn(npts,1)+3;
u(:,2)=-u(:,1)-2*sp*randn(npts,1);
u(:,3)=-u(:,1)-2*sp*randn(npts,1);
plot3(u(:,1),u(:,2),u(:,3),'bo')
u1=u;

hold on;
u=sp*randn(npts,1);
u(:,2)=u(:,1)+2*sp*randn(npts,1)+3;
u(:,3)=u(:,1)+2*sp*randn(npts,1)+3;
plot3(u(:,1),u(:,2),u(:,3),'rx')
u2=u;

grid;
biplot3d(u1(:,1),u1(:,2),u1(:,3),pr,'b');
biplot3d(u2(:,1),u2(:,2),u2(:,3),pr,'r');
hold off;
