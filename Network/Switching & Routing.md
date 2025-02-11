# Network Concepts: Switching and Routing

## 1. Introduction

Networking is the backbone of modern IT infrastructure, enabling devices to communicate and share data. Two foundational concepts in networking are **switching** and **routing**. These functions work at different layers of the OSI (Open Systems Interconnection) model and play distinct roles in moving data through a network.

This documentation will introduce you to these basic concepts, define their roles, and explain how they work together to form a functioning network.

---

## 2. Switching

### 2.1 Definition

- **Switching** is a process that occurs at the Data Link Layer (Layer 2) of the OSI model.
- It involves connecting devices within the same local area network (LAN) so that they can communicate with each other.
- Switches use **MAC (Media Access Control) addresses** to forward frames between devices.

### 2.2 How Switching Works

- **Frame Forwarding:**  
  When a device sends a frame, the switch inspects its destination MAC address. If the MAC address is found in the switch’s MAC address table, the frame is forwarded only to the port where that device is connected. Otherwise, the switch floods the frame to all ports except the one it was received on.
  
- **MAC Address Table:**  
  Switches build a MAC address table by learning the source addresses of incoming frames. This table is then used to make intelligent forwarding decisions.
  
- **Collision Domains:**  
  Each port on a switch represents its own collision domain, reducing collisions compared to a hub. This improves network efficiency.
  
- **Broadcast Domains:**  
  All ports on a switch typically belong to the same broadcast domain (unless VLANs are configured), meaning a broadcast frame will be sent to all ports.

### 2.3 Types of Switching

- **Store-and-Forward:**  
  The switch receives the entire frame, checks it for errors (using the Frame Check Sequence), and then forwards it if valid.
  
- **Cut-Through:**  
  The switch begins forwarding the frame as soon as it reads the destination MAC address. This method reduces latency but does not perform error checking.

- **Fragment-Free:**  
  A compromise between store-and-forward and cut-through. The switch reads the first 64 bytes (where collisions are most likely) before forwarding, offering some error detection with reduced latency.

---

## 3. Routing

### 3.1 Definition

- **Routing** is the process of selecting paths in a network along which to send network traffic.
- It operates at the Network Layer (Layer 3) of the OSI model.
- Routers use **IP addresses** to determine the best path for forwarding packets between different networks or subnets.

### 3.2 How Routing Works

- **Routing Tables:**  
  Routers maintain routing tables that contain information about network destinations and the associated next hops.
  
- **Packet Forwarding:**  
  When a packet arrives at a router, the router inspects its destination IP address, consults its routing table, and forwards the packet to the appropriate next hop.
  
- **Routing Protocols:**  
  Routers exchange information using routing protocols such as OSPF (Open Shortest Path First), BGP (Border Gateway Protocol), and RIP (Routing Information Protocol) to build and maintain accurate routing tables.
  
- **Inter-Network Communication:**  
  Routing enables communication between devices in different networks. While a switch handles local traffic within a LAN, routers manage traffic that crosses network boundaries (e.g., from a LAN to the Internet).

---

## 4. Switching vs. Routing

### 4.1 Layer of Operation
- **Switching:** Operates at Layer 2 (Data Link Layer), using MAC addresses.
- **Routing:** Operates at Layer 3 (Network Layer), using IP addresses.

### 4.2 Scope
- **Switching:** Typically used within a single broadcast domain (e.g., a LAN).
- **Routing:** Used to connect multiple networks or subnets, enabling inter-network communication.

### 4.3 Performance Considerations
- **Switching:** Generally faster for local traffic since decisions are made based on MAC addresses and stored in hardware.
- **Routing:** Involves more complex decision-making, which may introduce latency but is essential for directing traffic across diverse networks.

### 4.4 Use Cases
- **Switching:** Ideal for environments where devices need to communicate within the same network segment (e.g., office LANs, data centers).
- **Routing:** Necessary for connecting different network segments, such as linking branch offices, data centers, or connecting an internal network to the Internet.

---

## 5. Relevance to Container and Kubernetes Networking

While the basic concepts of switching and routing originate from traditional network architectures, they form the basis of modern container networking. In container environments:

- **Overlay Networks:**  
  Container platforms often create overlay networks that abstract physical network details. Underneath, these overlays rely on switching and routing principles to manage container-to-container communication across different hosts.

- **Kubernetes Networking:**  
  Kubernetes networking builds on these concepts to provide a flat network model, ensuring that all pods can communicate with each other regardless of the node they reside on. Advanced networking solutions (e.g., CNI plugins) leverage switching and routing techniques to achieve scalability and isolation.

---

## 6. Conclusion

Understanding the fundamentals of switching and routing is essential for grasping how modern networks—and by extension, container and Kubernetes networks—function. Switching provides the mechanism for local, fast, and efficient data transfer within a LAN, while routing enables communication across different networks by intelligently forwarding packets based on IP addresses. These core concepts lay the groundwork for more advanced networking configurations that you will encounter in container orchestration platforms like Kubernetes.
