# DPDK

- [DPDK](#dpdk)
  - [System Requirements](#system-requirements)
  - [Pre-Setup of DPDK Machines](#pre-setup-of-dpdk-machines)
      - [Run DPDK Config playbook](#run-dpdk-config-playbook)
  - [Hugepages](#hugepages)
  - [DPDK Build](#dpdk-build)
  - [Linux Drivers](#linux-drivers)
    - [VFIO](#vfio)
      - [VFIO no-IOMMU Mode](#vfio-no-iommu-mode)
  - [Interface Binding](#interface-binding)
  - [DPDK Sample Apps](#dpdk-sample-apps)

## System Requirements
DPDK specific requirement: https://doc.dpdk.org/guides/linux_gsg/sys_reqs.html

**Test Machines:**
```
OS: RHEL/CentOS 9
No. of Machines: 2
CPU: 4
Memory: 4GB
NIC:
  eth0: For SSH connection
  eth1: For DPDK enabled application
```

## Pre-Setup of DPDK Machines
***
[dpdk.yml](./ansible/dpdk.yml) ansible playbook configure DPDK machines as below. Review [vars](./ansible/vars/main.yml) before running the playbook
- Installing epel repo on `RedHat` based systems
- Install `Development` tools
- Install pip modules requied for DPDK build.
- Download DPDK source
- Configure `Hugepages`

#### Run DPDK Config playbook
```bash
./dpdk.sh <inventory_file>
```


## Hugepages
***
Hugepages being set using `dpdk.yml` playbook. DPDK also provides `dpdk-hugepages.py` utility to set hugepages on system.
```bash
./usertools/dpdk-hugepages.py
```
**NOTE:** `hugepages` are configured using `dpdk.yml` playbook.

## DPDK Build
***
> TODO: Write a script for below steps

```bash
$ tar -xf dpdk-24.03.tar.xz
$ cd dpdk-24.03
$ meson build
$ ninja -C build
```

## Linux Drivers
***
**Official Documentation:** https://doc.dpdk.org/guides/linux_gsg/linux_drivers.html#

- [Bifurcated Driver](https://doc.dpdk.org/guides/linux_gsg/linux_drivers.html#bifurcated-driver)
  - More about the bifurcated driver can be found in NVIDIA [bifurcated PMD](https://www.dpdk.org/wp-content/uploads/sites/35/2016/10/Day02-Session04-RonyEfraim-Userspace2016.pdf) presentation.
- [VFIO](https://doc.dpdk.org/guides/linux_gsg/linux_drivers.html#vfio)
- [UIO](https://doc.dpdk.org/guides/linux_gsg/linux_drivers.html#uio)
  - **WARNING:** Using UIO drivers is inherently unsafe due to this method lacking IOMMU protection, and can only be done by root user.
  - In situations where using VFIO is not an option, there are alternative drivers one can use. In many cases, the standard uio_pci_generic module included in the Linux kernel can be used as a substitute for VFIO. 
- [vfio vs uio](https://edc.intel.com/content/www/us/en/design/products/ethernet/config-guide-e810-dpdk/linux-drivers/#:~:text=VFIO%20driver%20is%20a%20robust,user%20space%2C%20and%20register%20interrupts.)

### VFIO
VFIO is a robust and secure driver that relies on IOMMU protection. 

**NOTE:** Before implementing DPDK PMD Drivers, check `IOMMU` in [Additional Resources](./docs/resources.md) for more information.

To make use of VFIO, the vfio-pci module must be loaded:
```bash
modprobe vfio-pci
```

#### VFIO no-IOMMU Mode
Usually in case of VMs, machine may not have IOMMU enabled. VFIO also supports [no-IOMMU mode](https://doc.dpdk.org/guides/linux_gsg/linux_drivers.html#vfio-noiommu). Along with enabling `vfio-pci` module, also enable `no-IOMMU` mode, by default it's off.

```bash
# To enable during run-time
modprobe vfio-pci
echo 1 > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode

# To enable permanently
cat > /etc/modules-load.d/vfio.conf <<EOF
vfio-pci
EOF

cat > /etc/modprobe.d/vfio-noiommu.conf <<EOF
options vfio enable_unsafe_noiommu_mode=1
EOF
```

## Interface Binding
***
**Pre-requisites:**
- Interface that need to be managed by DPDK should not be active in kernel routing table
```bash
# Delete eth1 routes
ip r|egrep eth1| awk -F"proto" '{print "ip route delete "$1}'|sh

```
- Below util shows current mapping, both interfaces are managed by kernel
  > Missing `Active` status indicates interface is not in routing table
```bash
[cloud-user@dpdk01 dpdk-24.03]$ ./usertools/dpdk-devbind.py --status-dev net

Network devices using kernel driver
===================================
0000:01:00.0 'Virtio 1.0 network device 1041' if=eth0 drv=virtio-pci unused= *Active*
0000:02:00.0 'Virtio 1.0 network device 1041' if=eth1 drv=virtio-pci unused= *Active*
```

**WARNING:** After mapping interface to DPDK, you will loose ssh connection to VM. SSH to VM on `eth0`, and use other interface to dpdk enabled apps. After controlling interface using dpdk, interface won't be visible in `ip` command.

**Map eth1 to DPDK PMD Driver**
```bash
./usertools/dpdk-devbind.py --bind=vfio-pci eth1

./usertools/dpdk-devbind.py --status-dev net

Network devices using DPDK-compatible driver
============================================
0000:02:00.0 'Virtio 1.0 network device 1041' drv=vfio-pci unused=

Network devices using kernel driver
===================================
0000:01:00.0 'Virtio 1.0 network device 1041' if=eth0 drv=virtio-pci unused=vfio-pci *Active*
```

## DPDK Sample Apps
Check [Sample Apps](./docs/sample-apps.md).