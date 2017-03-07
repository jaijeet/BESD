% ======================================================================
% run_ESD_TLP_DC_TRAN_homotopy.m
% ======================================================================
% MAPP script to test the ESD clamp compact model (BESD_1_0_0_ModSpec.m).
% The script first creates a simplified equivalent circuit for transmission
% line pulse measurement of a BESD_1_0_0_ModSpec device, where the device is
% connected in series with a voltage source and a 50Ohm resistor. Then the
% script runs DC operating point analysis, DC sweep, transient analysis and
% homotopy analysis on the circuit.  %
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
do_tran = 1;
do_hom = 0; % takes about 10min

% set up ckt
clear ckt;
ckt.cktname = 'ESD TLP test bench: simplified equivalent circuit';
ckt.nodenames = {'1', '2'};
ckt.groundnodename = '0';

tranargs.A = 50; tranargs.td = 10e-9; tranargs.thi = 10.1e-9;
tranargs.tfs = 30e-9; tranargs.tfe = 30.1e-9;
tranfunc = @(t, args) args.A * pulse(t, args.td, args.thi, args.tfs, args.tfe);

ckt = add_element(ckt, vsrcModSpec(), 'V1', ...
   {'1', '0'}, {}, {{'DC', 200}, {'TRAN', tranfunc, tranargs}});
ckt = add_element(ckt, resModSpec(), 'R1', {'1', '2'}, 50);
ckt = add_element(ckt, ESD_MOD(), 'M1', {'2', '0'}, {{'K', 5}});
% Note: K is lowered to 5 for better convergence in DC sweep

% set up DAE
DAE = MNA_EqnEngine(ckt);

% DC OP analysis
dcop = dot_op(DAE);
dcop.print(dcop); dcSol = dcop.getSolution(dcop);

if do_dc1
    % forward DC sweep
    swp1 = dcsweep(DAE, [], 'V1:::E', [0:0.5:200]);
    swp1.plot(swp1);
end

if do_dc2
    % backward DC sweep
    swp2 = dcsweep(DAE, [], 'V1:::E', 200:-0.5:0);
    swp2.plot(swp2);
end

if do_dc1 && do_dc2
    % plot forward and backward DC sweep results
    [pt1, sol1] = swp1.getSolution(swp1);
    [pt2, sol2] = swp2.getSolution(swp2);

    Vidx = DAE.unkidx('e_2', DAE);
    sidx = DAE.unkidx('M1:::s', DAE);
    figure;
    plot(sol1(Vidx, :), sol1(sidx, :), '.-r');
    hold on;
    plot(sol2(Vidx, :), sol2(sidx, :), '.-b');
    grid on; box on;
    xlabel('V(2) (V)');
    ylabel('s');
    legend('forward DC sweep', 'backward DC sweep');

    Iidx = DAE.unkidx('V1:::ipn', DAE);
    figure;
    plot(sol1(Vidx, :), -sol1(Iidx,:), '.-r');
    hold on;
    plot(sol2(Vidx, :), -sol2(Iidx,:), '.-b');
    grid on; box on;
    xlabel('V(2) (V)');
    ylabel('I (A)');
    legend('forward DC sweep', 'backward DC sweep');
end

if do_tran
    % transient simulation, sweep V1
    tstart = 0; tstep = 1e-11; tstop = 50e-9;
    tranObj = dot_transient(DAE, [], tstart, tstep, tstop);
    tranObj.plot(tranObj);
end

if do_hom
    % homotopy analysis
    startLambda = 0; stopLambda = 200; lambdaStep = 1;
    startLambda = 200; stopLambda = 0; lambdaStep = -1;
    hom = homotopy(DAE, 'V1:::E', 'input', dcSol, startLambda, lambdaStep, stopLambda);
    hom.plot(hom);

    sol = hom.getsolution(hom);
    Vidx = DAE.unkidx('e_2', DAE);
    Iidx = DAE.unkidx('V1:::ipn', DAE);
    figure;
    plot(sol.yvals(Vidx, :), -sol.yvals(Iidx,:), '.-k');
    grid on; box on; axis tight;
    xlabel('V(2) (V)');
    ylabel('I (A)');
    % set(gca, 'YScale', 'log');
end
