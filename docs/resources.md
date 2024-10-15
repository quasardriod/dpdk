
- [IOMMU](#iommu)
- [Hugepages](#hugepages)

## IOMMU
- [An Introduction to IOMMU Infrastructure in the Linux Kernel](https://lenovopress.lenovo.com/lp1467-an-introduction-to-iommu-infrastructure-in-the-linux-kernel)
  - https://lenovopress.lenovo.com/lp1467.pdf
- [ Linux IOMMU Support](https://www.kernel.org/doc/html/v5.17/x86/intel-iommu.html)
- [Understanding VFIO and UIO Driver Framework](https://www.youtube.com/watch?v=uOQ5POP8hCs)
- [Kernel-bypass techniques for high-speed network packet processing](https://www.youtube.com/watch?v=MpjlWt7fvrw&t=1120s)
- [An Introduction to PCI Device Assignment with VFIO](https://www.youtube.com/watch?v=WFkdTFTOTpA&t=25s)
- Check is IOMMU is enabled:
```bash
$ sudo dmesg |egrep "DMAR|IOMMU"
$ ls -l /sys/class/iommu/
```
  * Below example of machine with no-IOMMU.
```
# ls -l /sys/class/iommu/
total 0
```
- https://github.com/zylan29/dpdk-pingpong

## Hugepages
Huge page methods:
- HugeTLB pages
  - TLB: Translation Lookaside Buffer
- Transparent HugePages (THP)
Check [Configuring huge pages](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/monitoring_and_managing_system_status_and_performance/configuring-huge-pages_monitoring-and-managing-system-status-and-performance#parameters-for-reserving-hugetlb-pages-at-boot-time_configuring-huge-pages) for more information