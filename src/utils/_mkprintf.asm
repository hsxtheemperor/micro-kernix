/* utils/_mkprintf.asm */
.syntax unified
.cpu cortex-m4
.thumb

.section .text
.global print

/* LEGACY */

.equ UART_TXD,        0x4000251C  ; Transmit data register
.equ UART_TXDRDY,     0x4000211C  ; Event: TX byte sent status

print:
    LDRB r1, [r4], #0x1             ; Load byte from MESSAGE and increment pointer
    CMP r1, #0x0                    ; Check for null terminator
    BEQ _loop                       ; If null terminator, exit
    BL print_char                   ; Call print_char to send the character
    BL _poll
    B print                         ; Repeat for next character

print_char:
    LDR r0, =UART_TXD
    STR r1, [r0]
    BX lr

_poll:
    LDR r6, [r5]
    CMP r6, #0x1
    BNE _poll
    MOV r6, #0x0
    STR r6, [r5]
    BX lr

_exit:
    MOV r12, #0x0                   ; EXIT CODE
    B _exit                         ; Trap the CPU here forever so it doesn't crash!