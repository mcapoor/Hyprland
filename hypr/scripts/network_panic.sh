
#!/bin/bash
# Forcibly restarts network stack

sudo systemctl stop NetworkManager
sudo modprobe -r ath11k_pci ath11k
sudo modprobe ath11k_pci
sudo systemctl start NetworkManager