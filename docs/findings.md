# Findings

Status tags: VERIFIED (source given), HYPOTHESIS, UNKNOWN.

## About the device (VERIFIED, from the QEMU apple-gfx patch series and source)
- The PVG device is a PCI device with a single memory-mapped BAR. The VM
  monitor passes MMIO reads and writes through to the framework and forwards
  the interrupts it raises to the guest.
- The guest drivers ship with macOS 11 and newer. Together with the host
  framework they give the guest Metal 3D, GPU compute and window compositing.
- Bulk data moves through shared memory. The VM monitor implements callbacks
  that create "tasks" (a contiguous host virtual address range) and map
  guest physical memory ranges into them. Several tasks can exist at once.
- The data protocol between guest and host is undocumented and proprietary.
  The public API only helps establish the communication channel.
- QEMU's apple-gfx-pci device targets x86-64 macOS guests and requires a macOS
  host, because it drives Apple's framework. An arm64 MMIO variant exists too.
- The PCI vendor and device IDs come from constants named PG_PCI_VENDOR_ID and
  PG_PCI_DEVICE_ID in the framework header. UNKNOWN: the numeric values, to be
  read from the macOS SDK header or from the guest with ioreg.
- The QEMU PCI variant also sets an option ROM path. UNKNOWN: what the ROM
  contains and whether the guest driver needs it.

## Public API surface (VERIFIED, Apple documentation and Rust bindings listing)
- PGDeviceDescriptor, PGDevice, PGDisplay, plus a physical memory range struct.
- PGDisplay provides a mode list and cursor position and lets the host
  intercept presented frames.

## Open questions
- Exact guest kext and Metal bundle names on the target macOS version.
- Whether the guest driver refuses to start without the option ROM.
- Whether the command stream is plain, versioned, compressed or obfuscated.
- Differences between macOS Sequoia and Tahoe guest drivers.
- Whether the user has access to a Mac that can run QEMU apple-gfx-pci to record
  ground-truth traffic.

## Sources
- QEMU patch series "macOS PV Graphics and new vmapple machine type" (cover letter
  and patches by Phil Dennis-Jordan), on patchwork.kernel.org
- QEMU source files hw/display/apple-gfx.m and hw/display/apple-gfx-pci.m
- Apple developer documentation for the ParavirtualizedGraphics framework
- docs.rs/objc2-paravirtualized-graphics (type listing)
