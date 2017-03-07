% ======================================================================
% ESD_model_exerciser.m
% ======================================================================
% MAPP script to run model exerciser on the ESD clamp compact model
% (BESD_1_0_0_ModSpec.m)
%
% Version: 1.0.0
% Tested on: MAPP-2017-02-15-release
%
% Author: Tianshi Wang [tianshi@berkeley.edu]
% Last Modified: Mar 5, 2017

MOD = BESD_1_0_0_ModSpec;
MEO = model_exerciser(MOD);
% plot on-state current
vpn = 0:0.5:70; s = 1;
MEO.plot('ipn_fe', vpn, s, MEO);
% plot off-state current
vpn = 0:0.5:70; s = 0;
MEO.plot('ipn_fe', vpn, s, MEO);
% plot d/dt s = f(V, s)
vpn = 0:0.5:70; s =0:0.05:1;
MEO.plot('ds_fi', vpn, s, MEO);
