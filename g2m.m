function [i_m] = g2m(i_g)
%G2M Transform grid index into matrix index.
%   [I_M] = G2M(I_G) transforms a grid index into a matrix index by
%   adding 1.

i_m = i_g + 1;
