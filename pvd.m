function [pv] = pvd(D, r, t, T_last)
%PVD Present value of future dividends.
%   [PV] = PVD() computes the present value of future dividends.
%
%   Assumes dividends are paid quarterly.

if t >= T_last
    pv = 0;
else
    t2div = fliplr(T_last:-0.25:t) - t;
    t2div = t2div(t2div ~= 0);
    pv = sum(D*exp(-r*t2div));
end
