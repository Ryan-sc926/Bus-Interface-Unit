# Bus-Interface-Unit
1. Introduction:

   The purpose of this project is to design a generic Bus Interface Unit (BIU) that serves as a bridge between the Hummingbirdv2 E203 RISC-V processor and coprocessors. Any coprocessor that complies with the defined handshake protocol at the BIU–coprocessor interface can be controlled by the HBirdv2 E203 processor through this BIU. 
The HBirdv2 E203 processor supports four custom instructions, each of which can be defined to perform user-specific operations. In this BIU design, these four custom instructions are dedicated to three functions: Load (fetch data from memory to the coprocessor), Store (write data from the coprocessor to memory), and Write Configuration Register (update configuration registers in the BIU to control coprocessor behavior). 
For more details on the custom instructions and the HBirdv2 E203 processor’s interaction with coprocessors, refer to:

https://github.com/riscv-mcu/e203_hbirdv2 

https://doc.nucleisys.com/hbirdv2/core/core.html#nice

3. Features:
   
   Since the HBirdv2 E203 processor supports four custom instructions, it can control up to four independent coprocessors, with each custom instruction dedicated to a single coprocessor. The generic BIU is configurable and supports variable-length data transmission, allowing data to be read from or written to memory in any number of words per instruction. It also incorporates data buffering to handle scenarios where one side operates faster than the other, and includes data width conversion to match the requirements of both the coprocessor and the memory.
   
4. Block Diagram:
   
   <img width="975" height="624" alt="image" src="https://github.com/user-attachments/assets/73e24442-4fb8-464c-b536-a301accdd9b7" />

5. Configurable Parameters:
 
   <img width="2000" height="645" alt="image" src="https://github.com/user-attachments/assets/2599cf63-82f4-467a-b1b4-4348945dc77d" />

6. Interface Specification:
 
   <img width="1456" height="1209" alt="image" src="https://github.com/user-attachments/assets/1f5e5fca-d31e-4ceb-a012-a81f40b31fab" />

7. Example Operation and Waveforms:
   
    <img width="904" height="339" alt="image" src="https://github.com/user-attachments/assets/cd32e1b9-8faa-43e4-8d8c-57e1ccabe5d0" />
    <img width="898" height="337" alt="image" src="https://github.com/user-attachments/assets/18002657-e46b-4c7a-a280-5ce121ae3b9f" />
    <img width="975" height="284" alt="image" src="https://github.com/user-attachments/assets/7931487f-82be-4614-8029-f9a5cb35313a" />



