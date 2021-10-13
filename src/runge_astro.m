function f = runge_astro(t, X, I_neuro, sum_Ca, sum_IP3)
%% Ullah model
params = model_parameters();
c0 = 2.0; c1 = 0.185;
v1 = 6.0; v2 = 0.11; v3 = 2.2; v4 = 0.3; v6 = 0.2;
k1 = 0.5; k2 = 1.0; k3 = 0.1; k4 = 1.1;
d1 = 0.13; d2 = 1.049; d3 = 0.9434; d5 = 0.082;
IP3s = 0.16;
Tr = 0.14;
a = 0.8; a2 = 0.14;
M = X(3) / (X(3) + d1);
NM = X(1) / (X(1) + d5);
Ier = c1 * v1 * (M ^ 3) * (NM ^ 3) * (X(2) ^ 3) * (((c0 - X(1)) / c1) - X(1));
Ileak = c1 * v2 * (((c0 - X(1)) / c1) - X(1));
Ipump = v3 * (X(1) ^ 2) / (X(1) ^ 2 + k3 ^ 2);
Iin = v6 * (X(3) ^ 2 / (k2 ^ 2 + X(3) ^ 2));
Iout = k1 * X(1);
Q2 = d2 * ((X(3) + d1) / (X(3) + d3));
h = Q2 / (Q2 + X(1));
Tn = 1.0 / (a2 * (Q2 + X(1)));
Iplc = v4 * ((X(1) + (1.0 - a) * k4) / (X(1) + k4));
f(1) = Ier - Ipump + Ileak + Iin - Iout + params.dCa .* sum_Ca;
f(2) = (h - X(2)) / Tn;
f(3) = (IP3s - X(3)) * Tr + Iplc + I_neuro + + params.dIP3 .* sum_IP3;
f = f';
end