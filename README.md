# 4-digit Decimal Up Counter

Here is 4-Digit Up Decimal counter demo for Digilent CoolRunner II board. It
uses my advanced counter module [uptime.v](uptime.v) where number of BCD digits
can be specified as instance parameter.

![CoolRunner-II Up DecimalCounter](https://raw.githubusercontent.com/hpaluch/crii-count10-tcl/master/assets/crii-count10.jpg)

License: [MIT](LICENSE)

Basis of this project comes from my:
https://github.com/hpaluch/crii-sandbox/blob/master/tut03-disp/top.v which is
hexadecimal counter hardcoded for 4 digits.

However in this case I added advanced [uptime](uptime.v) (N-digit BCD Up counting)
module using `genvar` and `generate` Verilog constructs to properly handle
hexadecimal to decimal digit overflows for any number of digits.

You can see it in action where [uptime.v](uptime.v) is used in:
- Implementation [top.v](top.v) uses 4-digit decimal up counter
- Simulation [uptime_tf.v](uptime_tf.v) uses 3-digit decimal up counter

Just few days earlier I though that it was impossible to do that (make
configurable number of BCD digits and esp. handling variable number of overlfow
flags) in Verilog.

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
* Also simulation looks fine

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
- immediately after programming it should start counting up in decimal on 7-segment display
- you can also press:
  - BTN0 (right button) to RESET counter (stays in RESET until button is released)
  - BTN1 (left button) to HOLD counter as long as button is pressed

Tip: you can also find latest generated files under:
- [dist/top.jed](dist/top.jed) - latest bitstream (JEDEC) file to program CoolRunner II in iMPACT.
- [dist/top.rpt](dist/top.rpt) - latest text report file - so you can see how much
  is this CPLD utilized

# Resources

First and most important - Xilinx ISE 14.7 VM download:
- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_ISE_14.7_Win10_14.7_VM_0213_1.zip
- once you unpack it there will be .ova file that you can import into VirtualBox.
  There is even prepared USB passthrough for Digilent CoolRunner II board

Xilinx ISE manuals are now available as ZIP file only (no longer online HTML
version):
- https://download.amd.com/docnav/documents/ise/ise-docs14_6.zip (unable to
  find 14.7 manuals)
- for example `cgd.pdf` describes constraints file, `devref.pdf` describes TCL
  commands


[Digilent CoolRunner-II CPLD Starter Board]: https://store.digilentinc.com/coolrunner-ii-cpld-starter-board-limited-time/
[Xilinx ISE Webpack 14.7]: https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html
