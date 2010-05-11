function [ u ] = binom(S, X, r, t, dt, sd)
	u = exp(sd*sqrt(dt));
	d = 1/u;
	p = (exp(r*dt) - d) / (u - d);
    
	n = t / dt;                 % `n' must be a positive integer.
	S_T = S * u.^(n:-1:0) .* d.^(0:n);
	v = bsxfun(@max, repmat(X, [ 1 n+1 ]) - S_T, 0);
	for i = n-1:-1:0
        v_u = v(1:end-1);
        v_d = v(2:end);
        cv = exp(-r*dt) * (p*v_u + (1-p)*v_d);
        
        S_i = S * u.^(i:-1:0) .* d.^(0:i);
        ev = bsxfun(@max, repmat(X, [ 1 i+1 ]) - S_i, 0);
        
        v = bsxfun(@max, cv, ev);
	end
