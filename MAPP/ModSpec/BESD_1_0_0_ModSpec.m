function MOD = BESD_1_0_0_ModSpec()
    MOD = ee_model();
    MOD = add_to_ee_model(MOD, 'name', 'Berkeley ESD snapback model v1.0.0');
    MOD = add_to_ee_model(MOD, 'terminals', {'p', 'n'});
    MOD = add_to_ee_model(MOD, 'explicit_outs', {'ipn'});
    MOD = add_to_ee_model(MOD, 'internal_unks', {'s'});
    MOD = add_to_ee_model(MOD, 'implicit_eqn_names', {'ds'});
    MOD = add_to_ee_model(MOD, 'parms', {'Gon', 0.1, 'VH', 16, 'VT1', 48, 'VIH', 26});
    MOD = add_to_ee_model(MOD, 'parms', {'Is', 1e-12, 'VT', 0.026, 'VD', 0.7});
    MOD = add_to_ee_model(MOD, 'parms', {'K', 10, 'Alpha', 5, 'tau', 1e-8});
    MOD = add_to_ee_model(MOD, 'parms', {'C', 1e-12});
    MOD = add_to_ee_model(MOD, 'parms', {'maxslope', 1e15});
    MOD = add_to_ee_model(MOD, 'parms', {'smoothing', 1e-10});
    MOD = add_to_ee_model(MOD, 'fqei', {@fe, @qe, @fi, @qi});
    MOD = finish_ee_model(MOD);
end

function out = fe(S)
    v2struct(S);
    Ion = smoothclip(Gon*(vpn - VH), smoothing) - smoothclip(-Gon*VH, smoothing);
    Ioff = Is * (1 - safeexp(-vpn/VT, maxslope)) * sqrt(1 + max(vpn, 0)/VD);
    out = Ioff + s^Alpha * Ion; % ipn
end

function out = qe(S)
    v2struct(S);
    out = C * vpn;
end

function out = fi(S)
    v2struct(S);
    Vstar = 2*(vpn-0.5*VT1-0.5*VIH)/(VT1-VIH);
    sstar = 2*(s-0.5);
    ds = tanh(K*(Vstar + sstar)) - sstar;
    out = ds;
end

function out = qi(S)
    v2struct(S);
    out = -tau*s;
end
