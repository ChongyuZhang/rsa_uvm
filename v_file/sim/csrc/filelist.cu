PIC_LD=ld

ARCHIVE_OBJS=
ARCHIVE_OBJS += _21693_archive_1.so
_21693_archive_1.so : archive.0/_21693_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -Bsymbolic  -o .//../tb.simv.daidir//_21693_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../tb.simv.daidir//_21693_archive_1.so $@





O0_OBJS =

$(O0_OBJS) : %.o: %.c
	$(CC_CG) $(CFLAGS_O0) -c -o $@ $<
 

%.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

MAIN_OBJS = \
objs/amcQw_d.o 

CU_OBJS = $(MAIN_OBJS) $(ARCHIVE_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

