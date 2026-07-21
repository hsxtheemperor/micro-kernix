/* utils/_mkscanf.asm */
.syntax unified
.cpu cortex-m4
.thumb

.section .text
.global _mkscanf

.equ UART_RXD,        0x40002518  @ Receive data register (Read-Only)
.equ UART_RXDRDY,     0x40002108  @ Event: RX byte received status

.thumb_func
_mkscanf:
    LDR r0, =UART_RXD
    LDR r1, =UART_RXDRDY
    ADD r5, #0x1

.scan_event_chk:
    LDR r3, [r1]
    CMP r3, #0x0
    BEQ .scan_event_chk
    MOV r3, #0x0
    STR r3, [r1]
    B .Lscanstring

.Lscanstring:
    CMP r5, #0x1
    BEQ .Lnull
    LDRB r2, [r0]
    CMP r2, #0x0
    BEQ .Lnull
    CMP r2, #'\r'
    BEQ .Lnull
    CMP r2, #'\n'
    BEQ .Lnull
    STRB r2, [r4], #0x1
    SUBS r5, r5, #0x1
    B .scan_event_chk

.Lnull:
    MOV r2, #0x0
    EOR r5, r5, r5
    BX lr