function x = flip_sign(x);
% FLIP_SIGN -- finds columns in x that are all negative and makes them
% positive
%
% x=flip_sign(x);
col_idx = all(x<0);
x(:,col_idx) = -x(:,col_idx);
