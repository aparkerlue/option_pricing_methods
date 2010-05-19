function [ OptionValue ] = fde1(S, X, r, T, sd, q, fCallPut, fAmEur, n, m)
%FDE1 Explicit finite difference method for option pricing.
%   [OPTIONVALUE] = FDE1() prices an option using an explicit finite
%   different method.

if nargin < 7
    fCallPut = 1;
end
if nargin < 8
    fAmEur = 1;
end
if nargin < 9
    n = ceil(1e3*T);
end
if nargin < 10
    m = 2*ceil(sqrt(3*n));
end

m = m + mod(m, 2);              % Ensure that m is even.
dS = 2*S/m;
dt = T/n;
f = zeros(m, n);                % Doesn't include S = 0 or t = 0.
if (fCallPut == 1)              % Option is a call.
    f(:,n) = bsxfun(@max, (1:m)'*dS - X, 0);
    f(m,:) = m*dS - X;          % At S == S_max.
    f_S0 = 0;                   % At S == 0.
else                            % Option is a put.
    f(:,n) = bsxfun(@max, X - (1:m)'*dS, 0);
    f(m,:) = 0;                 % At S == S_max.
    f_S0 = X;                   % At S == 0.
end
f_t0 = zeros([m-1 1]);
for i = n-1:-1:0
    f_i = zeros([m-1 1]);
    for j = 1:m-1
        a = 1/(1+r*dt) * (-0.5*(r-q)*j*dt + 0.5*sd^2*j^2*dt);
        b = 1/(1+r*dt) * (1 - sd^2*j^2*dt);
        c = 1/(1+r*dt) * (0.5*(r-q)*j*dt + 0.5*sd^2*j^2*dt);
        if (j == 1)
            f_i(j) = a*f_S0 + b*f(j+1,i+1) + c*f(j+1,i+1);
        else
            f_i(j) = a*f(j-1,i+1) + b*f(j,i+1) + c*f(j+1,i+1);
        end
    end
    if (fAmEur == 1)            % Option is American.
        if (fCallPut == 1)      % Option is a call.
            f_i = bsxfun(@max, f_i, (1:m-1)'*dS - X);
        else
            f_i = bsxfun(@max, f_i, X - (1:m-1)'*dS);
        end
    end
    if (i > 0)
        f(1:m-1,i) = f_i;
    else
        f_t0 = f_i;
    end
end
OptionValue = f_t0(m/2);
