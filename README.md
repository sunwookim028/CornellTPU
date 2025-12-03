# CornellTPU
The Cornell TPU; or maybe the Big Red Unit (BRU)?

How to use tpu:

1. Enter virtual environment : ./venv/Scripts/Activate.ps1
1. Enter compiler folder: cd compiler
2. Write your code in tpu_frontend.py file in frontend folder in main function where it says write code (you can use whatever functions are exposed in tpu_txt.py file in backend)
3. Run frontend:  python -m frontend.tpu_frontend
4. Run backend: python backend/assembler.py mlp_instruction_trace.txt tpu_instructions.txt
5. Scp folder onto board (enter password): scp -r .\tpu_deploy\ xilinx@132.236.59.64:~
6. SSH onto board: ssh xilinx@132.236.59.64
7. Go into folder copied: cd tpu_deploy
8. Run code on board: sudo python3 host.py CornellTPU.bit tpu_instructions.txt
9. Whatever you requested in store commands will be printed.

