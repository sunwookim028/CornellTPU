# CornellTPU
The Cornell TPU; or maybe the Big Red Unit (BRU)?

## How to use Cornell TPU:

1. Enter virtual environment : `./venv/Scripts/Activate.ps1`
1. Enter compiler folder: `cd compiler`
2. Write your code in frontend/tpu_frontend.py file in main function where it says write code (you can use whatever functions are exposed in tpu_txt.py file in backend)
3. Run frontend:  `python -m frontend.tpu_frontend` (generates IR in mlp_instruction_trace.txt)
4. Run backend: `python backend/assembler.py mlp_instruction_trace.txt tpu_instructions.txt`  (converts IR in mlp_instruction_trace.txt into instructions for TPU in tpu_instructions.txt and auto-generates pynq host.py file. Packages both alongside bitstream in tpu_deploy folder)
5. Scp tpu_deploy folder onto board: `scp -r .\tpu_deploy\ xilinx@132.236.59.64:~` , (enter password), (you need to be connected to ECE Departmental VPN)
6. SSH onto board: `ssh xilinx@132.236.59.64` (enter password)
7. Go into folder copied: `cd tpu_deploy`
8. Run code on board: `sudo python3 host.py CornellTPU.bit tpu_instructions.txt`
9. Whatever data you requested in store commands will be printed on terminal.
10. Once you are done you can delete folder from board:  `cd ..` ,  `rm -rf tpu_deploy`


## List of instructions Cornell TPU currently supports:

- load(start_addr, np_array)
- store(start_addr, length, name)
- matmul(W, X, Z, m=4)
- add(X, Y, Z)
- sub(X, Y, Z)
- mul(X, Y, Z)
- relu(X, Zero_addr, Y)
- relu_derivative(X, Zero_addr, Y)

Information on specific details for each function are defined in function headers for each function in compiler/backend/tpu_txt.py