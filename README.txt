BESD v1.0.0
===========
Released on March 4, 2017

0. Read the license terms in License.txt.

   Information about the basic operation of the device, the design of the
   model, model parameters and test bench results are documented in
   BESD_v1_0_0_manual.pdf.

1. Files in the release package:

├── README.txt
├── License.txt
├── BESD_v1_0_0_manual.pdf
├── MAPP
│   ├── ModSpec
│   │   ├── BESD_1_0_0_ModSpec.m           (BESD v1.0.0 ModSpec model)
│   │   └── BESD_1_0_0_ModSpec_VAPP.m      (ModSpec model translated from BESD_1_0_0.va)
│   └── tests
│       ├── ESD_model_exerciser.m          (plot Ion, Ioff, d/dt s with model exerciser)
│       ├── ESD_testbench_ckt.m            (circuit in MAPP for HBM, MM, CDM tests)
│       ├── run_ESD_CDM.m                  (run CDM test)
│       ├── run_ESD_DC_AC_TRAN_homotopy.m  (run DC/AC/tran/homotopy on a simple circuit)
│       ├── run_ESD_HBM.m                  (run HBM test)
│       ├── run_ESD_MM.m                   (run MM test)
│       └── run_ESD_TLP_equiv_DC_tran_homotopy.m (run analyses on TLP equivalent circuit)
└── Verilog-A
    ├── models
    │   ├── ESD_1_0_0.va        (BESD v1.0.0 Verilog-A model)
    │   └── smoothfunctions.va  (smooth function definitions)
    ├── HSPICE-tests
    │   ├── ESD_CDM.sp          (run CDM test in HSPICE)
    │   ├── ESD_DC_AC_TRAN.sp   (run DC/AC/tran on a simple circuit in HSPICE)
    │   ├── ESD_HBM.sp          (run HBM test in HSPICE)
    │   ├── ESD_MM.sp           (run MM test in HSPICE)
    │   └── ESD_TLP_equiv.sp    (run analyses on TLP equivalent circuit in HSPICE)
    └── Spectre-tests
        ├── ESD_CDM.scs         (run CDM test in Spectre)
        ├── ESD_DC_AC_TRAN.scs  (run DC/AC/tran on a simple circuit in Spectre)
        ├── ESD_HBM.scs         (run HBM test in Spectre)
        ├── ESD_MM.scs          (run MM test in Spectre)
        └── ESD_TLP_equiv.scs   (run analyses on TLP equivalent circuit in Spectre)

2. How to use the ModSpec/MATLAB model:

  2.1: Get MAPP by visiting the following github page:

        https://github.com/jaijeet/MAPP

    You can either clone or download the MAPP repository. Then follow the
    instructions on the github page to install MAPP.

    To quickly check the correctness of the installation, run the following
    command at the MATLAB prompt:

         >> MAPPtest_quick()

    This will run several tests on simple devices and circuits in MAPP. It
    should tell you that all tests have passed.

  2.2: Add the directories with the ModSpec model and test scripts to MATLAB's
    paths.
    At the MATLAB prompt, run:

         >> addpath where-the-release-package-is/MAPP/ModSpec/
         >> addpath where-the-release-package-is/MAPP/tests/

  2.3: Test the model on test bench circuits.
    There are several scripts you can run at the MATLAB prompt:

         >> ESD_model_exerciser;          % run model exerciser
         >> run_ESD_DC_AC_TRAN_homotopy;  % run DC/AC/tran/homotopy on a simple circuit
         >> run_ESD_HBM;                  % run HBM test
         >> run_ESD_MM;                   % run MM test
         >> run_ESD_CDM;                  % run CDM test
         >> run_ESD_TLP_equiv_DC_tran_homotopy; % run TLP equivalent circuit

    They should generate results that are consistent with those documented in
    the model manual: BESD_v1_0_0_manual.pdf.

