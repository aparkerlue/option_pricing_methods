function [opt] = binom(S, X, r, T, sd, fCallPut, fAmEur, n, q, D)
%BINOM Binomial put and call pricing.
%   [OPT] = BINOM() prices an option using a binomial pricing model.
%
%   Assumes dividends are paid quarterly and that the last dividend
%   is paid one-half month prior to expiration.  The dividend yield
%   q is specified as an annual percentage.

if nargin < 10, D = 0; end
if nargin < 9, q = 0; end

dt = T/n;
u = exp(sd*sqrt(dt));
d = 1/u;
p = (exp(r*dt) - d) / (u - d);

S_T = S * u.^(n:-1:0) .* d.^(0:n);
if q > 0                                % Account for dividend yield.
    nq = floor(4*(T - 0.5/12) + 1);
    S_T = S_T * (1 - q/4)^nq;
end
if (fCallPut)                           % Option is call.
    v = bsxfun(@max, S_T - repmat(X, [1 n+1]), 0);
else                                    % Option is put.
    v = bsxfun(@max, repmat(X, [1 n+1]) - S_T, 0);
end

for i = n-1:-1:0
    v_u = v(1:end-1);
    v_d = v(2:end);
    cv = exp(-r*dt) * (p*v_u + (1-p)*v_d);
    
    if (fAmEur)                         % Option is American.
        S_i = S * u.^(i:-1:0) .* d.^(0:i);
        if q > 0                        % Account for dividend yield.
            nq = floor(4*(i*dt - 0.5/12) + 1);
            S_i = S_i * (1 - q/4)^nq;
        end
        if (fCallPut)                   % Option is a call.
            ev = bsxfun(@max, S_i - repmat(X, [1 i+1]), 0);
        else                            % Option is a put.
            ev = bsxfun(@max, repmat(X, [1 i+1]) - S_i, 0);
        end
        v = bsxfun(@max, cv, ev);
    else                                % Option is European.
        v = cv;
    end
end

opt = v;
