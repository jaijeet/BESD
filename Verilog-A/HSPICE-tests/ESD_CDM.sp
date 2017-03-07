* ESD_CDM.sp
* ---------------------------------------------------------------------
* HSPICE netlist to test the ESD clamp compact model (BESD_1_0_0.va) under
* Charged Device Mode
*
* Version: 1.0.0
* Tested on: Synopsys HSPICE Version J-2014.09 64-BIT
*
* Author: Tianshi Wang [tianshi@berkeley.edu]
* Last Modified: Mar 5, 2017

.OPTION POST
.OPTION RUNLVL=5

.hdl ../models/BESD_1_0_0.va

V1 1 0 DC 0 pulse(0 500 10n 100p 100p 30n 60n)
C1 1 2 2.5p ic=0
R1 2 3 30
L1 3 4 20n ic=0
X1 5 4 BESD_1_0_0
X2 5 0 BESD_1_0_0
RL 4 0 500

* transient simulation
.tran 1p 50n
.end
