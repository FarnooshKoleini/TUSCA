function [new_dat]=get_intr(struct);
% GET_INTR -- finds intersection (time and wvln) of all spectra in struct uvdat
% [new_uv]=get_intr(uvdat);
%      uvdat.name:  original file name
%      uvdat.t:     acq. time, nx1
%      uvdat.wv:    acq. wvlns, 1xm
%      uvdat.dat:   spectral, nxm

t_intersect = struct(1).t;

m = length(struct);
for i=2:m    % find the acq. times common to each run
   t_intersect = intersect(t_intersect,struct(i).t);
end;

new_dat = struct;

for i=1:m    % save the index of rows common to each run.
   idx = find(ismember(struct(i).t,t_intersect)==0);
   new_dat(i).t(idx)=[];
   new_dat(i).dat(idx,:)=[];
end

