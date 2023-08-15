function [e,c]=rot_rows(e,c,r,s,t,u);
% ROT_LYRS -- rotate layer basis vectors, e, of a tucker 3-way model.
%
% [e,c]=rot_lyrs(e,c,r,s,t,u);
%
% This function computes the rotated layer basis vectors, e(Kxs),
% and the core matrix, c(sxtxu), according to some arbitrary rotation
% matrix, r(uxu), provided by the caller.
%
e=e*r;
c=uf_layer(c,s,t,u);
c=r\c;                        % multiply by left inverse of r
c=f_layer(c,s,t,u);
