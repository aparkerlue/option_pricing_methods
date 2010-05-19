%% Scratchwork.  Parameters yield option price of $4.28.
S = 50;
X = 50;
r = 0.10;                               % Annual.
T = 5 / 12;                             % Months.
sd = 0.40;                              % Annual.
q = 0;
fCP = 0;                                % fCP == 0 => put
fAE = 1;                                % fAE == 1 => american

n = 1000;
binom(S, X, r, T, sd, fCP, fAE, n)

%fdi1(S, X, r, T, sd, q, fCP, fAE, m, n)

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
