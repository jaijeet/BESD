function cktnetlist = ESD_testbench_ckt(ESD_MOD, HBM_or_MM_or_CDM)
%function cktnetlist = ESD_testbench_ckt(ESD_MOD, HBM_or_MM_or_CDM)
%This function returns a cktnetlist structure describing a test bench circuit
%for ESD protection devices. The test bench can be configured for Human Body
%Mode (HBM), Machine Mode (MM) or Charged Device Mode (CDM) test.
%
%The first input to this function is the ModSpec model of the ESD protection
%device.
%
%The second input to this function is a string variable named HBM_or_MM_or_CDM.
%It can have one of the three values: 'HBM', 'MM' or 'CDM'. If not specified,
%it's default value is 'HBM'.
%
%The circuit is a series connection of V1, C1, R1, L1 with device under test
%(DUT), which is BESD_1_0_0_ModSpec device(s) in parallel with a 500Ohm
%resistor load.
%The parameters for C1, R1, L1 as well as the input waveform of V1, depend on
%the type of test bench: HBM_or_MM_or_CDM.
%
% - 'HBM': C1 is 100p, R1=1.5k, L1 is 1u. In transient simulation, V1 is a 2kV
%          pulse. Only one BESD_1_0_0_ModSpec device is connected between node 4
%          and ground.
% - 'MM':  C1 is 200p, R1=5, L1 is 0.5u. In transient simulation, V1 is a 200V
%          pulse. Two BESD_1_0_0_ModSpec devices are connected back to back in
%          series between node 4 and ground, i.e., one is between 5 and 4, the
%          other 5 and ground.
% - 'CDM': C1 is 2.5p, R1=30, L1 is 20n. In transient simulation, V1 is a 500V
%          pulse. Two BESD_1_0_0_ModSpec devices are connected back to back in
%          series between node 4 and ground, i.e., one is between 5 and 4, the
%          other 5 and ground.
%
%See also
%--------
%
% add_element, add_output, MAPPcktnetlists, cktnetlist_lowlevel,
% BESD_1_0_0_ModSpec, resModSpec, vsrcModSpec, capModSpec, indModSpec,

%
%Author: Tianshi Wang, 2017/03/05
%

    if nargin < 1
        HBM_or_MM_or_CDM = 'HBM';
        warning('ESD_testbench_ckt: test bench type set to default (HBM).');
    end

    if strcmp(HBM_or_MM_or_CDM, 'HBM')
        C = 100e-12;
        R = 1.5e3;
        L = 1e-6;
        tranargs.A = 2000; tranargs.td = 10e-9; tranargs.thi = 10.1e-9;
        tranargs.tfs = 500e-9; tranargs.tfe = 500.1e-9;
    elseif strcmp(HBM_or_MM_or_CDM, 'MM')
        C = 200e-12;
        R = 5;
        L = 0.5e-6;
        tranargs.A = 200; tranargs.td = 10e-9; tranargs.thi = 10.1e-9;
        tranargs.tfs = 500e-9; tranargs.tfe = 500.1e-9;
    elseif strcmp(HBM_or_MM_or_CDM, 'CDM')
        C = 2.5e-12;
        R = 30;
        L = 20e-9;
        tranargs.A = 500; tranargs.td = 10e-9; tranargs.thi = 10.1e-9;
        tranargs.tfs = 30e-9; tranargs.tfe = 30.1e-9;
    else
        error('ESD_testbench_ckt: invalid test bench type. Input has to be ''HBM'', ''MM'' or ''CDM''.');
    end

    % ckt name
    cktnetlist.cktname = sprintf('ESD protection device %s test bench', HBM_or_MM_or_CDM);

    % nodes (names)
    if strcmp(HBM_or_MM_or_CDM, 'HBM')
        cktnetlist.nodenames = {'1', '2', '3', '4'};
    else % if MM or CDM
        cktnetlist.nodenames = {'1', '2', '3', '4', '5'};
    end
    cktnetlist.groundnodename = '0';

    % elements
    cktnetlist = add_element(cktnetlist, capModSpec, 'C1', {'1', '2'}, C);
    cktnetlist = add_element(cktnetlist, resModSpec, 'R1', {'2', '3'}, R);
    cktnetlist = add_element(cktnetlist, indModSpec, 'L1', {'3', '4'}, L);

    if strcmp(HBM_or_MM_or_CDM, 'HBM')
        cktnetlist = add_element(cktnetlist, ESD_MOD, 'M1', {'4', '0'});
    else % if MM or CDM
        cktnetlist = add_element(cktnetlist, ESD_MOD, 'M1', {'5', '4'});
        cktnetlist = add_element(cktnetlist, ESD_MOD, 'M2', {'5', '0'});
    end

    cktnetlist = add_element(cktnetlist, resModSpec, 'RL', {'4', '0'}, 500);

    tranfunc = @(t, args) args.A * pulse(t, args.td, args.thi, args.tfs, args.tfe);
    cktnetlist = add_element(cktnetlist,  vsrcModSpec, 'V1', ...
              {'1', '0'}, {}, {{'E', {'dc', 0}, {'tran', tranfunc, tranargs}}});

    % outputs
    cktnetlist = add_output(cktnetlist, 'e(4)', [], 'vout'); % node voltage
                                              % of '4', with output name vout
    cktnetlist = add_output(cktnetlist, 'i(V1)', 100);
                                        % current through V1, scaled by 100
end
