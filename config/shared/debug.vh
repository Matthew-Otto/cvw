/////////////////////////////////////////// debug.vh
// Written: matthew.n.otto@okstate.edu
// Created: 15 March 2024
// Purpose: debug port definitions
// A component of the CORE-V-WALLY configurable RISC-V project.
// https://github.com/openhwgroup/cvw
// Copyright (C) 2021-24 Harvey Mudd College & Oklahoma State University
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// Licensed under the Solderpad Hardware License v 2.1 (the “License”); you may not use this file
// except in compliance with the License, or, at your option, the Apache License version 2.0. You
// may obtain a copy of the License at
// https://solderpad.org/licenses/SHL-2.1/
// Unless required by applicable law or agreed to in writing, any work distributed under the
// License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions
// and limitations under the License.
//////////////////////////////////////////////////////////////////////////////////////////////
// DMI op field constants
`define OP_NOP     2'b00
`define OP_READ    2'b01
`define OP_WRITE   2'b10
`define OP_SUCCESS 2'b00
`define OP_FAILED  2'b10
`define OP_BUSY    2'b11

// DMI Bus Address Width
`define DMI_ADDR_WIDTH 7

// Debug Module Debug Bus Register Addresses
// DM Internal registers
`define DATA0        `DMI_ADDR_WIDTH'h04
`define DATA1        `DMI_ADDR_WIDTH'h05
`define DATA2        `DMI_ADDR_WIDTH'h06
`define DATA3        `DMI_ADDR_WIDTH'h07
`define DATA4        `DMI_ADDR_WIDTH'h08
`define DATA5        `DMI_ADDR_WIDTH'h09
`define DATA6        `DMI_ADDR_WIDTH'h0A
`define DATA7        `DMI_ADDR_WIDTH'h0B
`define DATA8        `DMI_ADDR_WIDTH'h0C
`define DATA9        `DMI_ADDR_WIDTH'h0D
`define DATA10       `DMI_ADDR_WIDTH'h0E
`define DATA11       `DMI_ADDR_WIDTH'h0F
`define DMCONTROL    `DMI_ADDR_WIDTH'h10
`define DMSTATUS     `DMI_ADDR_WIDTH'h11
`define HARTINFO     `DMI_ADDR_WIDTH'h12
`define ABSTRACTCS   `DMI_ADDR_WIDTH'h16
`define COMMAND      `DMI_ADDR_WIDTH'h17
`define ABSTRACTAUTO `DMI_ADDR_WIDTH'h18
`define NEXTDM       `DMI_ADDR_WIDTH'h1d
`define PROGBUF0     `DMI_ADDR_WIDTH'h20
`define PROGBUF1     `DMI_ADDR_WIDTH'h21
`define PROGBUF2     `DMI_ADDR_WIDTH'h22
`define PROGBUF3     `DMI_ADDR_WIDTH'h23
`define PROGBUF4     `DMI_ADDR_WIDTH'h24
`define PROGBUF5     `DMI_ADDR_WIDTH'h25
`define PROGBUF6     `DMI_ADDR_WIDTH'h26
`define PROGBUF7     `DMI_ADDR_WIDTH'h27
`define PROGBUF8     `DMI_ADDR_WIDTH'h28
`define PROGBUF9     `DMI_ADDR_WIDTH'h29
`define PROGBUFA     `DMI_ADDR_WIDTH'h2A
`define PROGBUFB     `DMI_ADDR_WIDTH'h2B
`define PROGBUFC     `DMI_ADDR_WIDTH'h2C
`define PROGBUFD     `DMI_ADDR_WIDTH'h2D
`define PROGBUFE     `DMI_ADDR_WIDTH'h2E
`define PROGBUFF     `DMI_ADDR_WIDTH'h2F
//`define dmcs2        `DMI_ADDR_WIDTH'h32
`define SBCS         `DMI_ADDR_WIDTH'h38


//// Register field ranges
// DMCONTROL 0x10
`define HALTREQ         31
`define RESUMEREQ       30
`define HARTRESET       29
`define ACKHAVERESET    28
`define ACKUNAVAIL      27
`define HASEL           26
`define HARTSELLO       25:16
`define HARTSELHI       15:6
`define SETKEEPALIVE    5
`define CLRKEEPALIVE    4
`define SETRESETHALTREQ 3
`define CLRRESETHALTREQ 2
`define NDMRESET        1
`define DMACTIVE        0

// DMSTATUS 0x11
`define NDMRESETPENDING 24
`define STICKYUNAVAIL   23
`define IMPEBREAK       22
`define ALLHAVERESET    19
`define ANYHAVERESET    18
`define ALLRESUMEACK    17
`define ANYRESUMEACK    16
`define ALLNONEXISTENT  15
`define ANYNONEXISTENT  14
`define ALLUNAVAIL      13
`define ANYUNAVAIL      12
`define ALLRUNNING      11
`define ANYRUNNING      10
`define ALLHALTED       9
`define ANYHALTED       8
`define AUTHENTICATED   7
`define AUTHBUSY        6
`define HASRESETHALTREQ 5
`define CONFSTRPTRVALID 4
`define VERSION         3:0

// ABSTRACTCS 0x16
`define PROGBUFSIZE 28:24
`define BUSY        12
`define RELAXEDPRIV 11
`define CMDERR      10:8
`define DATACOUNT   3:0

