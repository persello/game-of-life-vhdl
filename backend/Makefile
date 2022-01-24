ENTDIR=entities
WORKDIR=WORK
VCDDIR=VCD
MAIN=world_tb_interactive
#
GHDL=ghdl
GHDLFLAGS=--std=08
GHDLRUNFLAGS=--vcd=$(MAIN).vcd
LIB_NAME=src_lib

all: run

run: elaboration
	$(GHDL) -r $(MAIN) $(GHDLRUNFLAGS)
	mv $(MAIN).vcd $(VCDDIR)
	mv *.cf $(WORKDIR)

elaboration : analysis
	$(GHDL) -c $(GHDLFLAGS) -e $(MAIN)

analysis: clean
	$(GHDL) -a --work=$(LIB_NAME) $(GHDLFLAGS) $(ENTDIR)/cell.vhdl
	$(GHDL) -a --work=$(LIB_NAME) $(GHDLFLAGS) $(ENTDIR)/ones_counter.vhdl
	$(GHDL) -a --work=$(LIB_NAME) $(GHDLFLAGS) $(ENTDIR)/world.vhdl
	$(GHDL) -a $(GHDLFLAGS) $(ENTDIR)/$(MAIN).vhdl

clean: prepare
	@rm -f *.cf *.vcd
	@rm -rf vunit_out/

prepare: force

force:
