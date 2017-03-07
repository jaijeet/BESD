% ======================================================================
% run_ESD_DC_AC_TRAN_homotopy.m
% ======================================================================
% MAPP script to test the ESD clamp compact model (BESD_1_0_0_ModSpec.m).
% The script first creates a circuit by connecting a BESD_1_0_0_ModSpec device
% in series with a voltage source, then runs DC operating point analysis, DC
% sweep, AC analysis, transient analysis and homotopy analysis on the circuit.
%
% Version: 1.0.0
% Tested on: MAPP-2017-02-15-release
%
% Author: Tianshi Wang [tianshi@berkeley.edu]
% Last Modified: Mar 5, 2017

if ~exist('ESD_MOD')
    ESD_MOD = BESD_1_0_0_ModSpec();
end

do_dc1 = 1;
do_dc2 = 1;
do_ac = 1;
do_tran = 1;
do_hom = 1;

% set up ckt
clear ckt;
ckt.cktname = 'ESD clamp test bench';
ckt.nodenames = {'1'};
ckt.groundnodename = '0';
tranfunc = @(t, args) args.offset+args.A*sawtooth(2*pi/args.T*t+args.phi, 0.5);
tranargs.offset = 30; tranargs.A = 30; tranargs.T = 1e-6; tranargs.phi=0;
ckt = add_element(ckt, vsrcModSpec(), 'V1', {'1', '0'}, {},...
     {{'DC', 30}, {'AC', 1}, {'TRAN', tranfunc, tranargs}});
ckt = add_element(ckt, ESD_MOD(), 'M1', {'1', '0'});

% set up DAE
DAE = MNA_EqnEngine(ckt);

% DC OP analysis
dcop = dot_op(DAE);
dcop.print(dcop);
dcSol = dcop.getSolution(dcop);
uDC = dcop.getDCinputs(dcop);

if do_dc1
    % forward DC sweep
    swp1 = dcsweep(DAE, [], 'V1:::E', 0:0.6:60);
    swp1.plot(swp1);
end

if do_dc2
    % backward DC sweep
    swp2 = dcsweep(DAE, [], 'V1:::E', 60:-0.6:0);
    swp2.plot(swp2);
end

if do_dc1 && do_dc2
    % plot forward and backward DC sweep results
    [pt1, sol1] = swp1.getSolution(swp1);
    [pt2, sol2] = swp2.getSolution(swp2);

    sidx = DAE.unkidx('M1:::s', DAE);
    figure;
    plot(pt1, sol1(3, :), '.-r');
    hold on;
    plot(pt2, sol2(3, :), '.-b');
    grid on; box on;
    xlabel('V (V)');
    ylabel('s');
    legend('forward DC sweep', 'backward DC sweep');

    Iidx = DAE.unkidx('V1:::ipn', DAE);
    figure;
    plot(pt1, -sol1(Iidx,:), '.-r');
    hold on;
    plot(pt2, -sol2(Iidx,:), '.-b');
    grid on; box on;
    set(gca, 'YScale', 'log');
    xlabel('V (V)');
    ylabel('I (A)');
    legend('forward DC sweep', 'backward DC sweep');
end

if do_ac
    % small-signal AC analysis
    sweeptype = 'DEC'; fstart = 1e3; fstop = 1e11; nsteps = 20;
    acObj = ac(DAE, dcSol, uDC, fstart, fstop, nsteps, sweeptype);
    feval(acObj.plot, acObj);
end

if do_tran
    % transient simulation, sweeping V1
    tstart = 0; tstep = 1e-9; tstop = 2e-6;
    xinit = 0*dcSol;
    LMSobj = dot_transient(DAE, xinit, tstart, tstep, tstop);
    LMSobj.plot(LMSobj);

    % get transient data, plot current in log scale
    [tpts, sols] = LMSobj.getSolution(LMSobj);
    Vidx = DAE.unkidx('e_1', DAE);
    Iidx = DAE.unkidx('V1:::ipn', DAE);
    figure; plot(sols(Vidx, :), -sols(Iidx, :), '.-');
    xlabel('V (V)'); ylabel('I (A)'); grid on;
end

if do_hom
    % homotopy analysis
    startLambda = 0; stopLambda = 60; lambdaStep = 1;
    hom = homotopy(DAE, 'V1:::E', 'input', [], startLambda, lambdaStep, stopLambda);
    hom.plot(hom);
    axis([0, 60, -5, 2]);
end
