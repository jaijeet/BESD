# BESD: the Berkeley Electrostatic Discharge Models
This repository contains a set of behavioural models for ESD protection devices (or ESD clamps). Such devices usually operate based on a mechanism known as [snapback](https://en.wikipedia.org/wiki/Snapback_(electrical)), which creates a fold in the device's I--V graph. To incorporate snapback, existing compact models often use if-else statements, Boolean variables, or implement specialised time integration methods inside. These practices greatly reduce the robustness of the models in simulation.

The primary aim of the released BESD models is to demonstrate the proper way of modelling the ESD snapback phenomenon using differential equations that are continuous, smooth and well posed. Models written in this way can work reliably across different simulation platforms and in various simulation algorithms. BESD models are released in both [ModSpec](#further-reading)/MATLAB and [Verilog-A](https://en.wikipedia.org/wiki/Verilog-AMS) formats.

## Features
- The models are designed to be **free from if-else statements and discontinuous functions**.
Note that although models consisting of only smooth functions are in principle robust in simulation, there is no guarantee that they will always converge in all circuit analyses. Newton Raphson, the core algorithm for many analyses, can [fail to converge](https://en.wikipedia.org/wiki/Newton's_method#Failure_analysis) even on perfectly smooth equations. In the case of an ESD protection device, DC sweep can fail to converge when the device is turning "on" --- this is more a limitation of the DC sweep analysis than a defect of the model. Analyses like transient and homotopy should work robustly on smooth models such as BESD.

- The models do not alter simulation algorithms, *i.e.*, they **do not contain analysis-specific code** inside. This ensures that they are compatible with all circuit analyses and should generate consistent results in them. Many problems, like inconsistent derivatives in AC and transient analyses, are avoided.

- BESD models characterise impact ionization with differential equations, *i.e.*, they can capture the growth of ionization, which is the time it requires for the device to turn "on". As noted [here](http://ieeexplore.ieee.org/document/6333317/), most existing compact models for ESD assume that ionization occurs instantaneously, which is not physical.

- BESD models contain parameters that can be conveniently determined to fit measurements.

- As behavioural models, BESD can be used for a variety of ESD protection devices, including different types of silicon-controlled rectifier (SCR) devices and bipolar clamps.

## Usage
Clone this repository or download a snapshot zip file to your machine.
Then follow the instructions in **README.txt** to use BESD with MAPP, VAPP and Spectre/HSPICE.

## Further Reading
[ModSpec](https://doi.org/10.1109/ICCAD.2011.6105356): an open, flexible specification framework for multi-domain device modelling.

The Berkeley Model and Algorithm Prototyping Platform ([MAPP](https://github.com/jaijeet/MAPP)).

[Verilog-A language reference manual](http://www.designers-guide.org/VerilogAMS/VlogAMS-2.4.0.pdf).

[Best Verilog-A practices](http://ieeexplore.ieee.org/document/7154394/), [NEEDS-compatible Verilog-A guide](https://nanohub.org/resources/18621/watch?resid=18622).

[A physically-based behavioral snapback model](http://ieeexplore.ieee.org/document/6333317/).

[Well-Posed Device Model Guidelines](https://nanohub.org/resources/26200/download/well-posed_device_models-29453e4.pdf).

## Reference

If you use BESD models in your work, please acknowledge:

[(invited paper)](http://ieeexplore.ieee.org/document/7993681/) T. Wang. "Modelling Multistability and Hysteresis in ESD Clamps, Memristors and Other Devices." In Proceedings of IEEE Custom Integrated Circuits Conference, 2017.

If you use MAPP in your work, please acknowledge:

[(invited paper)](http://ieeexplore.ieee.org/document/7338431/) T. Wang, A. V. Karthik, B. Wu, J. Yao, and J. Roychowdhury, "MAPP: The Berkeley Model and Algorithm Prototyping Platform." In Proceedings of IEEE Custom Integrated Circuits Conference, 2015.
