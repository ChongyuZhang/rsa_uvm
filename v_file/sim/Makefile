#############################
# User variables
#############################
TB       = tb
SEED     = 1
TESTNAME ?= access_test
DFILES   = ../../d_file/{v_ARS_modmult.v,v_ARS_RSACypher.v}
VFILES  += ../rsa_pkg.sv ../$(TB).sv 
INCDIR   = +incdir+../ \
					 +incdir+../seq_and_test/
					
#############################
# Environment variables
#############################
VCOMP  = vlogan $(INCDIR) -full64 -ntb_opts uvm-1.2 -sverilog -timescale=1ns/1ns -nc -l comp.log +incdir+../../d_file
ELAB   = vcs -full64 -ntb_opts uvm-1.2 -debug_all -l elab.log -sim_res=1ns -cm line+tgl+branch -cm_hier cm.cfg
RUN    = $(TB).simv -l run.log -sml -cm line+tgl+branch -cm_name $(TB)_$(SEED) +ntb_random_seed=$(SEED) +UVM_TESTNAME=$(TESTNAME)

comp:
	$(VCOMP) 
	$(VCOMP) $(DFILES) $(VFILES)

elab: comp
	$(ELAB) -top $(TB) -o $(TB).simv

run:
	$(RUN) 

rung:
	$(RUN) -gui

# option for exlucde file given to generate coverage report 
# if there is such a coverage exclusion file
# urg -dir ... -elfile filename.el
viewcov:
	urg -full64 -format both -dir $(TB).simv.vdb 
	firefox urgReport/dashboard.html

clean:
	rm -rf AN.DB DVEfiles csrc *.simv *.simv.daidir *.simv.vdb ucli.key
	rm -rf *.log* *.vpd *.h urgReport

