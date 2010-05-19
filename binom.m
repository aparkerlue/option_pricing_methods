function [opt] = binom(S, X, r, T, sd, q, fCallPut, fAmEur, n)
%BINOM Binomial put and call pricing.
%   [OPT] = BINOM() prices an option using a binomial pricing model.

dt = T/n;
u = exp(sd*sqrt(dt));
d = 1/u;
p = (exp(r*dt) - d) / (u - d);

S_T = S * u.^(n:-1:0) .* d.^(0:n);
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
