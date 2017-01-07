" Vim syntax file
" Language:		FreeBSD kernel configuration files
" Maintainer:		Kent Nassen <knassen@umich.edu>
" Last Change:	        Feb 20, 2003 (for Jan 05, 2003 version of LINT for FBSD 4.7-stable)
"

" Remove any old syntax stuff hanging around
syn clear
" syntax is case sensitive
syn case match

" This is a work in process...new kernel devices and options appear with each
" new version of FreeBSD.
syn match configCommands  "^config\|controller\|cpu\|device\|disk\|machine\|maxusers\|makeoptions\|options"

syn match configPseudo	"^pseudo-device"

syn match configIdent  "^ident" nextgroup=configIdentParm skipwhite skipempty

syn match configIdentParm  "\w+" contained
syn match configIdentParm  "[ \t].*" nextgroup=configIdentParm skipwhite skipempty contained

syn match configNumber  "-\=\<[0-9xcaedf]\+L\=\>\|\.0[0-9]\+\>"

syn match configSpecial  '?\|=\|"\|-\|\\"' nextgroup=configString

syn match configComment  "#.*$"

syn keyword configOptions  ACCEPT_FILTER_DATA ACCEPT_FILTER_HTTP ADW_ALLOW_MEMIO
syn keyword configOptions  AHC_ALLOW_MEMIO AHC_DUMP_EEPROM AHC_TMODE_ENABLE
syn keyword configOptions  AHD_DEBUG AHD_DEBUG_OPTS AHD_REG_PRETTY AHD_TMODE_ENABLE
syn keyword configOptions  ALT_BREAK_TO_DEBUGGER APIC_IO ASUSCOM_IPAC ATAPI
syn keyword configOptions  ATA_STATIC_ID ATKBD_DFLT_KEYMAP ATKBD_DFLT_KEYMAP
syn keyword configOptions  ATM_CORE ATM_IP ATM_SIGPVC ATM_SPANS ATM_UNI AUTO_EOI_1
syn keyword configOptions  AUTO_EOI_2 AVM_A1 BLKDEV_IOSIZE BOOTP BOOTP_COMPAT
syn keyword configOptions  BOOTP_NFSROOT BOOTP_NFSV3 BOOTP_WIRED_TO BOUNCE_BUFFERS
syn keyword configOptions  BREAK_TO_DEBUGGER BRIDGE BROKEN_KEYBOARD_RESET BUS_DEBUG
syn keyword configOptions  CAMDEBUG CAM_DEBUG_BUS CAM_DEBUG_DELAY CAM_DEBUG_FLAGS
syn keyword configOptions  CAM_DEBUG_LUN CAM_DEBUG_TARGET CAM_MAX_HIGHPOWER
syn keyword configOptions  CD9660 CD9660_ROOT CHANGER_MAX_BUSY_SECONDS
syn keyword configOptions  CHANGER_MIN_BUSY_SECONDS CLK_CALIBRATION_LOOP
syn keyword configOptions  CLK_USE_I8254_CALIBRATION CLK_USE_TSC_CALIBRATION
syn keyword configOptions  CLUSTERDEBUG CODA COMPAT_43 COMPAT_LINUX COMPAT_SVR4
syn keyword configOptions  COMPILING_LINT COM_ESP COM_MULTIPORT CONSPEED
syn keyword configOptions  CPU_ATHLON_SSE_HACK CPU_BLUELIGHTNING_3X 
syn keyword configOptions  CPU_BLUELIGHTNING_FPU_OP_CACHE CPU_ELAN
syn keyword configOptions  CPU_BTB_EN CPU_DIRECT_MAPPED_CACHE CPU_DISABLE_5X86_LSSER
syn keyword configOptions  CPU_ENABLE_SSE CPU_FASTER_5X86_FPU CPU_FASTER_5X86_FPU
syn keyword configOptions  CPU_I486_ON_386 CPU_IORT CPU_L2_LATENCY CPU_LOOP_EN
syn keyword configOptions  CPU_PPRO2CELERON CPU_RSTK_EN CPU_SUSP_HLT
syn keyword configOptions  CPU_UPGRADE_HW_CACHE CPU_WT_ALLOC CRTX_S0_P
syn keyword configOptions  CYRIX_CACHE_REALLY_WORKS CYRIX_CACHE_WORKS CY_PCI_FASTINTR
syn keyword configOptions  DDB DDB_UNATTENDED DEBUG_1284 DEBUG_LINUX DEBUG_LOCKS
syn keyword configOptions  DEBUG_SVR4 DEBUG_VFS_LOCKS DEVICE_POLLING DFLDSIZ DIAGNOSTIC DISABLE_PSE
syn keyword configOptions  DONTPROBE_1284 DPT_ALLOW_MEMIO DPT_LOST_IRQ DPT_RESET_HBA
syn keyword configOptions  DPT_TIMEOUT_FACTOR DRN_NGO DUMMYNET DYNALINK EICON_DIVA
syn keyword configOptions  EISA_SLOTS ELSA_PCC16 ELSA_QS1ISA ELSA_QS1PCI
syn keyword configOptions  ENABLE_ALART ENABLE_VFS_IOOPT ETHER_8022 ETHER_8023
syn keyword configOptions  ETHER_II ETHER_SNAP EXT2FS FAILSAFE FAT_CURSOR FB_DEBUG
syn keyword configOptions  FB_INSTALL_CDEV FDC_DEBUG FDESC FE_8BIT_SUPPORT FFS
syn keyword configOptions  FFS_ROOT GDB_REMOTE_CHAT GPL_MATH_EMULATE HW_WDOG HZ i386
syn keyword configOptions  I4B_SMP_WORKAROUND I586_PMC_GUPROF IBCS2 ICMP_BANDLIM
syn keyword configOptions  IDE_DELAY INCLUDE_CONFIG_FILE INET INET INET6 INIT_PATH
syn keyword configOptions  INTRO_USERCONFIG INVARIANTS INVARIANT_SUPPORT iomem
syn keyword configOptions  IPDIVERT IPFILTER IPFILTER_DEFAULT_BLOCK IPFILTER_LOG
syn keyword configOptions  IPFIREWALL IPFIREWALL_DEFAULT_TO_ACCEPT IPFIREWALL_FORWARD
syn keyword configOptions  IPFIREWALL_VERBOSE IPFIREWALL_VERBOSE_LIMIT IPR_LOG IPR_VJ
syn keyword configOptions  IPSEC IPSEC_DEBUG IPSEC_ESP IPSTEALTH IPTUNNEL IPV6FIREWALL
syn keyword configOptions  IPV6FIREWALL_DEFAULT_TO_ACCEPT IPV6FIREWALL_VERBOSE
syn keyword configOptions  IPV6FIREWALL_VERBOSE_LIMIT IPX IPXIP iso it ITKIX1 ITKIXI
syn keyword configOptions  KBDIO_DEBUG KBD_DISABLE_KEYMAP_LOAD KBD_INSTALL_CDEV
syn keyword configOptions  KBD_MAXRETRY KBD_MAXWAIT KBD_RESETDELAY KERNFS KEY
syn keyword configOptions  KTRACE KTRACE KVA_PAGES LIBICONV LIBMCHAIN LIBMCHAIN
syn keyword configOptions  LOCKF_DEBUG LOUTB LPT_DEBUG MATH_EMULATE MAXCONS MAXDSIZ
syn keyword configOptions  MAXMEM MAXSSIZ MD_NSECT MD_ROOT MD_ROOT_SIZE MFS MROUTING
syn keyword configOptions  MSDOSFS MSGBUF_SIZE MSGMNB MSGMNI MSGSEG MSGSSZ MSGTQL
syn keyword configOptions  NATM NBUF NCP NDGBPORTS NETATALK NETATALK NETATALKDEBUG
syn keyword configOptions  NETGRAPH NETGRAPH_ASYNC NETGRAPH_ASYNC
syn keyword configOptions  NETGRAPH_BPF NETGRAPH_CISCO NETGRAPH_ECHO NETGRAPH_ETHER
syn keyword configOptions  NETGRAPH_FRAME_RELAY NETGRAPH_HOLE NETGRAPH_IFACE
syn keyword configOptions  NETGRAPH_KSOCKET NETGRAPH_L2TP NETGRAPH_LMI NETGRAPH_MPPC_COMPRESSION
syn keyword configOptions  NETGRAPH_MPPC_ENCRYPTION NETGRAPH_ONE2MANY NETGRAPH_PPP
syn keyword configOptions  NETGRAPH_PPPOE NETGRAPH_PPTPGRE NETGRAPH_RFC1490
syn keyword configOptions  NETGRAPH_SOCKET NETGRAPH_TEE NETGRAPH_TTY NETGRAPH_UI
syn keyword configOptions  NETGRAPH_VJC NETSMB NETSMB NETSMBCRYPTO NETSMBCRYPTO NFS
syn keyword configOptions  NFS_DEBUG NFS_GATHERDELAY NFS_MAXATTRTIMO NFS_MAXDIRATTRTIMO
syn keyword configOptions  NFS_MINATTRTIMO NFS_MINDIRATTRTIMO NFS_MUIDHASHSIZ
syn keyword configOptions  NFS_NOSERVER NFS_ROOT NFS_UIDHASHSIZ NFS_WDELAYHASHSIZ
syn keyword configOptions  NMBCLUSTERS NMBUFS NO_F00F_HACK NO_SWAPPING NPX_DEBUG NSFBUFS
syn keyword configOptions  NSWAPDEV NTFS NTIMECOUNTER NULLFS NWFS OHCI_DEBUG
syn keyword configOptions  OLTR_NO_BULLSEYE_MAC OLTR_NO_HAWKEYE_MAC OLTR_NO_TMS_MAC
syn keyword configOptions  P1003_1B PANIC_REBOOT_WAIT_TIME PAS_JOYSTICK_ENABLE
syn keyword configOptions  PCFCLOCK_MAX_RETRIES PCFCLOCK_VERBOSE PCIC_RESUME_RESET
syn keyword configOptions  PCI_ENABLE_IO_MODES PCI_QUIET PCVT_24LINESDEF PCVT_CTRL_ALT_DEL PCVT_EMU_MOUSE
syn keyword configOptions  PCVT_FREEBSD PCVT_META_ESC PCVT_NSCREENS PCVT_PRETTYSCRNS
syn keyword configOptions  PCVT_SCANSET PCVT_SCREENSAVER PCVT_USEKBDSEC PCVT_VT220KEYB
syn keyword configOptions  PERFMON PERIPH_1284 PLIP_DEBUG PMAP_SHPGPERPROC PNPBIOS
syn keyword configOptions  PORTAL POWERFAIL_NMI PPC_DEBUG PPC_PROBE_CHIPSET PPP_BSDCOMP
syn keyword configOptions  PPP_DEFLATE PPP_FILTER PPS_SYNC PQ_CACHESIZE PQ_HUGECACHE
syn keyword configOptions  PQ_LARGECACHE PQ_MEDIUMCACHE PQ_NOOPT PQ_NORMALCACHE PROCFS
syn keyword configOptions  PSM_DEBUG PSM_HOOKRESUME PSM_RESETAFTERSUSPEND QUOTA
syn keyword configOptions  RANDOM_IP_ID ROOTDEVNAME SA_1FM_AT_EOD SA_ERASE_TIMEOUT
syn keyword configOptions  SA_IO_TIMEOUT SA_REWIND_TIMEOUT SA_SPACE_TIMEOUT
syn keyword configOptions  SBC_IRQ SCSI_DELAY SCSI_NCR_DEBUG SCSI_NCR_MAX_SYNC
syn keyword configOptions  SCSI_NCR_MAX_WIDE SCSI_NCR_MYADDR SCSI_NO_OP_STRINGS
syn keyword configOptions  SCSI_NO_SENSE_STRINGS SCSI_PT_DEFAULT_TIMEOUT
syn keyword configOptions  SC_ALT_MOUSE_IMAGE SC_DEBUG_LEVEL SC_DFLT_FONT
syn keyword configOptions  SC_DFLT_FONT SC_DISABLE_DDBKEY SC_DISABLE_REBOOT
syn keyword configOptions  SC_HISTORY_SIZE SC_KERNEL_CONS_ATTR SC_KERNEL_CONS_REV_ATTR
syn keyword configOptions  SC_MOUSE_CHAR SC_NORM_ATTR SC_NORM_REV_ATTR SC_NO_CUTPASTE
syn keyword configOptions  SC_NO_FONT_LOADING SC_NO_HISTORY SC_NO_SYSMOUSE
syn keyword configOptions  SC_PIXEL_MODE SC_RENDER_DEBUG SC_TWOBUTTON_MOUSE SEDLBAUER
syn keyword configOptions  SEMMAP SEMMNI SEMMNS SEMMNU SEMMSL SEMOPM SEMUME
syn keyword configOptions  SES_ENABLE_PASSTHROUGH SHMALL SHMMAX SHMMAXPGS SHMMIN
syn keyword configOptions  SHMMNI SHMSEG SHOW_BUSYBUFS SIEMENS_ISURF2 SIMPLELOCK_DEBUG
syn keyword configOptions  SI_DEBUG SLIP_IFF_OPTS SMBFS SMP SOFTUPDATES SPX_HACK
syn keyword configOptions  SUIDDIR SYSVMSG SYSVMSG SYSVSEM SYSVSHM TCPDEBUG
syn keyword configOptions  TCP_DROP_SYNFIN TEL_S0_16 TEL_S0_16_3 TEL_S0_16_3_P TEL_S0_8
syn keyword configOptions  TIMER_FREQ UCONSOLE UCONSOLE UFS_DIRHASH UGEN_DEBUG
syn keyword configOptions  UHCI_DEBUG UHID_DEBUG UHUB_DEBUG UKBD_DEBUG UKBD_DFLT_KEYMAP
syn keyword configOptions  UKBD_DFLT_KEYMAP ULPT_DEBUG UMAPFS UMASS_DEBUG UMS_DEBUG
syn keyword configOptions  UNION USB_DEBUG USERCONFIG USERCONFIG USER_LDT USR_STI VESA
syn keyword configOptions  VFS_AIO VFS_BIO_DEBUG VGA_ALT_SEQACCESS VGA_NO_FONT_LOADING
syn keyword configOptions  VGA_NO_MODE_CHANGE VGA_SLOW_IOACCESS VGA_WIDTH90 VINUMDEBUG
syn keyword configOptions  VISUAL_USERCONFIG VISUAL_USERCONFIG VM_BCACHE_SIZE_MAX
syn keyword configOptions  VM_KMEM_SIZE VM_KMEM_SIZE_MAX VM_KMEM_SIZE_SCALE
syn keyword configOptions  VM_SWZONE_SIZE_MAX VP0_DEBUG WLCACHE WLDEBUG XBONEHACK
syn keyword configOptions  XSERVER _KPOSIX_PRIORITY_SCHEDULING _KPOSIX_VERSION
syn keyword configOptionsBroken NS NSIP

