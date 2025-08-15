# APB Master-Slave Interface in Verilog

## Overview
This project implements an **Advanced Peripheral Bus (APB) Master-Slave Interface** in Verilog. The APB protocol is a part of the AMBA (Advanced Microcontroller Bus Architecture) specification and is widely used for connecting low-bandwidth peripherals to higher-performance bus architectures. This design features an APB master module that communicates with multiple APB slave modules, ensuring efficient data transfer and peripheral management.

The project aims to provide a functional and scalable APB interface that can be easily extended for complex SoC (System-on-Chip) designs. It includes an APB master controller, multiple slave modules, and a storage module to simulate memory operations.

## Project Output Image

<img width="1260" height="445" alt="image" src="https://github.com/user-attachments/assets/dde1fe11-855f-42e2-8243-7ce01c39678a" />

## Features
- **APB Master Implementation**: The master controls the transaction flow using a Finite State Machine (FSM) that manages the **IDLE, SETUP, and ACCESS** phases.
- **Support for Multiple Slaves**: The design includes four APB slave modules, which can be expanded as needed.
- **Read and Write Operations**: The master communicates with the slaves through standard APB signals and controls memory read/write transactions.
- **Byte-Level Write Support**: The design allows selective byte writing using the `pstrb` (byte-enable) signal.
- **Storage Module for Simulation**: A simple memory module (`storage`) is included to mimic register-based memory operations.
- **Error Detection (`pslverr`)**: Provides an error signal when an invalid transaction occurs.
- **Ready Signal (`pready`)**: Indicates the completion of an operation for proper transaction handling.

## Modules and Functionality
### 1. `apb_master`
The **APB master** module is responsible for controlling communication between multiple slaves. It selects the appropriate slave device based on the `psel` signal and manages transaction sequencing through an FSM.

## APB_Master schematic Image
<img width="1824" height="668" alt="image" src="https://github.com/user-attachments/assets/c5464312-fc6c-4fc4-8186-e42652f0a444" />


#### Key Functions:
- Implements a **state machine** to control the APB transfer process.
- Generates **slave selection signals (`psel`)** to communicate with different slaves.
- Multiplexes the **read data (`prdata`)** from the selected slave.
- Aggregates **slave ready (`pready`)** signals to determine transaction completion.
- Manages **write (`pwrite`) and read operations** based on control signals.

### 2. `apb_slave`
Each **APB slave** acts as a peripheral that can receive and respond to master transactions. It processes read and write requests by interacting with the memory (`storage` module) and generates appropriate response signals.

## APB_slave schematic Image
<img width="1208" height="495" alt="image" src="https://github.com/user-attachments/assets/807a9543-ae4c-49b5-9341-fcd2461f9a0e" />


#### Key Functions:
- Decodes **address (`paddr`) and control signals** to determine read/write operations.
- **Handles memory transactions** based on the `pwrite` and `pwdata` signals.
- Supports **byte-wise data writes** using the `pstrb` (byte strobe) signal.
- Provides a **valid data output (`prdata`)** during read operations.
- Generates **error (`pslverr`) and ready (`pready`) signals** to indicate transaction success or failure.

### 3. `storage`
The **storage module** represents a simple memory unit that can store and retrieve data for slave transactions. It is implemented as an array of registers that simulate peripheral memory.

#### Key Functions:
- Maintains a **32-word memory array** (32-bit per word) for transaction storage.
- Handles **write transactions** by storing data based on the `pstrb` mask.
- Provides **read access** when requested by the master.
- Ensures correct memory operation based on APB protocol rules.

## APB Protocol Phases
APB follows a **three-phase** transaction protocol:
1. **IDLE Phase**: No active transaction; the system waits for new commands.
2. **SETUP Phase**: The master sets up the address and control signals before initiating a transfer.
3. **ACCESS Phase**: The actual data transfer (read/write) occurs, and the transaction is completed when `pready` is asserted.

## How to Use
1. **Instantiate the APB Master Module** and connect it to one or more APB Slaves.
2. **Drive the required input signals** (`paddr`, `pwrite`, `psel`, `penable`, `pwdata`, etc.).
3. **Monitor output signals** (`prdata`, `pready`, and `pslverr`) to check transaction status.
4. **Extend the system by adding more slaves** or modifying the storage module for more complex operations.

## Applications
- **Embedded Systems**: Useful in SoC designs for controlling peripherals such as timers, GPIOs, and UARTs.
- **Microcontroller-Based Designs**: Can be integrated into APB-based systems to handle peripheral communications.
- **Hardware Simulation & Verification**: Serves as a reference design for learning and testing APB protocols.

## Future Enhancements
- **Scalability**: Enable dynamic slave configurations using parameterized Verilog.
- **Advanced Error Handling**: Implement more sophisticated error-checking mechanisms.
- **Memory Initialization Support**: Add memory preloading features to simulate real-world scenarios.
- **Performance Optimization**: Improve transaction efficiency through pipeline techniques.

## License
This project is open-source and can be modified or used as per the applicable license. Contributions and feedback are welcome to improve the design further.

