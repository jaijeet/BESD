% ======================================================================
% run_ESD_CDM.m
% ======================================================================
% MAPP script to test on the ESD clamp compact model (BESD_1_0_0_ModSpec.m)
% under Charged Device Mode condition.
%
% Version: 1.0.0
% Tested on: MAPP-2017-02-15-release
%
% Author: Tianshi Wang [tianshi@berkeley.edu]
% Last Modified: Mar 5, 2017

if ~exist('ESD_MOD')
    ESD_MOD = BESD_1_0_0_ModSpec();
end

% set up DAE
DAE = MNA_EqnEngine(ESD_testbench_ckt(ESD_MOD, 'CDM'));

% DC analysis
dcop = dot_op(DAE);
feval(dcop.print, dcop);

% run transient simulation
xinit = feval(dcop.getsolution, dcop);
tstart = 0; tstep = 1e-11; tstop = 50e-9;
tranObj = dot_transient(DAE, xinit, tstart, tstep, tstop);

% plot DAE outputs
feval(tranObj.plot, tranObj);

% plot DAE outputs and zoom in
feval(tranObj.plot, tranObj);
axis([0.9e-8 1.5e-8 -300 500]);
