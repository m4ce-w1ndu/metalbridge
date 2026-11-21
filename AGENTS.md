# Agent instructions

## Project
Implement the host side of Apple's paravirtualized GPU (PVG) device on Linux so
that x86-64 macOS guests under QEMU/KVM get accelerated Metal graphics from the
Linux host GPU. Read README.md, docs/plan.md and docs/findings.md first.

## Environment
- Host: CachyOS (KDE Plasma), GPU AMD RX 9070 XT (RDNA4), Mesa/RADV for Vulkan.
- Guest: macOS x86-64 (Sequoia 15 or Tahoe 26) in QEMU/KVM.
- Primary languages: Rust for new host-side code; C where QEMU requires it.

## Rules
- All file contents must be in English: code, comments, docs, commit messages.
- The user cannot type curly braces on their keyboard. Always deliver complete
  files, and give shell commands that contain no curly braces (no brace
  expansion, no shell parameter braces, no inline code blocks they must type).
- Prefer the simplest possible solution. Do not change the host system more than
  needed. Before anything privileged or hard to undo (kernel modules, VFIO
  binding, bootloader or GRUB changes), explain it and ask first.
- Do not commit Apple binaries or extracted system files. Keep them under
  extracted/ which is git-ignored. Only commit our own notes, tools and code.
- Never present guessed protocol details as facts. Mark each item in docs as
  VERIFIED (with how), HYPOTHESIS, or UNKNOWN.
- Keep a dated log in docs/log.md: what was tried, the result, next step.

## Working style
- Work phase by phase as listed in docs/plan.md; do not skip ahead.
- When a phase ends, update docs/plan.md exit criteria and docs/findings.md.
- If a step needs the user's physical action (for example access to a Mac),
  say so clearly and stop instead of guessing.
