* ESD_DC_AC_TRAN.sp
* ---------------------------------------------------------------------
* HSPICE netlist to test the ESD clamp compact model (BESD_1_0_0.va) in
* a simplified equivalent circuit of transimission line pulse analysis
*
* Version: 1.0.0
* Tested on: Synopsys HSPICE Version J-2014.09 64-BIT
*
* Author: Tianshi Wang [tianshi@berkeley.edu]
* Last Modified: Mar 5, 2017

.OPTION POST
.OPTION RUNLVL=5

.hdl ../models/BESD_1_0_0.va

V1 1 0 DC 0 pulse(0 50 10n 100p 100p 30n 60n)
R1 1 2 50
X1 2 0 BESD_1_0_0

* DC analysis
.dc V1 0 200 0.5

* transient simulation
.tran 1p 50n
.end
