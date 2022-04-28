% For laminær strøm
% Basert på Newton of Stokes lov
function dx = f_lam(t, x, v_vann, g, rho_v, rho_p, mu, r) 
    p_p = x(1:2); % Posisjon (blir ikke brukt i uttrykket)
    v_p = x(3:4); % Hastighet
    
    V = 4/3*pi*r^3;  % Volum
    
    m_p = rho_p*V; % Masse til pellet
    
    e_3 = [0; 1]; % Retningsvektor
    
    % Beregne krefter
    F_g = e_3.*m_p*g*(rho_v/rho_p - 1);
    F_d = (6*pi*mu*r*(v_vann-v_p));
    
    % Setting up ODE
    dp = v_p;
    dv = F_g/m_p + F_d/m_p;

    dx = [dp; dv];
end