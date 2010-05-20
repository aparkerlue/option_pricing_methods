%% Scratchwork.  Parameters yield option price of $4.28.
S = 50;
X = 50;
r = 0.10;                               % Annual.
T = 5 / 12;                             % Months.
sd = 0.40;                              % Annual.
q = 0;
fCallPut = 0;                           % fCallPut == 0 => put
fAmEur = 1;                             % fAmEur == 1 => american

fdi1(S, X, r, T, sd, fCallPut, fAmEur, q)
fdi2(S, X, r, T, sd, fCallPut, fAmEur, q)
fde1(S, X, r, T, sd, fCallPut, fAmEur, q)
fde2(S, X, r, T, sd, fCallPut, fAmEur, q)

%% Scratchwork.
S = 40;
X = 45;
r = 0.05;                               % Annual.
T = 7 / 12;                             % Months / 12.
sd = 0.30;                              % Annual.
q = 0.05;                               % Annual.
D = 0.50;                               % Quarterly.
fCallPut = 1;                           % fCallPut == 1 => call
fAmEur = 1;                             % fAmEur == 1 => american

n = struct('bin1', 140);
binom(S, X, r, T, sd, fCallPut, fAmEur, n.bin1, 0, D)

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
binom(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.bin, q)
fde1(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fde1, m.fde1, q)
fde2(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fd, m.fd, q)
fdi1(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fd, m.fd, q)
fdi2(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fd, m.fd, q)


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
