///////////////////////////////////////////
// jtag.sv
//
// Written: matthew.n.otto@okstate.edu, james.stine@okstate.edu
// Created: 15 March 2024
//
// Purpose: JTAG portion of DTM
//
// A component of the CORE-V-WALLY configurable RISC-V project.
// https://github.com/openhwgroup/cvw
//
// Copyright (C) 2021-24 Harvey Mudd College & Oklahoma State University
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”); you may not use this file
// except in compliance with the License, or, at your option, the Apache License version 2.0. You
// may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed under the
// License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions
// and limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////

module jtag #(parameter ADDR_WIDTH, parameter DEVICE_ID) (
  // JTAG signals
  input  logic                     tck,
  input  logic                     tdi,
  input  logic                     tms,
  output logic                     tdo,
  output logic                     resetn,

  // DTM signals
  output logic                     UpdateDtmcs,
  output logic [31:0]              DtmcsIn,
  input  logic [31:0]              DtmcsOut,

  output logic                     CaptureDmi,
  output logic                     UpdateDmi,
  output logic [34+ADDR_WIDTH-1:0] DmiIn,
  input  logic [34+ADDR_WIDTH-1:0] DmiOut
);

  genvar i;

  // Data signals
  logic                            tdi_ir, tdi_dr;
  logic                            tdo_ir, tdo_dr;
  logic                            tdo_bypass;
  logic                            tdo_idcode;
  logic                            tdo_dtmcs;
  logic                            tdo_dmi;

  // TAP controller logic
  logic                            tdo_en;
  logic                            captureIR;
  logic                            clockIR;
  logic                            updateIR;
  logic                            shiftDR;
  logic                            captureDR;
  logic                            clockDR;
  logic                            updateDR;
  logic                            select;

  // Instruction signals
  logic                            BypassInstr;
  logic                            IDCodeInstr;
  logic                            DtmcsIntrs;
  logic                            DmiInstr;

  logic [32:0]                     DtmcsShiftReg;
  logic [34+ADDR_WIDTH:0]          DmiShiftReg;

  assign UpdateDtmcs = updateDR & DtmcsIntrs;

  assign CaptureDmi = captureDR & DmiInstr;
  assign UpdateDmi = updateDR & DmiInstr;

  tap tap (.tck, .tms, .resetn, .tdo_en, .captureIR,
    .clockIR, .updateIR, .shiftDR, .captureDR, .clockDR, .updateDR, .select);

  // IR/DR input demux
  assign tdi_ir = select ? tdi : 1'bz;
  assign tdi_dr = select ? 1'bz : tdi;
  // IR/DR output mux
  assign tdo = ~tdo_en ? 1'bz :
         select ? tdo_ir : tdo_dr;

  ir ir (.clockIR,  .tdi(tdi_ir), .resetn, .captureIR, .updateIR, .tdo(tdo_ir),
    .BypassInstr, .IDCodeInstr, .DtmcsIntrs, .DmiInstr);

  // DR demux
  always_comb begin
    unique case ({BypassInstr, IDCodeInstr, DtmcsIntrs, DmiInstr})
      4'b1000 : tdo_dr = tdo_bypass;
      4'b0100 : tdo_dr = tdo_idcode;
      4'b0010 : tdo_dr = tdo_dtmcs;
      4'b0001 : tdo_dr = tdo_dmi;
      default : tdo_dr = tdo_bypass;
    endcase
  end

  flop #(32) dtmcsreg (.clk(UpdateDtmcs), .d(DtmcsShiftReg[31:0]), .q(DtmcsIn));
  flop #(34+ADDR_WIDTH) dmireg (.clk(UpdateDmi), .d(DmiShiftReg[34+ADDR_WIDTH-1:0]), .q(DmiIn));

  assign DtmcsShiftReg[32] = tdi_dr;
  assign tdo_dtmcs = DtmcsShiftReg[0];
  for (i = 0; i < 32; i = i + 1)
    flop #(1) dtmcsshiftreg (.clk(clockDR), .d(captureDR ? DtmcsOut[i] : DtmcsShiftReg[i+1]), .q(DtmcsShiftReg[i]));

  assign DmiShiftReg[34+ADDR_WIDTH] = tdi_dr;
  assign tdo_dmi = DmiShiftReg[0];
  for (i = 0; i < 34+ADDR_WIDTH; i = i + 1)
    flop #(1) dmishiftreg (.clk(clockDR), .d(captureDR ? DmiOut[i] : DmiShiftReg[i+1]), .q(DmiShiftReg[i]));

  // jtag id register
  idreg #(DEVICE_ID) id (.tdi(tdi_dr), .clockDR, .captureDR, .tdo(tdo_idcode));

  // bypass register
  flop #(1) bypassreg (.clk(clockDR), .d(tdi_dr & shiftDR), .q(tdo_bypass));

endmodule
