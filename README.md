# 4-digit Decimal Up Counter

Here is 4-Digit Up Decimal counter demo for Digilent CoolRunner II board. It
uses my advanced counter module [uptime.v](uptime.v) where number of BCD digits can be
specify as instance parameter.

Basis of this project comes from my:
https://github.com/hpaluch/crii-sandbox/blob/master/tut03-disp/top.v which is
hexadecimal counter hardcoded for 4 digits. However I added advanced [uptime](uptime.v)
(N-digit BCD counting) module using `genvar` and `generate` Verilog constructs
to properly handle hexadecimal to decimal digit overflows for any number of
digits.

Just few days earlier I though that it was impossible to do that (make
configurable number of BCD digits) in Verilog.

Required hardware:
* [Digilent CoolRunner-II CPLD Starter Board][Digilent CoolRunner-II CPLD Starter Board]:
* Male-A to Mini-B USB cable

Required Software
* [Xilinx ISE Webpack 14.7][Xilinx ISE Webpack 14.7] - tested VirtualBox .ova image that
  is included in "Win 10" version archive.

# Status

* Implementation now builds
* It works - verified on real device
* Verified project creation script [aa-create-project.tcl](aa-create-project.tcl).

# Setup

This project is basically read-only - all working files are created
by [aa-create-project.tcl](aa-create-project.tcl) under relative
directory `../crii-count10_work/` (suffix `_work` instead of this suffix `-tcl`).

To create project do this in Linux shell:
```shell
$ xtclsh

# Now you are in Xilinx ISE TCL Shell (notice "%" prompt)

% source aa-create-project.tcl
% rebuild_project
% dir top.jed
% exit
```

Now there should be generated file `../crii-count10_work/top.jed`. You can 
- run iMPACT
- open `jtag-prog.cdf` and program your CoolRunner II board
- NOTE: There is absolute pathname to `top.jed` - please check contents of above `.cdf` file
  before using it
- immediately after programming it should start counting in decimal on 7-segment display

Tip: you can also find latest files under:
- [dist/top.jed](dist/top.jed) - latest bitstream (JEDEC) file to program in iMPACT.
- [dist/top.rpt](dist/top.rpt) - latest text report file - so you can see how much
  is this CPLD utilized

[Digilent CoolRunner-II CPLD Starter Board]: https://store.digilentinc.com/coolrunner-ii-cpld-starter-board-limited-time/
[Xilinx ISE Webpack 14.7]: https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html
