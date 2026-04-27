# NetCut-cli for Termux: Compatibility and Installation Guide

This document outlines the steps and considerations for making the NetCut-cli project runnable within the Termux environment on Android devices.

## Identified Compatibility Issues

The NetCut-cli project, as provided, relies on several Linux-specific features and privileges that may not be directly available or function identically within Termux:

1.  **Raw Socket Access (`AF_PACKET`, `SOCK_RAW`)**: The core functionality of NetCut-cli, which involves ARP spoofing, requires the creation and manipulation of raw sockets. These operations typically demand root privileges on a standard Linux system. In Termux, raw socket access is severely restricted due to Android's security model. Without root access on the Android device, it is highly probable that the application will not be able to create or use raw sockets, rendering the ARP spoofing functionality inoperable.

2.  **Linux-specific Headers and `ioctl` Calls**: The project utilizes headers like `<linux/if_arp.h>` and makes `ioctl` calls (e.g., `SIOCGIFINDEX`, `SIOCGIFHWADDR`) to retrieve network interface information and MAC addresses. While Termux provides a Linux-like userland, the underlying Android kernel's network stack might not expose these `ioctl` functionalities in the same manner or with the necessary permissions.

3.  **Network Interface Enumeration (`getifaddrs`)**: Although `getifaddrs` is a POSIX standard, its behavior and the level of detail it provides about network interfaces within the Termux environment might be limited. This could affect the scanner's ability to correctly identify active network interfaces and their associated IP addresses and netmasks.

## Proposed Solutions and Workarounds

To maximize the chances of running NetCut-cli in Termux, consider the following:

### 1. Root Access (Highly Recommended for Full Functionality)

For full ARP spoofing capabilities, **root access on your Android device is almost certainly required**. Even with root, you might need to grant specific permissions to Termux or the compiled executable to allow raw socket operations. Without root, the `netcut-cli` application will likely fail when attempting to open raw sockets.

### 2. Termux Package Installation

Termux provides a `clang` compiler and `make` utility, which are essential for building C++ projects. Additionally, you might need development headers for networking libraries. The `setup.sh` script below will attempt to install these.

### 3. Potential Code Modifications (If Root is Not an Option)

If root access is not feasible, the ARP spoofing functionality will likely be non-functional. In such cases, the tool's utility would be limited to network scanning (if `getifaddrs` and basic socket operations work). Significant code changes would be required to adapt the project to use higher-level networking APIs available without root, which would fundamentally alter its purpose.

## Installation and Compilation in Termux

Follow these steps to install necessary dependencies and compile NetCut-cli in Termux:

1.  **Update Termux and Install Build Tools**:
    ```bash
    pkg update && pkg upgrade
    pkg install -y clang make
    ```

2.  **Install Networking Development Headers**:
    ```bash
    pkg install -y libpcap-dev libnet-dev
    ```
    *Note: `libpcap-dev` and `libnet-dev` might provide some of the necessary headers and functions for network manipulation, though direct raw socket access might still be an issue.* 

3.  **Navigate to the Project Directory**:
    Assuming you have extracted `NetCut-cli.zip` to a directory named `NetCut-cli`:
    ```bash
    cd NetCut-cli
    ```

4.  **Compile the Project**:
    ```bash
    make
    ```

## Running NetCut-cli in Termux

After successful compilation, you can attempt to run the executable:

```bash
./bin/main
```

**Important Considerations for Running:**

*   **Permissions**: If the program fails with permission errors related to network operations, it is almost certainly due to a lack of root privileges or insufficient capabilities granted to Termux. You might see errors like "Failed to open socket." or "Failed to get interface index."
*   **Network Interface Names**: Termux network interface names might differ from standard Linux distributions (e.g., `wlan0` vs. `eth0`). The program's reliance on `getifaddrs` should ideally handle this, but be aware of potential discrepancies.

## Conclusion

While NetCut-cli can be compiled in Termux, its core ARP spoofing functionality is highly dependent on raw socket access and specific kernel features that are typically restricted on non-rooted Android devices. For full functionality, rooting your device and granting appropriate permissions to Termux is likely necessary. Without root, the tool's capabilities will be severely limited, potentially to just network scanning if that portion of the code can execute successfully.