// COMMAND 0x17
`define CMDTYPE 31:24
`define CONTROL 23:0

// DCSR
`define EBREAKVS  17
`define EBREAKVU  16
`define EBREAKM   15
`define EBREAKS   13
`define EBREAKU   12
`define STEPIE    11
`define STOPCOUNT 10
`define STOPTIME  9
`define V         5
`define MPRVEN    4
`define STEP      2
`define PRV       1:0

//// Abstract Commands
// cmderr
`define CMDERR_NONE          3'h0
`define CMDERR_BUSY          3'h1
`define CMDERR_NOT_SUPPORTED 3'h2
`define CMDERR_EXCEPTION     3'h3
`define CMDERR_HALTRESUME    3'h4
`define CMDERR_BUS           3'h5
`define CMDERR_OTHER         3'h7

// Abstract CmdType Constants (3.7.1)
`define ACCESS_REGISTER 0
`define QUICK_ACCESS    1
`define ACCESS_MEMORY   2

// ACCESS_REGISTER Control ranges
`define AARSIZE          22:20
`define AARPOSTINCREMENT 19
`define POSTEXEC         18
`define TRANSFER         17
`define AARWRITE         16
`define REGNO            15:0

// aarsize
`define AAR32  2
`define AAR64  3
`define AAR128 4

// debug mode cause
`define CAUSE_EBREAK       3'h1
`define CAUSE_TRIGGER      3'h2
`define CAUSE_HALTREQ      3'h3
`define CAUSE_STEP         3'h4
`define CAUSE_RESETHALTREQ 3'h5
`define CAUSE_GROUP        3'h6

// Register Numbers (regno)
// (Table 3.3)
// 0x0000 – 0x0fff | CSRs. The “PC” can be accessed here through dpc.
// 0x1000 – 0x101f | GPRs
// 0x1020 – 0x103f | Floating point registers
// 0xc000 – 0xffff | Reserved for non-standard extensions and internal use.

// wallypipelinedcore
`define TRAPM_REGNO       16'hC000 // 1'b  P.ZICSR_SUPPORTED (Read Only)
// src/ifu
`define PCM_REGNO         16'hC001 // XLEN P.ZICSR_SUPPORTED | P.BPRED_SUPPORTED
`define INSTRM_REGNO      16'hC002 // 32'b P.ZICSR_SUPPORTED | P.A_SUPPORTED
// ieu/controller
`define MEMRWM_REGNO      16'hC003 // 2'b
`define INSTRVALIDM_REGNO 16'hC004 // 1'b
// ieu/datapath
`define WRITEDATAM_REGNO  16'hC005 // XLEN
// lsu
`define IEUADRM_REGNO     16'hC006 // XLEN
`define READDATAM_REGNO   16'hC007 // LLEN (Read Only)

// CSR
// privileged/csru
`define FFLAGS_REGNO         16'h0001
`define FRM_REGNO            16'h0002
`define FCSR_REGNO           16'h0003
// privileged/csrm
`define MSTATUS_REGNO        16'h0300
`define MISA_REGNO           16'h0301
`define MEDELEG_REGNO        16'h0302
`define MIDELEG_REGNO        16'h0303
`define MIE_REGNO            16'h0304
`define MTVEC_REGNO          16'h0305
`define MCOUNTEREN_REGNO     16'h0306

`define MENVCFG_REGNO        16'h030A

