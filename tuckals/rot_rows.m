function [g,c]=rot_rows(g,c,r,s,t,u);
% ROT_ROWS -- rotate row basis vectors, g, of a tucker 3-way model.
%
% [g,c]=rot_rows(g,c,r,s,t,u);
%
% This function computes the rotated row basis vectors, g(Ixs),
% and the core matrix, c(sxtxu), according to some arbitrary rotation
% matrix, r(sxs), provided by the caller.
%
g=g*r;
c=uf_col(c,s,t,u);
c=r\c;                        % multiply by left inverse of r
c=f_col(c,s,t,u);
