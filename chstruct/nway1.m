function [cp0,ep0,t0]=nway(a,e_avrg,n,tol,max_iter);

% function nway is a nway analysis test function

%

% >>input

% a:      structure contains data matrices(spectra in row)

% e_avrg: average of pure spetrum estimated by one-by-one analysis

% n:      number of data sets

% <<output

% cp:     structure contains refined concentration profile

% ep:     refined pure spectrum

%

% [cp,ep]=nway(a,e_avrg,n);



etest=e_avrg';

[nr,nc]=size(etest);

e_new=zeros(nr,nc);

if nargin<5, max_iter=50; end;

if nargin<4, tol = 1e-6; end;



% using average pure spectrum to start the refine

iter=1;

for i=n:-1:1

   %[ep,c0(i).dat]=nn_refine(a(i).dat',etest);

   [ep(i).dat,c0(i).dat]=non_neg(a(i).dat',etest);

   e_new=e_new+ep(i).dat;

end

% test convergence

e_new=e_new/n;

while (sum(sum(etest-e_new).^2)/sum(sum(etest.^2))>tol & iter<max_iter)

%while sum(sum(etest-e_new).^2)/sum(sum(etest.^2))>tol

   iter=iter+1

   etest=e_new;

   e_new=zeros(nr,nc);

   for i=n:-1:1

      %[ep,c0(i).dat]=nn_refine(a(i).dat',etest);

      [ep(i).dat,c0(i).dat]=non_neg(a(i).dat',etest);

      e_new=e_new+ep(i).dat;

   end

   e_new=e_new/n;

end

t0=sum(sum(etest-e_new).^2)/sum(sum(etest.^2));

cp0=c0;

ep0=ep;







