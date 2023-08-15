%
% BI_TEST -- script to test biplot

pr=[.95 .80]; 
npts = 50;

sp = 0.6;	% spread

u=sp*randn(npts,1)+3;
u(:,2)=-u(:,1)-2*sp*randn(npts,1);
plot(u(:,1),u(:,2),'bo')
u1=u;

hold on;
u=sp*randn(npts,1);
u(:,2)=u(:,1)+2*sp*randn(npts,1)+3;
plot(u(:,1),u(:,2),'rx')
u2=u;

u=sp*randn(npts,1);
u(:,2)=u(:,1)+1.5*sp*randn(npts,1)-3;
plot(u(:,1),u(:,2),'g+')
u3=u;

u=2*sp*randn(npts,1)-4;
u(:,2)=-u(:,1)+1.6*sp*randn(npts,1)-5;
plot(u(:,1),u(:,2),'m*')
u4=u;

hold on
drawnow
biplot(u1,pr,'b');
drawnow
biplot(u2,pr,'r');
drawnow
biplot(u3,pr,'g');
drawnow
biplot(u4,pr,'m');

hold off;
