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