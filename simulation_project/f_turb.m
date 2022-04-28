% For turbulent strøm
% Basert på Newton, Arkimedes og Rayleigh
function dx = f_turb(t, x, v_vann, g, rho_v, rho_p, Cd, r) % t er et input fordi det kreves av ode45
    p_p = x(1:2); % Posisjon (blir ikke brukt i uttrykket)
    v_p = x(3:4); % Hastighet
    
    A = pi*(r)^2;    % "Areal"
    V = 4/3*pi*r^3;  % Volum
    
    m_p = rho_p*V; % Masse til pellet
    
    e_3 = [0; 1]; % Retningsvektor
    
    % Beregne krefter
    F_g = e_3.*m_p*g*(rho_v/rho_p - 1);
    F_d = Cd*A*(v_vann-v_p)/norm(v_vann-v_p)*norm(v_vann - v_p)^2;

    % Setting up ODE
    dp = v_p;
    dv = F_g/m_p + F_d/m_p;

    dx = [dp; dv];
end