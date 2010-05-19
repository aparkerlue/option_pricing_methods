function [opt] = fdi2(S, X, r, T, sd, q, fCallPut, fAmEur, n, m)
%FDI2 Log transform implicit finite difference option pricing method.
%   [OPT] = FDI2() prices an option using an implicit finite
%   difference method with a log-transformed spatial variable.

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

dt = T / n;
m = m + mod(m,2);                       % Ensure that m is even.
Z_lim=log(S)+m*sd*sqrt(3*dt/2)*[-1 1];  % Ensure that dZ >= sd*sqrt(3*dt).
dZ = diff(Z_lim) / m;
Z_seq = Z_lim(1) + (0:m)*dZ;            % vector of m + 1 elements

f = zeros([n+1 m+1]);
switch fCallPut
  case 1                                % call
    f(g2m(n),:) = max(exp(Z_seq) - X, 0);
    f(:,g2m(m)) = exp(Z_seq(g2m(m))) - X;
    f(:,g2m(0)) = 0;
  case 0                                % put
    f(g2m(n),:) = max(X - exp(Z_seq), 0);
    f(:,g2m(m)) = 0;
    f(:,g2m(0)) = X - exp(Z_seq(g2m(0)));
  otherwise
    error('Unrecognized option type flag: %d.', fCallPut);
end

a = dt/(2*dZ)*(r - 1/2*sd^2) - dt/(2*dZ^2)*sd^2;
b = 1 + dt/dZ^2*sd^2 + r*dt;
c = -dt/(2*dZ)*(r - 1/2*sd^2) - dt/(2*dZ^2)*sd^2;
for i = g2m(n-1:-1:0)                   % Iterate from end to beginning.
    A = zeros(m-1);
    B = f(i+1,g2m(1:m-1))';
    for j = 1:m-1
        if j <= 1, A(j,1:2) = [b c]; B(1) = B(1) - a*f(i,g2m(0));
        elseif j < m-1, A(j,j-1:j+1) = [a b c];
        else A(j,m-2:m-1) = [a b]; B(m-1) = B(m-1) - c*f(i,g2m(m));
        end
    end
    f(i,g2m(1:m-1)) = linsolve(A,B);
    if fCallPut == 0 && fAmEur == 1
        f(i,:) = max(f(i,:), X - exp(Z_seq));
    end
end

opt = f(g2m(0),g2m(m/2));
