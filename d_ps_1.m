%% Scratchwork.  Parameters yield option price of $4.28.
S = 50;
X = 50;
r = 0.10;                               % Annual.
T = 5 / 12;                             % Months.
sd = 0.40;                              % Annual.
q = 0;
fCallPut = 0;                           % fCallPut == 0 => put
fAmEur = 1;                             % fAmEur == 1 => american

%n = 1000;
%binom(S, X, r, T, sd, fCallPut, fAmEur, n)

fdi1(S, X, r, T, sd, q, fCallPut, fAmEur)
fdi2(S, X, r, T, sd, q, fCallPut, fAmEur)
fde1(S, X, r, T, sd, q, fCallPut, fAmEur)
fde2(S, X, r, T, sd, q, fCallPut, fAmEur)


%% FDI2 development.
n = ceil(1e3*T);
m = 2*ceil(sqrt(3*n));

dt = T / n;
m = m + mod(m,2);                       % Ensure that m is even.
Z_lim = log(S) + 3*sd*sqrt(T)*[-1 1];
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


%% Following code not vetted.

D = [ 0.50 1.00 2.00 3.00 4.00 ];

%% Table 1.
n = 300;
X = 35; t = 1/12;
binom(S, X, r, t, t/n, sd)

%%
S = 40;
X = 35;
r = 0.05;
sd = 0.30;
T = 1/12;
q = 0;
n = 300;
fCP = 1;
fAE = 1;
for X = [35 40 45]
    for T = [1/12 4/12 7/12]
        binom(S, X, r, sd, T, n, fCP, fAE)
    end
end