`define MSTATUSH_REGNO       16'h0310

`define MENVCFGH_REGNO       16'h031A

`define MCOUNTINHIBIT_REGNO  16'h0320

`define MSCRATCH_REGNO       16'h0340
`define MEPC_REGNO           16'h0341
`define MCAUSE_REGNO         16'h0342
`define MTVAL_REGNO          16'h0343
`define MIP_REGNO            16'h0344

`define PMPCFG0_REGNO        16'h03A0
//range
`define PMPCFGF_REGNO        16'h03AF
`define PMPADDR0_REGNO       16'h03B0// P.PA_BITS
//range
`define PMPADDR3F_REGNO      16'h03EF

`define TSELECT_REGNO        16'h07A0
`define TDATA1_REGNO         16'h07A1
`define TDATA2_REGNO         16'h07A2
`define TDATA3_REGNO         16'h07A3

`define DCSR_REGNO           16'h07B0
`define DPC_REGNO            16'h07B1

`define MVENDORID_REGNO      16'h0F11
`define MARCHID_REGNO        16'h0F12
`define MIMPID_REGNO         16'h0F13
`define MHARTID_REGNO        16'h0F14
`define MCONFIGPTR_REGNO     16'h0F15
// privileged/csr
`define SIP_REGNO            16'h0144
`define MIP_REGNO            16'h0344
// privileged/csrc
`define MHPMEVENTBASE_REGNO    16'h0320

`define MHPMCOUNTERBASE_REGNO  16'h0B00

`define MHPMCOUNTERHBASE_REGNO 16'h0B80

`define HPMCOUNTERBASE_REGNO   16'h0C00
`define TIME_REGNO             16'h0C01

`define HPMCOUNTERHBASE_REGNO  16'h0C80
`define TIMEH_REGNO            16'h0C81
// privileged/csrs
`define SSTATUS_REGNO        16'h0100

`define SIE_REGNO            16'h0104
`define STVEC_REGNO          16'h0105
`define SCOUNTEREN_REGNO     16'h0106

`define SENVCFG_REGNO        16'h010A

`define SSCRATCH_REGNO       16'h0140
`define SEPC_REGNO           16'h0141
`define SCAUSE_REGNO         16'h0142
`define STVAL_REGNO          16'h0143
`define SIP_REGNO            16'h0144

`define STIMECMP_REGNO       16'h014D

`define STIMECMPH_REGNO      16'h015D

