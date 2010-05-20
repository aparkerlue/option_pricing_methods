function [opt] = fde2(S, X, r, T, sd, fCallPut, fAmEur, n, m)
%FDE2 Log transform explicit finite difference option pricing method.
%   [OPT] = FDE2() prices an option using an explicit finite
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
  case 0                                % put
    f(g2m(n),:) = max(X - exp(Z_seq), 0);
  otherwise
    error('Unrecognized option type flag: %d.', fCallPut);
end

a = (1 + r*dt)^-1 * (-dt/(2*dZ)*(r - 1/2*sd^2) + dt/(2*dZ^2)*sd^2);
b = (1 + r*dt)^-1 * (1 - dt/dZ^2*sd^2);
c = (1 + r*dt)^-1 * (dt/(2*dZ)*(r - 1/2*sd^2) + dt/(2*dZ^2)*sd^2);
for i = g2m(n-1:-1:0)                   % Iterate from end to beginning.
    j_seq = repmat(g2m(0:2), [1 m-1]) + kron(0:m-2, ones([1 3]));
    f(i,g2m(1:m-1)) = reshape(f(i+1,j_seq), [3 m-1])' * [a b c]';

    if fCallPut == 1                    % m: ∂C/∂S ≈ 1
        f(i,g2m(m)) = f(i,g2m(m-1)) + exp(Z_seq(g2m(m))) -  exp(Z_seq(g2m(m-1)));
        f(i,g2m(0)) = f(i,g2m(1));      % 0: ∂C/∂S ≈ 0
    elseif fCallPut == 0                % m: ∂C/∂S ≈ 0
        f(i,g2m(m)) = f(i,g2m(m-1));    % 0: ∂C/∂S ≈ 1
        f(i,g2m(0)) = f(i,g2m(1)) - (exp(Z_seq(g2m(m))) - exp(Z_seq(g2m(m-1))));
        if fAmEur == 1, f(i,:) = max(f(i,:), X - exp(Z_seq)); end
    end
end

opt = f(g2m(0),g2m(m/2));
