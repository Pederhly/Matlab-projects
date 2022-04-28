clear;
clc;

%% Oppsett
% Parametere
rho_p = 1004;       % Tetthet pellet
rho_v = 998;        % Tetthet vann
r = 0.01;           % Radius pellet
mu = 1e-3;          % Dynamisk viskositet vann (bare for stokes løsning)
Cd = 0.38;          % Drag coefficient pellet (Endrer seg med Re og formen på pelleten)
g = 9.81;           
v_vann = [1; 0];    % Hastighet på vannet

%% Simulering
% Initialbetingelser
p_p0 = [0; 0];
v_p0 = [-0.1; 0];

% Start og sluttid for simuleringen
tspan = [0, 5];

% Simulerer systemet
[t_turb, x_turb] = ode45(@(t, x) f_turb(t, x, v_vann, g, rho_v, rho_p, Cd, r) , tspan, [p_p0;v_p0]);
[t_lam, x_lam] = ode45(@(t, x) f_lam(t, x, v_vann, g, rho_v, rho_p, mu, r) , tspan, [p_p0;v_p0]);

%% Resmpling (for å få samme avstand i tid mellom punkter)
n = 20; % Antall punkter som vises
t_turb_rs = linspace(tspan(1),tspan(2),n);
x_turb_rs = interp1(t_turb,x_turb,t_turb_rs);

t_lam_rs = linspace(tspan(1),tspan(2),n);
x_lam_rs = interp1(t_lam,x_lam,t_lam_rs);

%% Plotting
figure(1);
clf;
hold on;

plot(x_turb_rs(:,1),x_turb_rs(:,2), 'bo', 'handlevisibility', 'off')
plot(x_turb_rs(:,1),x_turb_rs(:,2), 'b', 'displayname','Turbulent')

plot(x_lam_rs(:,1),x_lam_rs(:,2), 'ro', 'handlevisibility', 'off')
plot(x_lam_rs(:,1),x_lam_rs(:,2), 'r', 'displayname','Laminar')

plot([-1,1], [0, 0], 'black', 'displayname', 'Surface')

xlim([-0.6, 0.8])
ylim([-1, 0.2])

title('Position of pellet')
xlabel('$x$','interpreter', 'latex')
ylabel('$y$','interpreter', 'latex')
grid on;
axis equal;
legend('location','southwest');

%% Løser problemet symbolsk
syms x(t) y(t) t % Definerer hvilke variabler vi har
p_p = [x;y];            % Posisjon av pellet
v_p = diff(p_p,t);      % Hastighet --
a_p = diff(p_p,t,2);    % Akselerasjon --

temp = sym('temp', [4, 1]);

% Setter opp symbolsk ODE
sys = f_lam(t, temp, v_vann, g, rho_v, rho_p, mu, r);
sys = sys(3:4);
sys = subs(sys, temp, [p_p; v_p]);
ode = a_p == sys;

% Startbetingelser for å løse ODEen
init_cond_p = p_p(0) == p_p0;
init_cond_v = v_p(0) == v_p0;
init_conds = [init_cond_p, init_cond_v];

% Løser ODEen
sol = dsolve(ode,init_conds);

% pretty(sol.x)
% pretty(sol.y)

% Gjør om til en funksjon som vi kan bruke
compute_position = matlabFunction([sol.x;sol.y]);

% Plotte resultatet
t = tspan(1):0.1:tspan(2);
pos = compute_position(t);

figure(2);
clf;
hold on;

plot(x_turb_rs(:,1),x_turb_rs(:,2), 'bo', 'handlevisibility', 'off')
plot(x_turb_rs(:,1),x_turb_rs(:,2), 'b', 'displayname','Turbulent')

plot(x_lam_rs(:,1),x_lam_rs(:,2), 'ro', 'handlevisibility', 'off')
plot(x_lam_rs(:,1),x_lam_rs(:,2), 'r', 'displayname','Laminar')

plot(pos(1,:),pos(2,:), 'g--', 'displayname','Laminar symbolic solution')

plot([-1,1], [0, 0], 'black', 'displayname', 'Surface')

xlim([-0.6, 0.8])
ylim([-1, 0.2])

title('Position of pellet')
xlabel('$x$','interpreter', 'latex')
ylabel('$y$','interpreter', 'latex')
grid on;
axis equal;
legend('location','southwest');
