/* utils/_mkpidtable.asm */
.syntax unified
.cpu cortex-m4
.thumb

.section .text
.global _ekernel
.global _estack
.global _mkpidtableentry_creat
.global _creat_kernel_pid
.global _update_kernel_state

.equ PCB_SP,        0x00
.equ PCB_PID,       0x04
.equ PCB_STATE,     0x06
.equ PCB_PRIO,      0x07

.equ PCB_SIZE,      8

.equ TABLE_SIZE,    80

/* PCB (Process Control Block) layout, 8 bytes per entry:
   offset 0x00 (4B): saved stack pointer (SP)
   offset 0x04 (2B): PID
   offset 0x06 (1B): STATE (0 = free/dead, nonzero = alive)
   offset 0x07 (1B): PRIO (priority)
   Slot 0 is reserved for the kernel itself and is skipped. */

/*
    STATE: 
    0x00 -> DEAD
    0x01 -> INTIALISATING MEMORY
    0x02 -> READY
    0x03 -> ACTIVE
*/

.thumb_func
_mkpidtableentry_creat:
.init_pid_table:
    LDR r0, =_ekernel
    EOR r1, r1, r1
    ADD r1, r0, #(PCB_SIZE)

.find_pid_entry:
    LDRH r2, [r0, #PCB_PID]
    LDRB r3, [r1, #PCB_STATE]
    ADD r0, r0, #PCB_SIZE
    ADD r1, r1, #PCB_SIZE
    

    CMP r3, #0x0
    BNE .find_pid_entry

.create_pid_entry:
    ADD r2, r2, #0x1
    STRH r2, [r1, #PCB_PID]
    MOV r3, #0x01
    STRB r3, [r1, #PCB_STATE]
    STRB r4, [r1, #PCB_PRIO]
    /* Add Method for sp */
    BX lr

_creat_kernel_pid:
    LDR r0, =_ekernel
    LDR r1, =_estack
    STR r1, [r0]
    MOV r1, #0x0
    STRH r1, [r0, #PCB_PID]
    MOV r2, #0x03
    STRB r2, [r0, #PCB_STATE]
    MOV r3, #0xFF
    STRB r3, [r0, #PCB_PRIO]
    BX lr

_update_kernel_state: /* sets kernel STATE to value in r2 */
    LDR r0, =_ekernel
    STRB r2, [r0, #PCB_STATE]
    BX lr