`define SATP_REGNO           16'h0180
// privileged/csri
`define SIE_REGNO            16'h0104
`define SIP_REGNO            16'h0144
`define MIE_REGNO            16'h0304
`define MIP_REGNO            16'h0344

// src/ieu/datapath
`define X0_REGNO          16'h1000
`define X1_REGNO          16'h1001
`define X2_REGNO          16'h1002
`define X3_REGNO          16'h1003
`define X4_REGNO          16'h1004
`define X5_REGNO          16'h1005
`define X6_REGNO          16'h1006
`define X7_REGNO          16'h1007
`define X8_REGNO          16'h1008
`define X9_REGNO          16'h1009
`define X10_REGNO         16'h100A
`define X11_REGNO         16'h100B
`define X12_REGNO         16'h100C
`define X13_REGNO         16'h100D
`define X14_REGNO         16'h100E
`define X15_REGNO         16'h100F
`define X16_REGNO         16'h1010 // E_SUPPORTED
`define X17_REGNO         16'h1011 // E_SUPPORTED
`define X18_REGNO         16'h1012 // E_SUPPORTED
`define X19_REGNO         16'h1013 // E_SUPPORTED
`define X20_REGNO         16'h1014 // E_SUPPORTED
`define X21_REGNO         16'h1015 // E_SUPPORTED
`define X22_REGNO         16'h1016 // E_SUPPORTED
`define X23_REGNO         16'h1017 // E_SUPPORTED
`define X24_REGNO         16'h1018 // E_SUPPORTED
`define X25_REGNO         16'h1019 // E_SUPPORTED
`define X26_REGNO         16'h101A // E_SUPPORTED
`define X27_REGNO         16'h101B // E_SUPPORTED
`define X28_REGNO         16'h101C // E_SUPPORTED
`define X29_REGNO         16'h101D // E_SUPPORTED
`define X30_REGNO         16'h101E // E_SUPPORTED
`define X31_REGNO         16'h101F // E_SUPPORTED

// src/fpu/fpu
`define FP0_REGNO         16'h1020 // F/D_SUPPORTED
`define FP1_REGNO         16'h1021 // F/D_SUPPORTED
`define FP2_REGNO         16'h1022 // F/D_SUPPORTED
`define FP3_REGNO         16'h1023 // F/D_SUPPORTED
`define FP4_REGNO         16'h1024 // F/D_SUPPORTED
`define FP5_REGNO         16'h1025 // F/D_SUPPORTED
`define FP6_REGNO         16'h1026 // F/D_SUPPORTED
`define FP7_REGNO         16'h1027 // F/D_SUPPORTED
`define FP8_REGNO         16'h1028 // F/D_SUPPORTED
`define FP9_REGNO         16'h1029 // F/D_SUPPORTED
`define FP10_REGNO        16'h102A // F/D_SUPPORTED
`define FP11_REGNO        16'h102B // F/D_SUPPORTED
`define FP12_REGNO        16'h102C // F/D_SUPPORTED
`define FP13_REGNO        16'h102D // F/D_SUPPORTED
`define FP14_REGNO        16'h102E // F/D_SUPPORTED
`define FP15_REGNO        16'h102F // F/D_SUPPORTED
`define FP16_REGNO        16'h1030 // F/D_SUPPORTED
`define FP17_REGNO        16'h1031 // F/D_SUPPORTED
`define FP18_REGNO        16'h1032 // F/D_SUPPORTED
`define FP19_REGNO        16'h1033 // F/D_SUPPORTED
`define FP20_REGNO        16'h1034 // F/D_SUPPORTED
`define FP21_REGNO        16'h1035 // F/D_SUPPORTED
`define FP22_REGNO        16'h1036 // F/D_SUPPORTED
`define FP23_REGNO        16'h1037 // F/D_SUPPORTED
`define FP24_REGNO        16'h1038 // F/D_SUPPORTED
`define FP25_REGNO        16'h1039 // F/D_SUPPORTED
`define FP26_REGNO        16'h103A // F/D_SUPPORTED
`define FP27_REGNO        16'h103B // F/D_SUPPORTED
`define FP28_REGNO        16'h103C // F/D_SUPPORTED
`define FP29_REGNO        16'h103D // F/D_SUPPORTED
`define FP30_REGNO        16'h103E // F/D_SUPPORTED
`define FP31_REGNO        16'h103F // F/D_SUPPORTED

// ACCESS_MEMORY Control ranges (Not implemented)
//`define AAMVIRTUAL       23
//`define AAMSIZE          22:20
//`define AAMPOSTINCREMENT 19
//`define AAMWRITE         16
//`define TARGET_SPECIFIC  15:14

// aamsize
//`define AAM8   0
//`define AAM16  1
//`define AAM32  2
//`define AAM64  3
//`define AAM128 4
