* ESD_MM.sp
* ---------------------------------------------------------------------
* HSPICE netlist to test the ESD clamp compact model (BESD_1_0_0.va) under
* Machine Mode
*
* Version: 1.0.0
* Tested on: Synopsys HSPICE Version J-2014.09 64-BIT
*
* Author: Tianshi Wang [tianshi@berkeley.edu]
* Last Modified: Mar 5, 2017

.OPTION POST
.OPTION RUNLVL=5

.hdl ../models/BESD_1_0_0.va

V1 1 0 DC 0 pulse(0 200 10n 100p 100p 1000n 2000n)
C1 1 2 200p ic=0
R1 2 3 5
L1 3 4 0.5u
X1 5 4 BESD_1_0_0
X2 5 0 BESD_1_0_0
RL 4 0 500

* transient simulation
.tran 1p 1500n
.end
