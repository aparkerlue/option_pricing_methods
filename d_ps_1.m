%% MGMT 237d, Homework 1.
S = 40;
X = [ 35 40 45 ]';
r = 0.05;			% Annual.
sd = 0.3;			% Annual.
t = [ 1 4 7 ]';			% Months.
D = [ 0.50 1.00 2.00 3.00 4.00 ];

%% Table 1.
n = 300;
X = 35; t = 1/12;
binom(S, X, r, t, t/n, sd)

%%
S = 50;
X = 50;
r = 0.10;
sd = 0.40;
T = 5/12;
q = 0;
m = 20;
n = 10;
dS = 5;
fCP = 0;
fAE = 1;
fdi1(S, X, r, sd, T, q, m, n, dS, fCP, fAE)
