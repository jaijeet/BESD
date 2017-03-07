* ESD_DC_AC_TRAN.sp
* ---------------------------------------------------------------------
* HSPICE netlist to test the ESD clamp compact model (BESD_1_0_0.va)
*
* Version: 1.0.0
* Tested on: Synopsys HSPICE Version J-2014.09 64-BIT
*
* Author: Tianshi Wang [tianshi@berkeley.edu]
* Last Modified: Mar 5, 2017

.OPTION POST
.OPTION RUNLVL=5

.hdl ../models/BESD_1_0_0.va

V1 1 0 DC 0 pulse(0 100 1u 4m 4m 1u 8m) AC 1
X1 1 0 BESD_1_0_0

* DC analysis
.dc V1 0 100 0.5

* AC analysis
.ac dec 20 1k 100G

* transient simulation
.tran 1u 8m
.end
