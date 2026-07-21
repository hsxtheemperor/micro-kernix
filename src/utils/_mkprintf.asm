/* utils/_mkprintf.asm */
.syntax unified
.cpu cortex-m4
.thumb

.section .text
.global _mkprintf

.equ UART_TXD,        0x4000251C  ; Transmit data register
.equ UART_TXDRDY,     0x4000211C  ; Event: TX byte sent status

.thumb_func
_mkprintf:
    EOR r5, r5, r5
    LDR r0, =UART_TXD
    LDR r1, =UART_TXDRDY

.Lprintstring:
    LDRB r2, [r4], #0x1
    CMP r2, #0x0
    BXEQ lr
    STRB r2, [r0]
    B print_event_chk
    B .Lprintstring

.print_event_chk:
    LDR r3, [r1]
    CMP r3, #0x0
    BEQ .print_event_chk
    ADD r5, r5, #0x1
    MOV r3, #0x0
    STR r3, [r1]
    B .Lprintstring