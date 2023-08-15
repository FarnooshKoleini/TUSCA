x1=3.2*randn(2000,1)+5;
x2 = x1+ 2.2*randn(2000,1)+10;
x=[x1 x2];
plot(x1,x2,'o');
hold on; biplot(x,0.9997,'r')
lb=mean(x)-3*std(x)
ub=mean(x)+3*std(x);
box=[lb; [lb(1),ub(2)]; ub; [ub(1) lb(2)]; lb];
plot(box(:,1),box(:,2),'m')
r=corrcoef(x)
legend(sprintf('r^2=%s',r(2,2)),'99.97% CL ellipse','6-sigma box (99.97% CL')% Script to compare 6-sigma boxes with 99.97% CL ellipsoids

%set one
fi;
x1=3.2*randn(2000,1)+5;
xx=randn(2000,1);
x2 = x1+ 2.2*xx+10;
x=[x1 x2];
plot(x1,x2,'o');
hold on; 
lb=mean(x)-3*std(x);
ub=mean(x)+3*std(x);
box=[lb; [lb(1),ub(2)]; ub; [ub(1) lb(2)]; lb];
plot(box(:,1),box(:,2),'m')
biplot(x,0.9997,'r')
r=corrcoef(x);
legend(sprintf('R^2=%g',r(1,2)),'99.97% CL ellipse','6-sigma box (99.97% CL')

%set 2
figure
x2 = x1+ 4.2*xx+10;
x=[x1 x2];
plot(x1,x2,'o');
hold on; 
lb=mean(x)-3*std(x);
ub=mean(x)+3*std(x);
box=[lb; [lb(1),ub(2)]; ub; [ub(1) lb(2)]; lb];
plot(box(:,1),box(:,2),'m')
biplot(x,0.9997,'r')
r=corrcoef(x);
legend(sprintf('R^2=%g',r(1,2)),'99.97% CL ellipse','6-sigma box (99.97% CL')

%set 3
figure
x2 = x1+ 1.2*xx+10;
x=[x1 x2];
plot(x1,x2,'o');
hold on; 
lb=mean(x)-3*std(x);
ub=mean(x)+3*std(x);
box=[lb; [lb(1),ub(2)]; ub; [ub(1) lb(2)]; lb];
plot(box(:,1),box(:,2),'m')
biplot(x,0.9997,'r')
r=corrcoef(x);
legend(sprintf('R^2=%g',r(1,2)),'99.97% CL ellipse','6-sigma box (99.97% CL')

%set 4
figure
x2 = xx+10 + .1*x1;
x=[x1 x2];
plot(x1,x2,'o');
hold on; 
lb=mean(x)-3*std(x);
ub=mean(x)+3*std(x);
box=[lb; [lb(1),ub(2)]; ub; [ub(1) lb(2)]; lb];
plot(box(:,1),box(:,2),'m')
biplot(x,0.9997,'r')
r=corrcoef(x);
legend(sprintf('R^2=%g',r(1,2)),'99.97% CL ellipse','6-sigma box (99.97% CL')