syn keyword cpuOptions  I386_CPU I486_CPU I586_CPU I686_CPU

syn keyword configDevices  0x23c IO_ASC1 IO_BT0 IO_COM1 IO_FD1 IO_GAME IO_GSC1 IO_KBD
syn keyword configDevices  IO_TIMER1 IO_WD1 IO_WD2 aac aacp adv0 adw agp aha0 ahb ahc ahd aic0 alpm
syn keyword configDevices  amd amdpm amr an apm0 ar0 arcnet asc0 asr ata ata0 ata1 atadisk atapicam atapicd
syn keyword configDevices  atapifd atapist atkbd0 atkbdc atkbdc0 atm aue awi bge bktr
syn keyword configDevices  bpf bt0 card ccd cd cd0 ch ciss crypto cryptodev cs0 ctx0 cue cx0 cy0 da dc de
syn keyword configDevices  de0 dgb0 dgm0 disc dpt ed0 ef eisa eisa0 el0 em en ep ether
syn keyword configDevices  ex faith fd0 fd1 fdc0 fddi fe0 fea firewire fla0 fpa ft0 fwe fxp fxp0
syn keyword configDevices  gif gp0 gre gsc0 gusc0 gzip gx hea hfa hifn iavc0 ic ichsmb ida ie0 ie1
syn keyword configDevices  i4bcapi i4bq921 i4bq931 i4b i4btrc i4bctl i4brbch i4btel i4bipr i4bisppp
syn keyword configDevices  ifpi ifpnp ihfc iic iicbb iicbus iicsmb iir intpm iosiz isa0
syn keyword configDevices  isic isic0 isp ispfw itjc iwic joy0 kernel kue labpc0 le0
syn keyword configDevices  lge lnc0 log loop loop loran0 lpbb lpt lpt0 lpt1 matcd0 mca
syn keyword configDevices  mcd0 md meteor miibus mlx mly mn mse0 my ncr ncv nge nmdm npx0
syn keyword configDevices  nsp od0 ohci oltr0 pass pca0 pcf0 pcfclock pci pci0 pcic0
syn keyword configDevices  pcic1 pcm pcm0 pcn plip ppbus ppc0 ppi ppp pps psm0 pt pty 
syn keyword configDevices  ray rc0 rdp0 rl rp0 sa sb0 sbc0 sbmidi0 sbp sbxvi0 sc0 scbus 
syn keyword configDevices  scbus0 scd0 sd0 sd1 sd2 sd3 sd4 ses sf si0 sio0 sio1 sis 
syn keyword configDevices  sk sl smb smbus sn0 snd0 snp speaker spigot0 splash sppp 
syn keyword configDevices  sr0 st0 ste stf stg0 stl0 stli0 streams sym ti tl token trm tun 
syn keyword configDevices  tun tw0 twe tx txp ubsec ucom ufm uftdi ugen uhci uhid ukbd ulpt umass umodem 
syn keyword configDevices  ums uplcom urio usb uscanner uvscom uvisor vcoda vga0 viapm vinum vlan vn vpo vr vs 
syn keyword configDevices  vt0 vx vx0 wb wcd wcd0 wd0 wd1 wd2 wd3 wdc0 wdc1 wfd wi 
syn keyword configDevices  wl0 wst wt0 wx xe xl xrpu

syn keyword makeOptions CONF_CFLAGS DEBUG KERNEL MODULES_OVERRIDE fno builtin

syn keyword configMisc	at drive isa port bio irq drq vector conflicts root on wdintr flags 
syn keyword configMisc  aicintr tty wtintr scintr npxintr siointr psmintr sbintr fdintr lptintr

syntax region configString  start=+"+  skip=+\\\\"+  end=+"+  contained

hi link configCommands	Statement
hi link configPseudo	Statement
hi link configComment	Comment
hi link configString	String
hi link configOptions	String
hi link makeOptions	String
hi link cpuOptions	String
hi link configDevices	Special
hi link configNumber	Special
hi link configMisc	Number
hi link configSpecial	Special
hi link configIdentParm	Special
hi link configIdent	Statement
hi link configOptionsBroken Error
