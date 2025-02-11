#!/bin/bash

# Linux Networking Commands Reference

# 1. Display network interfaces and IP addresses
ip addr show  # Shows detailed interface information
ip -br addr   # Shows concise interface info
ifconfig      # Legacy command (use 'ip' instead)

# 2. Display and manage network links
ip link show  # Show network interfaces
ip link set eth0 up    # Enable interface eth0
ip link set eth0 down  # Disable interface eth0

# 3. Display and manipulate routing tables
ip route show   # Show routing table
ip route add default via 192.168.1.1  # Set default gateway
ip route del default  # Remove default route

# 4. Test network connectivity
ping -c 4 google.com   # Send 4 ICMP packets to test connectivity
traceroute google.com  # Trace route to a host (install if missing)
mtr google.com         # Real-time traceroute (alternative to traceroute)

# 5. DNS resolution tools
dig google.com   # Query DNS for domain info (install if missing)
host google.com  # Simpler alternative to dig
nslookup google.com  # Query DNS records (deprecated in some distros)

# 6. Display and manage firewall rules
iptables -L -v -n  # List iptables rules (for IPv4)
ip6tables -L -v -n  # List iptables rules (for IPv6)
firewalld --list-all  # Show firewall rules (if using firewalld)

# 7. Monitor network activity
netstat -tulnp   # Show active listening ports and processes (use 'ss' instead)
ss -tulnp        # Modern alternative to netstat
iftop            # Monitor real-time bandwidth usage (install if missing)
nload            # Display network traffic in real-time

# 8. Packet capturing and analysis
tcpdump -i eth0 port 80  # Capture HTTP traffic on eth0
wireshark  # GUI tool for deep packet analysis (install separately)

# 9. Manage ARP cache
arp -a       # Display ARP cache
ip neigh show  # Modern alternative to 'arp'
ip neigh flush all  # Clear ARP cache

# 10. Test open ports and services
nc -zv 192.168.1.1 22  # Check if port 22 is open on 192.168.1.1
nmap -p 22,80 192.168.1.1  # Scan specific ports on a host (install if missing)

# 11. Enable or disable IP forwarding (useful for routing)
echo 1 > /proc/sys/net/ipv4/ip_forward  # Enable
sysctl -w net.ipv4.ip_forward=1  # Another way to enable
echo 0 > /proc/sys/net/ipv4/ip_forward  # Disable

# 12. View and manage active connections
ss -antp  # Show active TCP connections
lsof -i :80  # Show processes using port 80

# 13. Configure static IP (example for eth0)
# Edit /etc/network/interfaces (Debian/Ubuntu)
# or /etc/sysconfig/network-scripts/ifcfg-eth0 (RHEL/CentOS)

# 14. Restart networking services
systemctl restart networking  # Restart networking service (Debian/Ubuntu)
systemctl restart NetworkManager  # Restart NetworkManager (RHEL-based distros)

# End of file