3. How to use the Verilog-A model with VAPP and MAPP:

  3.1: Get VAPP by visiting the following github page:

        https://github.com/jaijeet/VAPP

    You can either clone or download the VAPP repository. Then follow the
    instructions on the github page to install VAPP. Don't forget to run
    start_VAPP in MATLAB after installation.

  3.2: Change directory (cd) into
    where-the-release-package-is/Verilog-A/models

    At MATLAB prompt, run:

         >> va2modspec('BESD_1_0_0.va');
    
    It will generates BESD_1_0_0.m under your current directory. You can use
    this file to create a ModSpec MATLAB model by running:

         >> ESD_MOD = BESD_1_0_0();
       
    Note that using the name "ESD_MOD" for the model is required. Otherwise the
    test scripts won't use this VAPP-translated model automatically.

    Using ESD_MOD, you can rerun the test circuits by cutting and pasting
    (without ">>") any of the following line to MATLAB's command window:

         >> run_ESD_DC_AC_TRAN_homotopy;  % run DC/AC/tran/homotopy on a simple circuit
         >> run_ESD_HBM;                  % run HBM test
         >> run_ESD_MM;                   % run MM test
         >> run_ESD_CDM;                  % run CDM test

    They will now run with the VAPP-translated model. The results should be
    identical to those generated from BESD_1_0_1_ModSpec model in section 2 of
    this README file.

    Apart from the test scripts above, two more scripts require one-line
    changes to run with the VAPP-translated model, because VAPP has its own
    naming convention for variables and parameters.

    For ESD_model_exerciser.m, you have to change the function name MEO.ds_fi
    to MEO.KCLForI_nsn_fi. Then you can cut and paster:

         >> ESD_model_exerciser;

    For run_ESD_TLP_equiv_DC_tran_homotopy.m, you have to modify the
    add_element line for ESD_MOD (around line 39) and change parameter name
    from 'K' to 'parm_K'. Then you can cut and paster:

         >> run_ESD_TLP_equiv_DC_tran_homotopy;

4. How to use the Verilog-A model with Spectre and HSPICE:

  4.1: If you don't have Spectre or HSPICE installed locally, copy the release
    directory to a machine where you have access to Spectre or HSPICE.

  4.2: Change directory (cd) into
    where-the-release-package-is/Verilog-A/Spectre-tests
    or where-the-release-package-is/Verilog-A/HSPICE-tests.

  4.3: Run Spectre on the circuits under Spectre-tests/. For example:

        $ spectre ESD_HBM.scs

    Or run HSPICE on the circuits under HSPICE-tests/. For example:

        $ hspice ESD_HBM.sp

    Note that both Spectre and HSPICE scripts assume that the BESD model is in
    ../models/. If you have changed the directory structure of the release
    package, you may need to change the "ahdl_include" lines in Spectre
    circuits, or the ".hdl" lines in HSPICE circuits.

  4.4: Open a waveform viewer and look at the simulation results. Depending on
    your installation of Cadence and Synopsys tools, there are many waveform
    viewers available, such as ViVa, WaveView, AvanWaves, etc. There are also
    open-source options like Gwave.

    For the circuits of HBM, MM, CDM tests in Spectre and HSPICE,
    (ESD_{HBM,MM,CDM}.{scs,sp}), the voltage across the ESD clamp is v(3). To
    see the current through the device under test, you can plot V1:p in Spectre
    results, or i(v1) in HSPICE results. Note that this current is the opposite
    of the current flowing from node 3 to ground.

    For ESD_TLP_equiv.{scs,sp}, to see the I-V characteristics of the BESD
    model, you need to plot V1:p, or i(V1) with respect to v(2).

    The simulation results from Spectre and HSPICE using the Verilog-A model
    should be consistent with those from MAPP using the ModSpec model. They
    should all be consistent with those listed in the model manual:
    BESD_v1_0_0_manual.pdf.
