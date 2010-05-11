%% All parameters are scalars.
function [ OptionValue ] = fdi1(S, X, r, sd, T, q, m, n, fCallPut, fAmEur)
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
    A = zeros([m-1 m-1]);
    B = zeros([m-1 1]);
    for j = 1:m-1
        a = 0.5*(r - q)*j*dt - 0.5*sd^2*j^2*dt;
        b = 1 + sd^2*j^2*dt + r*dt;
        c = -0.5*(r - q)*j*dt - 0.5*sd^2*j^2*dt;
        if (j == 1)             % f(j-1) == X.
            A(j,j:j+1) = [b c];
            B(j) = f(j,i+1) - a*f_S0;
        elseif (j == m-1)       % f(j+1) == 0.
            A(j,j-1:j) = [a b];
            if (i == 0)         % FIXME: Hack; all f(m,:) are identical.
                B(j) = f(j,i+1) - c*f(j+1,i+1);
            else
                B(j) = f(j,i+1) - c*f(j+1,i);
            end
        else
            A(j,j-1:j+1) = [a b c];
            B(j) = f(j,i+1);
        end
    end
    f_i = linsolve(A,B);
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
