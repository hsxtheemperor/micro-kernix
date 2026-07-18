/* kernelentry.asm */

.syntax unified
.cpu cortex-m4
.thumb

.section text
.global _kernel

_kernel:
    /* Kernel Entry */
    _exit