function [ctest]=refine3(ctest,k,index);
%
%REFINE3 removes the negative region in the composition profile
%[ctest]=refine3(ctest, k, index);
%

[r,c]=size(ctest);
rr=ctest-smooth(ctest,1);
rrr=rr-smooth(rr,1);
noice=6*median(abs(rrr));

for l=1:c,
   ctest(:,l)=ctest(:,l).*(ctest(:,l)>noice(l));

  i=index(l);
  for j=i+2:length(ctest),
    if ctest(j-1,l)==0,
      ctest(j-1,l)=noice(l);
    end
  end;
  for j=i-2:-1:1,
    if ctest(j+1,l)==0,
      ctest(j+1,l)=noice(l);
    end
  end;
end;
