# System Integration Overview
## Team's Goal:
- Integrate subsystems developed by other teams with the on-board processing system, as well as other subsystems.

## Custom RTL IP & Interfacing with PS Tutorial:
1. It is recommended to take a look and familiarize oneself with the tutorial at the following link in order to better understand the general design flow for the ultra96 board.
   - In the following, I will explain how we can modify this flow to add in our own RTL modules using the Vivado "Create AXI4 Peripheral" tool.
   - I also recommend this site if you are interested in learning more about AXI : https://zipcpu.com/blog/2022/05/07/learning-axi.html
2. First, make sure your RTL design has been fully completed and tested, as this is of course crucial for it to work within a larger design
3. Once you are sure it is functioning correctly, add it to a Vivado project if you have not already done so.
4. Within the Vivado project, go to Tools > Create and Package New IP > Create AXI4 Peripheral
   - Vivado will ask you for some basic information, such as the name of your new IP, location, etc. After this, click Next.
   - Now, Vivado will ask for some information about your IP, such as interface type, mode, and number of registers. 
   - <img width="856" height="582" alt="image" src="https://github.com/user-attachments/assets/8b105e13-ac91-4970-8aa0-0f758130cf64" />
   - After this, choose to add the IP to the repository so we will be able to add it to the block design later on. Click Finish.

5. Now, we need to modify the generated Verilog HDL code for the IP
   - After creating the IP, there should be a new directory within the ip_repo directory that you saved your IP to, with the name you gave it
   - Within this directory, there will be an 'hdl/' directory
   - Add your relevant RTL code/module(s) to this directory.
   - The file called [ip_name].v is the top level file of the ip - within this module, you must instantiate your RTL design, connect it's inputs and outputs to the AXI interface module, and add any additional ports/parameters/additional logic you want
   - The file called [ip_name]_S00_AXI.v contains the AXI interface wrapper, and provides logic for all the interface data signals, handshaking, provides some memory mapped registers, and more. Here is where you might modify the provided code to expose certain signals in your RTL to the PS.
   - 6. Finally, your IP should be ready to be added to the block diagram - from this point on everything is very similar to the HLS tutorial linked above.
