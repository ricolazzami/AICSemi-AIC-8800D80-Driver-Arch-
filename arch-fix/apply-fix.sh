#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Jalankan script ini dengan sudo / root:"
  echo "sudo ./arch-fix/apply-fix.sh"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Menerapkan konfigurasi modprobe..."
cp "$SCRIPT_DIR/aic8800.conf" /etc/modprobe.d/aic8800.conf
chmod 644 /etc/modprobe.d/aic8800.conf

echo "==> Menerapkan udev rules anti-suspend..."
cp "$SCRIPT_DIR/99-aic8800-power.rules" /etc/udev/rules.d/99-aic8800-power.rules
chmod 644 /etc/udev/rules.d/99-aic8800-power.rules

echo "==> Reload udev rules..."
udevadm control --reload-rules
udevadm trigger

echo "==> Selesai! Konfigurasi stabilitas & power AIC8800 berhasil diterapkan."
