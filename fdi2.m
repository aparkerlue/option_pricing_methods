%% All parameters are scalars.
function [ OptionValue ] = fdi2(S, X, r, sd, T, q, m, n, fCallPut, fAmEur, N1)
%LN_ZERO = -1e2;                 % Constant to approximate the log of 0.
ZERO = 1e-320;                  % Constant to approximate 0.
m = m + mod(m,2);               % Ensure that m is even.
Z = log(S);
Z_max = log(2*S)
dZ = Z_max/(m-N1)
Z_min = Z_max - m*dZ
iZ = m*(Z + N1*dZ)/(Z + N1*dZ + log(2))
%dZ = Z/(m/2 - N1);              % Z - m/2*dZ = -N1*dZ
%Z_min = Z - m/2*dZ
%Z_max = Z + m/2*dZ
dt = T/n;
f = zeros(m, n);                % Doesn't include Z = LN_ZERO or t = 0.
if (fCallPut == 1)              % Option is a call.
    f(:,n) = log(bsxfun(@max, exp(Z_min+dZ:dZ:Z_max)' - X, ZERO));
    f(m,:) = log(exp(Z_max) - X); % At Z == Z_max.
    f_Z0 = log(ZERO);           % At S == 0, f_Z0 is approx 0.
else                            % Option is a put.
    f(:,n) = log(bsxfun(@max, X - exp(Z_min+dZ:dZ:Z_max)', ZERO));
    f(m,:) = log(ZERO);         % At Z == Z_max, f(m,:) is approx 0.
    f_Z0 = log(X);              % At Z == 0.
end
f_t0 = log(ZERO*ones([m-1 1]));
a = dt/(2*dZ)*(r-q-sd^2/2) - dt/(2*dZ^2)*sd^2;
b = 1 + dt/dZ^2*sd^2 + r*dt;
c = -dt/(2*dZ)*(r-q-sd^2/2) - dt/(2*dZ^2)*sd^2;
for i = n-1:-1:0
    A = zeros([m-1 m-1]);
    B = zeros([m-1 1]);
    for j = 1:m-1
        if (j == 1)             % Z = Z_min at f(j-1).
            A(j,j:j+1) = [b c];
            B(j) = f(j,i+1) - a*f_Z0;
        elseif (j == m-1)       % Z = Z_max at f(j+1).
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
            f_i = bsxfun(@max, f_i, log(exp(Z_min+dZ:dZ:Z_max-dZ)' - X));
        else                    % Option is a put.
            f_i = bsxfun(@max, f_i, log(X - exp(Z_min+dZ:dZ:Z_max-dZ)'));
        end
    end
    if (i > 0)
        f(1:m-1,i) = f_i;
    else
        f_t0 = f_i;
    end
end
OptionValue = exp(f_t0(m/2));
OptionValue = exp(f_t0);
