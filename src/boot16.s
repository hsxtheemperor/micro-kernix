.syntax unified        @ Use modern ARM syntax
.cpu cortex-m4         @ Target the Microbit v2 chip
.thumb                 @ Use the compact instruction set

.section .vectors
    .word 0x20020000        @ 0: SP
    .word _start + 1        @ 1: Reset
    .word non_maskable      @ 2: NMI
    .word fault_handler     @ 3: HardFault
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 @ 4-14
    .word systick_handler @ 15: Scheduler Heartbeat
    
    @ Peripheral Interrupts start here
    .word common_wrapper + 1    @ 16: Radio
    .word common_wrapper + 1    @ 17: Audio
    .word common_wrapper + 1    @ 18: Thermometer
    .word common_wrapper + 1    @ 19: Gyrometer
    .word common_wrapper + 1    @ 20: Button-A
    .word common_wrapper + 1    @ 21: Button-B

.thumb_func
common_wrapper:
    PUSH {r4-r11}       @ The hardware saved r0-r3; we save the rest manually
    MRS r0, IPSR        @ Read the "Interrupt Program Status Register" 
                        @ (This tells us WHICH interrupt number just fired!)
    BL c_kernel_logic   @ Jump to a C function, passing the IRQ number in r0
    POP {r4-r11}        @ Restore the "Nomad" state
    BX lr               @ Special return: Tells hardware to restore r0-r3 and go back

.section .text         @ THE CODE SECTION
_start:

loop:
    B loop             @ Infinite loop
