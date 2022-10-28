# Set up the enviroment(Download from https://github.com/YosysHQ/oss-cad-suite-build)
# On windows start.bat
# make.exe should be on PATH
# To verbose make all QUIET=
LIB_SRC = adc.v
SOURCES = top.v ..\..\en_gen_n\en_gen_n.v ..\..\pwm\pwm.v $(LIB_SRC)
PCF = upduino.pcf
#QUIET = -q

#ICEPROG = c:\Users\pcoss\.apio\packages\toolchain-ice40\bin\iceprog
GTKWAVE = c:\Users\pcossutt\.apio\packages\tool-gtkwave\bin\gtkwave
IVERILOG = c:\Users\pcossutt\.apio\packages\tools-oss-cad-suite\bin\iverilog
#IVERILOG = iverilog
ICEPROG = iceprog
RADIANTPROG = c:\lscc\programmer\radiant\3.1\bin\nt64\pgrcmd.exe
ifdef ComSpec
    RM=del /F /Q
	CP=copy
else
    RM=rm -f
	CP=cp
endif

all: hardware.bin

hardware.json: $(SOURCES)
#	yosys -p "synth_ice40 -dsp -json hardware.json -abc9 -device u" C $(SOURCES)
	yosys -p "synth_ice40 -dsp -json hardware.json" $(QUIET) $(SOURCES)

hardware.asc: $(PCF) hardware.json
	nextpnr-ice40 --up5k --package sg48 --json hardware.json --asc hardware.asc --pcf $(PCF) --freq 72 $(QUIET)

hardware.bin: hardware.asc
	icepack hardware.asc hardware.bin

time: hardware.asc
	icetime -d up5k -P sg48 -t hardware.asc

prog: hardware.bin
	$(RADIANTPROG) -infile prog.xcf

sim: $(SOURCES)
	$(IVERILOG) -o top_tb.out -D VCD_OUTPUT=top_tb -D NO_ICE40_DEFAULT_ASSIGNMENTS "C:\Users\pcossutt\.apio\packages\tools-oss-cad-suite\share\yosys/ice40/cells_sim.v" $(SOURCES) top_tb.v
	vvp top_tb.out
	$(GTKWAVE) .\top_tb.vcd .\top_tb.gtkw
	
verify:
	$(IVERILOG) -o hardware.out -D VCD_OUTPUT= -D NO_ICE40_DEFAULT_ASSIGNMENTS "C:\Users\pcossutt\.apio\packages\tools-oss-cad-suite\share\yosys/ice40/cells_sim.v" $(SOURCES)
	
iceprog: hardware.bin
	$(ICEPROG) hardware.bin

install:
	$(RM) ..\$(LIB_SRC)
	$(CP) $(LIB_SRC) ..\

clean:
	$(RM) hardware.json hardware.asc hardware.bin abc.history top_tb.out top_tb.vcd
