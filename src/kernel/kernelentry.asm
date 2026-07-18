/* kernel/kernelentry.asm */
.syntax unified
.cpu cortex-m4
.thumb

.section .text
.global _kernel

_kernel:
    ; Test Case A: Force a system call route
    SVC #0x01
    
    ; Test Case B: Force a UsageFault (Unsigned divide by zero if enabled, or invalid execution status)
    UDIV r0, r0, #0

    B _exit