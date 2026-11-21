#!/bin/bash
# Collect read-only information about the paravirtual GPU stack inside a macOS guest.
# Run this in Terminal inside the guest. Output goes to the folder pvg-recon in the
# home directory. Copy that folder to the host afterwards.

out="$HOME/pvg-recon"
mkdir -p "$out"

echo "Collecting system info..."
sw_vers > "$out/system.txt" 2>&1
uname -a >> "$out/system.txt" 2>&1
sysctl machdep.cpu.brand_string >> "$out/system.txt" 2>&1
csrutil status >> "$out/system.txt" 2>&1
nvram boot-args >> "$out/system.txt" 2>&1

echo "Collecting display and PCI info..."
system_profiler SPDisplaysDataType > "$out/displays.txt" 2>&1
system_profiler SPPCIDataType > "$out/pci.txt" 2>&1

echo "Collecting IORegistry trees..."
ioreg -l -w0 > "$out/ioreg-full.txt" 2>&1
ioreg -r -c IOAccelerator -l -w0 > "$out/ioreg-accelerator.txt" 2>&1
ioreg -r -c IOPCIDevice -l -w0 > "$out/ioreg-pci.txt" 2>&1

echo "Collecting loaded kernel extensions..."
kmutil showloaded > "$out/kexts-loaded.txt" 2>&1

echo "Searching for paravirtual GPU files..."
find /System/Library /Library /usr/lib \( -iname "*paravirt*" -o -iname "*metal*driver*" \) 2>/dev/null > "$out/paravirt-files.txt"

echo "Collecting recent log lines about paravirtual graphics..."
log show --last 10m --style compact 2>/dev/null | grep -i paravirt > "$out/paravirt-log.txt"

echo "Done. Results are in $out"
