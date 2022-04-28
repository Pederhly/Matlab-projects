clear;
clc;

%% Task a)

% Define variables
n_a = 1;
n_w = 1.33;
d_g = 0.04;

% Read data
M_a = csvread("a.csv", 1, 0);
x_a = M_a(:,1);
y_a = M_a(:,2);
tetha_a = M_a(:,3);

% Calc y
y_calc = calc_y(tetha_a, x_a, d_g, n_a, n_w);

% Plot and compare
plot(y_a);
hold on
plot(y_calc, '--', 'LineWidth', 1.5);

