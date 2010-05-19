%% Scratchwork.  Parameters yield option price of $4.28.
S = 50;
X = 50;
r = 0.10;                               % Annual.
T = 5 / 12;                             % Months.
sd = 0.40;                              % Annual.
q = 0;
fCallPut = 0;                           % fCallPut == 0 => put
fAmEur = 1;                             % fAmEur == 1 => american

fdi1(S, X, r, T, sd, q, fCallPut, fAmEur)
fdi2(S, X, r, T, sd, q, fCallPut, fAmEur)
fde1(S, X, r, T, sd, q, fCallPut, fAmEur)
fde2(S, X, r, T, sd, q, fCallPut, fAmEur)

%% Table 1.
S = 40;
X = [35 40 45];
r = 0.05;
T = [1 4 7] / 12;
sd = 0.30;
q = 0;
fCallPut = 1;                           % fCallPut == 1 => call
fAmEur = 1;                             % fAmEur == 1 => american

i = 1; j = 1;
n = struct('bin', 300, 'fde1', 315*12*T(j), 'fd', 45*12*T(j));
m = struct('fde1', 200, 'fd', 200);
binom(S, X(i), r, T(j), sd, q, fCallPut, fAmEur, n.bin)
fde1(S, X(i), r, T(j), sd, q, fCallPut, fAmEur, n.fde1, m.fde1)
fde2(S, X(i), r, T(j), sd, q, fCallPut, fAmEur, n.fd, m.fd)
fdi1(S, X(i), r, T(j), sd, q, fCallPut, fAmEur, n.fd, m.fd)
fdi2(S, X(i), r, T(j), sd, q, fCallPut, fAmEur, n.fd, m.fd)


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
