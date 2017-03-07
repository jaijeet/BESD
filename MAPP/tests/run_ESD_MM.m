% ======================================================================
% run_ESD_MM.m
% ======================================================================
% MAPP script to test on the ESD clamp compact model (BESD_1_0_0_ModSpec.m)
% under Machine Mode condition.
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
DAE = MNA_EqnEngine(ESD_testbench_ckt(ESD_MOD, 'MM'));

% DC analysis
dcop = dot_op(DAE);
feval(dcop.print, dcop);

% run transient simulation
xinit = feval(dcop.getsolution, dcop);
tstart = 0; tstep = 2e-11; tstop = 700e-9;
tranObj = dot_transient(DAE, xinit, tstart, tstep, tstop);

% plot DAE outputs
feval(tranObj.plot, tranObj);
