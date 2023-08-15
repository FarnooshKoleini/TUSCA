function [h,c]=rot_cols(h,c,r,s,t,u);
% ROT_COLS -- rotate col basis vectors, h, of a tucker 3-way model.
%
% [h,c]=rot_cols(h,c,r,s,t,u);
%
% This function computes the rotated row basis vectors, h(Jxs),
% and the core matrix, c(sxtxu), according to some arbitrary rotation
% matrix, r(txt), provided by the caller.
h=h*r;
c=(r\c')';  % multiply by left inverse of r
