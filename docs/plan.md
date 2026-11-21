# Plan

## Phase 0: baseline VM
- Run an x86-64 macOS guest (Sequoia 15 or Tahoe 26, the last x86 releases) in
  QEMU/KVM on CachyOS, for example with OSX-KVM, using a basic display device.
- Enable SSH into the guest so scripts can run and logs can be pulled out.
- Take a snapshot of the working state.
- Exit: guest boots, SSH works, snapshot exists.

## Phase 1: static reconnaissance
- Run scripts/recon-guest.sh inside the guest. Copy ~/pvg-recon to the host.
- Identify the guest kext and Metal driver bundle names for the PVG device.
- Extract the binaries (system frameworks live in the dyld shared cache, so use
  an extractor tool) into extracted/ and open them in Ghidra.
- From the guest kext, document: PCI IDs, BAR size, register offsets, doorbells,
  ring buffer setup, interrupt vectors, required PCI capabilities.
- Exit: docs/guest-driver-notes.md with every item tagged VERIFIED, HYPOTHESIS
  or UNKNOWN.

## Phase 2: device stub
- Build a device model that makes the guest driver bind. Evaluate two options:
  a patched QEMU device, or a separate-process device model (for example via
  vfio-user). Choose the simpler one and record the decision.
- Match PCI vendor, device and class IDs, the BAR layout and MSI support.
- Log every MMIO access, every raised interrupt and every guest memory access.
- Exit: the driver binds (visible in ioreg) and the log shows the init handshake.

## Phase 3: protocol decoding
- Ground truth is valuable. A Mac running QEMU with apple-gfx-pci lets us record
  real traffic between the guest driver and Apple's host framework. Ask the user
  whether a Mac is available. Without one, rely on static analysis of the host
  framework and its helper libraries.
- Decode in this order: handshake, memory task create/map/unmap, command
  stream framing, then the Metal command encoding.
- Exit: docs/protocol.md plus recorded test vectors under testdata/.

## Phase 4: display path
- Decode scanout and presented frames, show them in the QEMU display, then
  support the mode list and cursor.
- Note: the guest renders its desktop through Metal on this device, so a usable
  desktop likely needs the command stream decoded first. There is probably no
  early graphical win before this phase.
- Exit: macOS desktop visible at the chosen resolution.

## Phase 5: rendering and compute
- Translate guest Metal work to Vulkan on the host (Mesa RADV on the RX 9070 XT):
  buffers, textures, pipelines, synchronization, and shaders (AIR to SPIR-V).
- Exit: hardware-accelerated compositing, then a Metal sample app.

## Phase 6: hardening
- Version matrix across macOS releases, performance work, packaging.

## Risks
- The protocol is proprietary and may change between macOS releases.
- No reference implementation exists on Linux.
- Intel macOS guests end with Tahoe, so the target is a closing window.
- AIR shader translation is broad work.
