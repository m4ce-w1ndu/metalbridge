# metalbridge - Apple Paravirtualized GPU host-side support for Linux KVM 

Goal: a Linux host-side implementation of Apple's paravirtualized GPU (PVG) device
for x86-64 macOS guests, so that the guest's own Metal driver renders using the
Linux host GPU (for example an RX 9070 XT through Mesa RADV / Vulkan).

Why this approach: macOS ships its own guest-side driver for the PVG device
(macOS 11 and newer). On a macOS host, Apple's closed ParavirtualizedGraphics
framework implements the host side. On Linux nothing implements it. If we
implement the host side, no guest-side Metal driver has to be written.

Status: Phase 0 (research). See docs/plan.md.

Layout:

- AGENTS.md          instructions for AI coding agents working on this repo
- CLAUDE.md          imports AGENTS.md for Claude Code
- docs/plan.md       phases, exit criteria, risks
- docs/findings.md   verified facts with sources
- scripts/           helper scripts (recon-guest.sh runs inside the macOS guest)
