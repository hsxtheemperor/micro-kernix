/* kernel/kernelentry.asm */
.syntax unified
.cpu cortex-m4
.thumb

.section .text
.global _kernel
.global _kernel_idle
.global _ekernel
.global _estack
.global _creat_kernel_pid
.global _update_kernel_state

_kernel:
    ; Test Case A: Force a system call route
    SVC #0x01
    
    ; Test Case B: Force a UsageFault (Unsigned divide by zero if enabled, or invalid execution status)
    UDIV r0, r0, #0

    SVC #0x0

_kernel_idle: 
    MOV r2, #0x02
    BL _update_kernel_state
    CPSID i
    WFI
    CPSIE i
    MOV r2, #0x03
    BL _update_kernel_state
    BX lr
