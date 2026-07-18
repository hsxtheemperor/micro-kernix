/* kernel/sysexcp.asm */

.syntax unified
.cpu cortex-m4
.thumb

/* ========================================================================== */
/*           ARM CORTEX-M4 CUSTOM FAULT ENGINE REGISTER ALLOCATION FILE      */
/* ========================================================================== */
/* 
    r0  = ADDRESS POINTER REGISTER       (Loads peripheral base addresses)
    r1  = PRIMARY VALUE REGISTER         (Acts as global tracking / context token)
    r2  = AUXILIARY VALUE REGISTER       (Isolates specific MMFSR / BFSR / UFSR flags)
    r3  = MMFAR STORAGE REGISTER         (Locks the Memory Management Fault Address)
    r4  = BFAR STORAGE REGISTER          (Locks the Bus Fault Address)
    r5  = LIVE VERIFICATION REGISTER     (Scratch register for token comparison)
    r6  = GENERAL PURPOSE / RESERVED     (Available scratch space)
    r7  = GENERAL PURPOSE / RESERVED     (Available scratch space)
    
    -- UPPER REGISTERS (Must be manipulated carefully in Thumb state) --
    r8  = GENERAL PURPOSE / RESERVED     (Available scratch space)
    r9  = GENERAL PURPOSE / RESERVED     (Available scratch space)
    r10 = GENERAL PURPOSE / RESERVED     (Available scratch space)
    r11 = GENERAL PURPOSE / RESERVED     (Available scratch space)
    r12 = INTRA-PROCEDURE SCRATCH (IP)   (Available scratch space)
    
    -- SPECIAL CORE REGISTERS --
    sp  = STACK POINTER (SP)             (Tracks active stack frame)
    lr  = LINK REGISTER (LR)             (Tracks subroutine returns / EXC_RETURN codes)
    pc  = PROGRAM COUNTER (PC)           (Points to next executing instruction)
    xPSR= PROGRAM STATUS REGISTER        (Holds ALU flags and current Execution ISR number)
*/


/* ========================================================================== */
/*                          EXCEPTION MMIO ADDRESS                            */
/* ========================================================================== */

@ System Non-Maskable Interrupts
.equ SCB_ICSR,      0xE000ED04  @ Interrupt Control and State Register

@ Configurable Fault Status Register (Consists of MMFSR, BFSR, and UFSR)
.equ SCB_CFSR,      0xE000ED28  
.equ SCB_MMFSR,     0xE000ED28  @ Byte access: Memory Management Fault Status
.equ SCB_BFSR,      0xE000ED29  @ Byte access: Bus Fault Status
.equ SCB_UFSR,      0xE000ED2A  @ Half-word access: Usage Fault Status

@ HardFault Status Register (Indicates escalation reasons)
.equ SCB_HFSR,      0xE000ED2C  

@ Fault Address Registers (Capture the exact offending memory locations)
.equ SCB_MMFAR,     0xE000ED34  @ Memory Management Fault Address Register
.equ SCB_BFAR,      0xE000ED38  @ Bus Fault Address Register

.equ SENTIAL_VAL,   0xFFFFFFFF  @ SENTIAL VALUE

/* ========================================================================== */
/*                      EXCEPTION HANDLER ROUTINES                            */
/* ========================================================================== */
.section .text
.global nmi_handler
.global hard_fault
.global mem_manage
.global bus_fault
.global usage_fault
.global svc_handler
.global debug_mon
.global pendsv_handler
.global sys_tick

/* ========================================================================== */
/*           ARM CORTEX-M4 SYSTEM CONTROL BLOCK (SCB) FAULT HANDLERS          */
/* ========================================================================== */

/* NON-MASKABLE INTERRUPT HANDLER */
.thumb_func
nmi_handler:
    LDR r0, =SCB_ICSR
    LDR r1, [r0]
/* COMPLETE AT LAST!*/
    BL _exit

/* HARDFAULT HANDLER */
.thumb_func
hard_fault:
    LDR r0, =SCB_HFSR
    LDR r1, [r0]

    TST r1, #0x2
    BNE vector_table_fault

    TST r1, #(1 << 30)
    BNE sub_hard_fault

    TST r1, #(1 << 31)
    BNE hard_fault

.thumb_func
vector_table_fault:
    LDR r0, =SENTIAL_VAL
    /* Add Report Process Later */
    MOV r1, #0x1
    BL _exit

.thumb_func
sub_hard_fault:
    LDR r0, =SCB_CFSR
    LDRB r1, [r0]

    BL mem_manage              
    BL bus_fault
    BL usage_fault

    BL _exit

/* SUB-HARD FAULTS HANDLERS */
mem_manage:
    LDR r0, =SCB_MMFSR
    LDRB r2, [r0]
    LSL r2, r2, #24
    LDR r0, =SCB_MMFAR
    LDR r3, [r0]
    LDR r0, =SCB_CFSR
    LDRB r5, [r0]
    CMP r1, r5
    BNE _exit
    BX lr

bus_fault:
    LDR r0, =SCB_BFSR
    LDRB r2, [r0]
    LSL r2, r2, #16
    LDR r0, =SCB_BFAR
    LDR r4, [r0]
    LDR r0, =SCB_CFSR
    LDRB r5, [r0]
    CMP r1, r5
    BNE _exit
    BX lr

usage_fault:
    LDR r0, =SCB_UFSR
    LDRH r2, [r0]
    LDR r0, =SCB_CFSR
    LDRB r5, [r0]
    CMP r1, r5
    BNE _exit
    BX lr

/* ========================================================================== */
/*           ARM CORTEX-M4 SYSTEM CONTROL BLOCK (SCB) SYSCALL                 */
/* ========================================================================== */

svc_handler:
    
