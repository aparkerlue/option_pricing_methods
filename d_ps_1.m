%% Table 1.
S = 40;
X = [35 40 45];
r = 0.05;
T = [1 4 7] / 12;
sd = 0.30;
q = 0;
fCallPut = 1;                           % fCallPut == 1 => call
fAmEur = 1;                             % fAmEur == 1 => american

m = struct('fde1', 200, 'fd', 200);
price = zeros(5,3,3);
for i = 1:length(X)
    for j = 1:length(T)
        n = struct('bin', 300, 'fde1', 315*12*T(j), 'fd', 45*12*T(j));
        price(1,j,i) = binom(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.bin, q);
        price(2,j,i) = fde1(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fde1, m.fde1);
        price(3,j,i) = fde2(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fd, m.fd);
        price(4,j,i) = fdi1(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fd, m.fd);
        price(5,j,i) = fdi2(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fd, m.fd);
    end
end

%% Table 3.
S = 40;
X = [35 40 45];
r = 0.05;
T = [1 4 7] / 12;
sd = 0.30;
q = 0.05;
D = 0.50;
fCallPut = 1;                           % fCallPut == 1 => call
fAmEur = 1;                             % fAmEur == 1 => american

price = zeros(2,3,3);
price(1,1,1) = binom(S, X(1), r, T(1), sd, fCallPut, fAmEur, 140, 0, D);
price(2,1,1) = binom(S, X(1), r, T(1), sd, fCallPut, fAmEur, 140, q);
price(1,2,1) = binom(S, X(1), r, T(2), sd, fCallPut, fAmEur, 160, 0, D);
price(2,2,1) = binom(S, X(1), r, T(2), sd, fCallPut, fAmEur, 200, q);
price(1,3,1) = binom(S, X(1), r, T(3), sd, fCallPut, fAmEur, 140, 0, D);
price(2,3,1) = binom(S, X(1), r, T(3), sd, fCallPut, fAmEur, 210, q);
price(1,1,2) = binom(S, X(2), r, T(1), sd, fCallPut, fAmEur, 140, 0, D);
price(2,1,2) = binom(S, X(2), r, T(1), sd, fCallPut, fAmEur, 140, q);
price(1,2,2) = binom(S, X(2), r, T(2), sd, fCallPut, fAmEur, 160, 0, D);
price(2,2,2) = binom(S, X(2), r, T(2), sd, fCallPut, fAmEur, 200, q);
price(1,3,2) = binom(S, X(2), r, T(3), sd, fCallPut, fAmEur, 140, 0, D);
price(2,3,2) = binom(S, X(2), r, T(3), sd, fCallPut, fAmEur, 210, q);
price(1,1,3) = binom(S, X(3), r, T(1), sd, fCallPut, fAmEur, 140, 0, D);
price(2,1,3) = binom(S, X(3), r, T(1), sd, fCallPut, fAmEur, 140, q);
price(1,2,3) = binom(S, X(3), r, T(2), sd, fCallPut, fAmEur, 160, 0, D);
price(2,2,3) = binom(S, X(3), r, T(2), sd, fCallPut, fAmEur, 200, q);
price(1,3,3) = binom(S, X(3), r, T(3), sd, fCallPut, fAmEur, 140, 0, D);
price(2,3,3) = binom(S, X(3), r, T(3), sd, fCallPut, fAmEur, 210, q);

%% Table 4.
S = 40;
X = [35 40 45];
r = 0.05;
T = [1 4 7] / 12;
sd = 0.30;
q = [0.05 0.125 0.25 0.30 0.40];
D = [0.50 1 2 3 4];
fCallPut = 1;                           % fCallPut == 1 => call
fAmEur = 1;                             % fAmEur == 1 => american
n = 500;

bfcd = zeros(3,5,3);
for i = 1:length(X)
    for j = 1:length(T)
        for k = 1:length(D)
            bfcd(j,k,i) = binom(S, X(i), r, T(j), sd, fCallPut, ...
                                fAmEur, 140, 0, D(k));
        end
    end
end

bfdy = zeros(3,5,3);
for i = 1:length(X)
    for j = 1:length(T)
        for k = 1:length(D)
            bfdy(j,k,i) = binom(S, X(i), r, T(j), sd, fCallPut, ...
                                fAmEur, 140, q(k));
        end
    end
end

%% Table 5.
S = 40;
X = [35 40 45];
r = 0.05;
T = [1 4 7] / 12;
sd = 0.30;
q = 0;
fCallPut = 0;                           % fCallPut == 0 => put
fAmEur = 1;                             % fAmEur == 1 => american

m = struct('fd', 200);
price = zeros(4,3,3);
for i = 1:length(X)
    for j = 1:length(T)
        n = struct('bin', 150, 'fd', 45*12*T(j));
        price(1,j,i) = binom(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.bin, q);
        price(2,j,i) = fde2(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fd, m.fd);
        price(3,j,i) = fdi1(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fd, m.fd);
        price(4,j,i) = fdi2(S, X(i), r, T(j), sd, fCallPut, fAmEur, n.fd, m.fd);
    end
end

%% Table 6.
S = 40;
X = [35 40 45];
r = 0.05;
T = [1 4 7] / 12;
sd = 0.30;
q = 0.05;
D = 0.50;
fCallPut = 0;                           % fCallPut == 0 => put
fAmEur = 1;                             % fAmEur == 1 => american

price = zeros(2,3,3);
for i = 1:length(X)
    for j = 1:length(T)
        price(1,j,i) = binom(S, X(i), r, T(j), sd, fCallPut, fAmEur, 150, 0, D);
        price(2,j,i) = binom(S, X(i), r, T(j), sd, fCallPut, fAmEur, 150, q);
    end
end
