#!/bin/sh
# SPDX-License-Identifier: LGPL-2.1-or-later
set -eu

cd "${1:?}"

unset permissive
if [ "${2:-}" = "-p" ]; then
    permissive=1
    shift
else
    permissive=0
fi

if [ "${2:-}" != "-n" ]; then (
    [ -z "$permissive" ] || set +e
    set -x

    curl --fail -L -o usb.ids 'http://www.linux-usb.org/usb.ids'
    curl --fail -L -o pci.ids 'http://pci-ids.ucw.cz/v2.2/pci.ids'
    curl --fail -L -o ma-large.txt 'http://standards-oui.ieee.org/oui/oui.txt'
    curl --fail -L -o ma-medium.txt 'http://standards-oui.ieee.org/oui28/mam.txt'
    curl --fail -L -o ma-small.txt 'http://standards-oui.ieee.org/oui36/oui36.txt'
    curl --fail -L -o pnp_id_registry.csv 'https://uefi.org/uefi-pnp-export'
    curl --fail -L -o acpi_id_registry.csv 'https://uefi.org/uefi-acpi-export'
) fi

set -x
./acpi-update.py >20-acpi-vendor.hwdb.base
patch -p0 -o- 20-acpi-vendor.hwdb.base <20-acpi-vendor.hwdb.patch >20-acpi-vendor.hwdb
diff -u 20-acpi-vendor.hwdb.base 20-acpi-vendor.hwdb >20-acpi-vendor.hwdb.patch && exit 1

./ids_parser.py
