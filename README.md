# MIPS-Black-Dot-Mover
MARS MIPS Program that utilizes the MARS bitmap display tool

## INSTRUCTION MANUAL
1. Download the MARS MIPS Simulator here: [Jarrett Billingsley Enhanced MARS MIPS Simulator](https://jarrettbillingsley.github.io/teaching/classes/cs0447/software.html)
2. Open the black-dot-mover.asm file in MARS
3. In the MARS menu click **TOOLS**, then **BITMAP DISPLAY**
4. Change the settings to match the following:
  * unit width in pixels: 4
  * unit height in pixels: 4
  * display width in pixels: 256
  * display height in pixels: 256
  * base address for display: 0x10008000 ($gp)
5. Then click **Connect to MIPS**
6. Assemble the program (**Run → Assembly, or F3**)
7. Then run the program (**Run → Go, or F5**)
8. In the **MARS Messages** window read the instructions and enter the appropriate keys to move the black dot around the screen
