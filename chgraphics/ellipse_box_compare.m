fi;
x1=3.2*randn(2000,1)+5;
x2 = x1+ 2.2*randn(2000,1)+10;
x=[x1 x2];
plot(x1,x2,'o');
hold on; biplot(x,0.997,'r')
lb=mean(x)-3*std(x);
ub=mean(x)+3*std(x);
box=[lb; [lb(1),ub(2)]; ub; [ub(1) lb(2)]; lb];
plot(box(:,1),box(:,2),'m')
r=corrcoef(x)
legend(sprintf('r^2=%g',r(2,1)),'99.7% CL ellipse','6-sigma box (99.7% CL)');

fi;
x1=3.2*randn(2000,1)+5;
x2 = x1+ 5.2*randn(2000,1)+10;
x=[x1 x2];
plot(x1,x2,'o');
hold on; biplot(x,0.997,'r')
lb=mean(x)-3*std(x);
ub=mean(x)+3*std(x);
box=[lb; [lb(1),ub(2)]; ub; [ub(1) lb(2)]; lb];
plot(box(:,1),box(:,2),'m')
r=corrcoef(x)
legend(sprintf('r^2=%g',r(2,1)),'99.7% CL ellipse','6-sigma box (99.7% CL)');

fi;
x1=3.2*randn(2000,1)+5;
x2 = x1+ 1.2*randn(2000,1)+10;
x=[x1 x2];
plot(x1,x2,'o');
hold on; biplot(x,0.997,'r')
lb=mean(x)-3*std(x);
ub=mean(x)+3*std(x);
box=[lb; [lb(1),ub(2)]; ub; [ub(1) lb(2)]; lb];
plot(box(:,1),box(:,2),'m')
r=corrcoef(x)
legend(sprintf('r^2=%g',r(2,1)),'99.7% CL ellipse','6-sigma box (99.7% CL)')


fi;
x1=3.2*randn(2000,1)+5;
x2 = x1+ 8.2*randn(2000,1)+10;
x=[x1 x2];
plot(x1,x2,'o');
hold on; biplot(x,0.997,'r')
lb=mean(x)-3*std(x);
ub=mean(x)+3*std(x);
box=[lb; [lb(1),ub(2)]; ub; [ub(1) lb(2)]; lb];
plot(box(:,1),box(:,2),'m')
r=corrcoef(x)
legend(sprintf('r^2=%g',r(2,1)),'99.7% CL ellipse','6-sigma box (99.7% CL)')


fi;
x1=3.2*randn(2000,1)+5;
x2 = 0.05*x1 + randn(2000,1)+10;
x=[x1 x2];
plot(x1,x2,'o');
hold on; biplot(x,0.997,'r')
lb=mean(x)-3*std(x);
ub=mean(x)+3*std(x);
box=[lb; [lb(1),ub(2)]; ub; [ub(1) lb(2)]; lb];
plot(box(:,1),box(:,2),'m')
r=corrcoef(x)
legend(sprintf('r^2=%g',r(2,1)),'99.7% CL ellipse','6-sigma box (99.7% CL)')