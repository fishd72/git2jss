#!/bin/bash

prlctl set W10-DOI --cpus 2 --memsize 2048 --select-boot-device off --device-bootorder "hdd0" --videosize 256 --3d-accelerate off --sync-host-printers off --sync-default-printer off --autostop suspend --on-shutdown close --on-window-close suspend --nested-virt off  --lock-edit-settings on --shf-host off --shf-host-defined off --shf-guest off