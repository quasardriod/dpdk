# DPDK Sample Apps
Check official [Compiling the Sample Applications](https://doc.dpdk.org/guides/sample_app_ug/compiling.html) guide for detailed information.

## helloword app
### Compile
```bash
$ cd build
$ meson configure -Dexamples=helloworld
$ ninja
```
### Run app
```bash
cd dpdk-24.03/build/examples/

# To check run options
./dpdk-helloworld -h

# Run app
./dpdk-helloworld -l 2-3 -n 1 
EAL: Detected CPU lcores: 4
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: VFIO support initialized
EAL: Probe PCI driver: net_virtio (1af4:1041) device: 0000:01:00.0 (socket -1)
eth_virtio_pci_init(): Failed to init PCI device
EAL: Requested device 0000:01:00.0 cannot be used
EAL: Probe PCI driver: net_virtio (1af4:1041) device: 0000:02:00.0 (socket -1)
EAL: Using IOMMU type 8 (No-IOMMU)
TELEMETRY: No legacy callbacks, legacy socket not created
hello from core 3
hello from core 2
EAL: Releasing PCI mapped resource for 0000:02:00.0
EAL: Calling pci_unmap_resource for 0000:02:00.0 at 0x1100800000
EAL: Calling pci_unmap_resource for 0000:02:00.0 at 0x1100801000

```

